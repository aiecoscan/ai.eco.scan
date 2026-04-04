// ============================================================
// AUTH SERVICE
// ============================================================
// This service is the ONLY place in the app that reads/writes
// user data from/to Hive. Every screen that needs user info
// calls a method here — no screen touches Hive directly.
//
// Covers: Users table + Admins table from your DB schema.
// ============================================================
// ============================================================
// AUTH SERVICE — Fixed
// ============================================================
// Bug fixes in this version:
//
// BUG 1 FIX — Registration crash:
//   Root cause: the old code tried to store a UserModel object
//   under the string key "currentUserId" inside a Box<UserModel>.
//   Hive typed boxes store values by key, but when you mix
//   string keys with object values AND the session key in the
//   same box, Hive crashes on the second .put() call because
//   it tries to cast String -> UserModel internally.
//   The user WAS saved on the first .put() (step 6 succeeded),
//   so a retry found "already exists" — exactly what you saw.
//
//   Fix: use a SEPARATE plain Box (no type parameter) just for
//   the session ID string. Never mix session data into the
//   typed user box.
//
// BUG 2 FIX — isLoading stuck:
//   _saveSession() was an empty function body — it literally
//   did nothing. This is fixed here (session now saves for real)
//   but the isLoading fix lives in login.dart's finally block.
// ============================================================

import 'dart:convert';
import 'package:crypto/crypto.dart'; // For SHA-256 password hashing
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../models/hive_init.dart';

// ── Custom Exceptions ────────────────────────────────────────
// These give screens meaningful error messages to show users.
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  // ── Private Box Accessor ─────────────────────────────────
  // This is the ONLY line in the whole service that mentions Hive.
  // Everything else works with UserModel objects.
  static Box<UserModel> get _box => Hive.box<UserModel>(HiveInit.userBox);

  // Separate untyped box for session ID string only
  // This is the critical fix — never put session data in the typed box
  static Box get _sessionBox => Hive.box(HiveInit.sessionBox);

  // ============================================================
  // REGISTER
  // ============================================================
  // Called from signup.dart when user presses "Sign Up".
  // Creates a new user and saves them to Hive.
  //
  // Maps to INSERT INTO Users (name, email, password, phone...)
  // ============================================================
  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // 1. Validate inputs — throw early with clear messages
    if (name.trim().isEmpty) throw AuthException('Name cannot be empty');
    if (!email.contains('@')) throw AuthException('Invalid email address');
    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    // 2. Check if email already exists
    //    Maps to: SELECT * FROM Users WHERE email = ?
    final emailNormalized = email.toLowerCase().trim();
    final exists = _box.values.any((u) => u.email == emailNormalized);
    if (exists)
      throw AuthException('An account with this email already exists');

    // 3. Hash the password — NEVER store plain text passwords
    //    We use SHA-256 from the 'crypto' package.
    //    In a real app you'd use bcrypt, but crypto is fine for local storage.
    final passwordHash = _hashPassword(password);

    // 4. Generate a simple unique ID
    //    We use timestamp + email hash for uniqueness without uuid package.
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    // 5. Create the UserModel object
    final user = UserModel(
      id: id,
      name: name.trim(),
      email: emailNormalized,
      passwordHash: passwordHash,
      phone: phone.trim(),
      totalPoints: 0,
      createdAt: DateTime.now(),
      isAdmin: false,
    );

    // 6. Save to Hive — using the user's ID as the key
    //    Maps to: INSERT INTO Users VALUES (...)
    //    FIX: removed the broken second put() that was crashing
    await _box.put(user.id, user);

    // 7. Save session so user stays logged in
    //    FIX: this actually saves now (was empty function before)
    await _sessionBox.put(HiveInit.sessionKey, user.id);

    return user;
  }

  // ============================================================
  // LOGIN
  // ============================================================
  // Called from login.dart when user presses "Log In".
  // Finds the user by email and verifies password.
  //
  // Maps to: SELECT * FROM Users WHERE email = ? AND password = ?
  // (but we compare hashes, not plain text)
  // ============================================================
  static Future<UserModel> login({
    required String emailOrUsername,
    required String password,
  }) async {
    // Special case: hardcoded admin login (keeps your existing behavior)
    // but now it creates/finds a real admin UserModel in Hive
    if (emailOrUsername == 'admin' && password == 'sambosa') {
      final admin = await _getOrCreateAdmin();
      await _sessionBox.put(HiveInit.sessionKey, admin.id);
      return admin;
    }

    // 1. Find user by email
    final input = emailOrUsername.toLowerCase().trim();
    UserModel? found;
    for (final u in _box.values) {
      if (u.email == input || u.name.toLowerCase() == input) {
        found = u;
        break;
      }
    }

    if (found == null) {
      throw AuthException('No account found with that email or username');
    }

    // 2. Verify password by hashing and comparing
    if (found.passwordHash != _hashPassword(password)) {
      throw AuthException('Incorrect password');
    }

    // 3. Save session — store user ID so we can restore on restart
    await _sessionBox.put(HiveInit.sessionKey, found.id);

    return found;
  }

  // ============================================================
  // GET (CURRENT) USER
  // ============================================================
  // Called by HomeScreen, GreenPointsScreen, ScanScreen, etc.
  // Returns the currently logged-in user, or null if nobody is.
  //
  // This replaces all the hardcoded "Welcome Back, User" strings.
  // ============================================================
  // ============================================================
  // GET SESSION USER
  // ============================================================
  // Reads the session ID from the plain box, then fetches the
  // UserModel from the typed box by that ID. Safe and clean.
  static UserModel? getSessionUser() {
    try {
      final sessionId = _sessionBox.get(HiveInit.sessionKey) as String?;
      if (sessionId == null) return null;
      return _box.get(sessionId); // direct key lookup — O(1)
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // UPDATE POINTS
  // ============================================================
  // Called internally by PointsService when a scan earns points.
  // Keeps UserModel.totalPoints in sync with PointsDataModel.
  //
  // Maps to: UPDATE Users SET total_points = total_points + ? WHERE user_id = ?
  // ============================================================
  static Future<void> addPointsToUser(String userId, int points) async {
    final user = _box.get(userId);
    if (user == null) return;
    user.totalPoints += points;
    await user.save(); // HiveObject.save() updates in place
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  static Future<void> logout() async {
    // We don't delete the user — just clear the session marker.
    // In your app this would navigate back to login.
    await _sessionBox.delete(HiveInit.sessionKey);
  }

  // ============================================================
  // CHECK IF LOGGED IN
  // ============================================================
  // Used in main.dart to decide whether to show login or home screen.
  static bool isLoggedIn() {
    final sessionId = _sessionBox.get(HiveInit.sessionKey) as String?;
    return sessionId != null && _box.containsKey(sessionId);
  }

  // ── Private Helpers ──────────────────────────────────────────

  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<UserModel> _getOrCreateAdmin() async {
    for (final u in _box.values) {
      if (u.isAdmin) return u;
    }
    final admin = UserModel(
      id: 'admin_001',
      name: 'Admin',
      email: 'admin@ecoscan.com',
      passwordHash: _hashPassword('sambosa'),
      phone: '',
      totalPoints: 0,
      createdAt: DateTime.now(),
      isAdmin: true,
    );
    await _box.put(admin.id, admin);
    return admin;
  }
}
