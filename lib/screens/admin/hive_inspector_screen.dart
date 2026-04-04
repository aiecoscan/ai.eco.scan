// ============================================================
// HIVE INSPECTOR SCREEN
// ============================================================
// A developer/admin tool that lets you browse all data stored
// in every Hive box — like an SQLite viewer but for Hive.
//
// Features:
//   - Tab per box (Users, Scans, Points, Session)
//   - Each row shows the key + a formatted view of the value
//   - Tap any row to expand full details
//   - Delete individual records
//   - Box-level stats (entry count, etc.)
//   - Color-coded by data type
// ============================================================
// ============================================================
// HIVE INSPECTOR SCREEN — Updated
// ============================================================
// Change: Scan record deletion now cascades to points.
//
// OLD behaviour:
//   await box.delete(key)  ← just removes the row, points stay wrong
//
// NEW behaviour:
//   await ScanService.deleteScanAndReversePoints(scanId)
//   This internally:
//     1. Reads the scan to get userId, pointsEarned, weightGrams
//     2. Calls PointsService.removeScanPoints() to subtract them
//     3. Calls AuthService.addPointsToUser(userId, -points)
//     4. THEN deletes the scan record
//
// Everything else (Users, Points, Session tabs) is unchanged.
// ============================================================

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:eco_scan/models/hive_init.dart';
import 'package:eco_scan/models/user_model.dart';
import 'package:eco_scan/models/scan_log_model.dart';
import 'package:eco_scan/models/points_data_model.dart';
import 'package:eco_scan/services/scan_service.dart'; // NEW

class HiveInspectorScreen extends StatefulWidget {
  const HiveInspectorScreen({super.key});

  @override
  State<HiveInspectorScreen> createState() => _HiveInspectorScreenState();
}

class _HiveInspectorScreenState extends State<HiveInspectorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // The 4 boxes we want to inspect
  final List<String> _boxNames = [
    HiveInit.userBox,
    HiveInit.scanBox,
    HiveInit.pointsBox,
    HiveInit.sessionBox,
  ];

  final List<String> _tabLabels = ['Users', 'Scans', 'Points', 'Session'];
  final List<IconData> _tabIcons = [
    Icons.person,
    Icons.document_scanner,
    Icons.eco,
    Icons.key,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _boxNames.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Refresh all tabs ──────────────────────────────────────
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011C14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF013C2E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF9AE600)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.storage, color: Color(0xFF9AE600), size: 22),
            SizedBox(width: 8),
            Text(
              'Hive Inspector',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Economica',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            // Refresh button
            icon: const Icon(Icons.refresh, color: Color(0xFF9AE600)),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF9AE600),
          labelColor: const Color(0xFF9AE600),
          unselectedLabelColor: Colors.white38,
          tabs: List.generate(_tabLabels.length, (i) {
            // Get entry count for badge
            int count = 0;
            try {
              count = Hive.box(_boxNames[i]).length;
            } catch (_) {}

            return Tab(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_tabIcons[i], size: 18),
                  Text(
                    '${_tabLabels[i]} ($count)',
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            );
          }),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          _UsersBoxView(onChanged: _refresh),
          _ScansBoxView(
            onChanged: _refresh,
          ), // passes _refresh so it triggers setState
          _PointsBoxView(onChanged: _refresh),
          _SessionBoxView(onChanged: _refresh),
        ],
      ),
    );
  }
}

// ============================================================
// USERS BOX TAB
// ============================================================
class _UsersBoxView extends StatelessWidget {
  final VoidCallback onChanged;
  const _UsersBoxView({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<UserModel>(HiveInit.userBox);
    final keys = box.keys.toList();

    if (keys.isEmpty) {
      return const _EmptyState(message: 'No users registered yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        final key = keys[i];
        final user = box.get(key);
        if (user == null) return const SizedBox();

        return _InspectorCard(
          title: user.name,
          subtitle: user.email,
          badge: user.isAdmin ? 'ADMIN' : 'USER',
          badgeColor: user.isAdmin ? Colors.orange : const Color(0xFF9AE600),
          keyString: 'Key: $key',
          onDelete: () async {
            final confirm = await _confirmDelete(context, user.name);
            if (confirm) {
              await box.delete(key);
              onChanged();
            }
          },
          fields: {
            'ID': user.id,
            'Name': user.name,
            'Email': user.email,
            'Phone': user.phone.isEmpty ? '(not set)' : user.phone,
            'Total Points': '${user.totalPoints} pts',
            'Is Admin': user.isAdmin ? 'Yes' : 'No',
            'Created At': _formatDate(user.createdAt),
            'Password Hash':
                '${user.passwordHash.substring(0, 16)}... (SHA-256)',
          },
        );
      },
    );
  }
}

// ============================================================
// SCANS BOX TAB — Updated delete to cascade to points
// ============================================================
class _ScansBoxView extends StatelessWidget {
  final VoidCallback onChanged;
  const _ScansBoxView({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ScanLogModel>(HiveInit.scanBox);
    final keys = box.keys.toList();

    if (keys.isEmpty) {
      return const _EmptyState(
        message: 'No scans recorded yet.\nScan some waste first!',
      );
    }

    // Show newest first
    keys.sort((a, b) => b.toString().compareTo(a.toString()));

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        final key = keys[i];
        final scan = box.get(key);
        if (scan == null) return const SizedBox();

        return _InspectorCard(
          title: scan.wasteType,
          subtitle:
              '${scan.timeDisplay} · ${scan.confidenceDisplay} confidence',
          badge: '+${scan.pointsEarned} pts',
          badgeColor: const Color(0xFF9AE600),
          keyString:
              'Key: ${key.toString().length > 12 ? key.toString().substring(0, 12) + "..." : key}',
          onDelete: () async {
            // CHANGED: show what will be reversed in the confirm dialog
            final confirm = await _confirmDeleteScan(
              context,
              scan.wasteType,
              scan.pointsEarned,
            );

            if (confirm) {
              // NEW: cascading delete — reverses points before deleting
              // ScanService.deleteScanAndReversePoints() does:
              //   1. PointsService.removeScanPoints(userId, points, weight)
              //   2. AuthService.addPointsToUser(userId, -points)
              //   3. box.delete(scanId)
              await ScanService.deleteScanAndReversePoints(scan.id);
              onChanged();
            }
          },
          fields: {
            'Scan ID': scan.id,
            'User ID': scan.userId,
            'Waste Type': scan.wasteType,
            'Confidence': scan.confidenceDisplay,
            'Weight': scan.weightDisplay,
            'Points Earned': '${scan.pointsEarned} pts',
            'Status': scan.status,
            'Scanned At': _formatDate(scan.scannedAt),
            'Image Path': scan.imagePath.isEmpty ? '(no path)' : scan.imagePath,
          },
        );
      },
    );
  }
}

// ============================================================
// POINTS BOX TAB
// ============================================================
class _PointsBoxView extends StatelessWidget {
  final VoidCallback onChanged;
  const _PointsBoxView({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<PointsDataModel>(HiveInit.pointsBox);
    final keys = box.keys.toList();

    if (keys.isEmpty) {
      return const _EmptyState(message: 'No points data yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: keys.length,
      itemBuilder: (context, i) {
        final key = keys[i];
        final data = box.get(key);
        if (data == null) return const SizedBox();

        return _InspectorCard(
          title:
              'Points — User ${data.userId.length > 8 ? data.userId.substring(0, 8) : data.userId}...',
          subtitle:
              '${data.totalPoints} total points · ${data.recycledTimes} scans',
          badge: '${data.treesSaved} 🌳',
          badgeColor: const Color(0xFF2E7D32),
          keyString: 'Key: $key',
          onDelete: () async {
            final confirm = await _confirmDelete(context, 'points data');
            if (confirm) {
              await box.delete(key);
              onChanged();
            }
          },
          fields: {
            'User ID': data.userId,
            'Total Points': '${data.totalPoints}',
            'Recycled Weight': data.recycledWeightDisplay,
            'Recycled Times': '${data.recycledTimes}',
            'Trees Saved': '${data.treesSaved}',
            'Transaction Count': '${data.rewardTypes.length}',
            if (data.rewardTypes.isNotEmpty)
              'Recent Transactions': List.generate(
                data.rewardTypes.length > 5 ? 5 : data.rewardTypes.length,
                (j) {
                  final idx = data.rewardTypes.length - 1 - j;
                  return '${data.rewardTypes[idx]}: +${data.pointAmounts[idx]} pts';
                },
              ).join('\n'),
          },
        );
      },
    );
  }
}

// ============================================================
// SESSION BOX TAB
// ============================================================
class _SessionBoxView extends StatelessWidget {
  final VoidCallback onChanged;
  const _SessionBoxView({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box(HiveInit.sessionBox);
    final sessionId = box.get(HiveInit.sessionKey) as String?;

    // Also resolve the actual user from the session
    UserModel? sessionUser;
    if (sessionId != null) {
      sessionUser = Hive.box<UserModel>(HiveInit.userBox).get(sessionId);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: sessionId != null
                  ? const Color(0xFF1B5E20).withOpacity(0.6)
                  : const Color(0xFF4E0000).withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: sessionId != null
                    ? const Color(0xFF9AE600)
                    : Colors.redAccent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  sessionId != null ? Icons.lock_open : Icons.lock,
                  color: sessionId != null
                      ? const Color(0xFF9AE600)
                      : Colors.redAccent,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionId != null ? 'LOGGED IN' : 'NOT LOGGED IN',
                        style: TextStyle(
                          color: sessionId != null
                              ? const Color(0xFF9AE600)
                              : Colors.redAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (sessionId != null)
                        Text(
                          'Session ID: $sessionId',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Resolved user info
          if (sessionUser != null) ...[
            const Text(
              'Resolved User',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            _FieldCard(
              fields: {
                'Name': sessionUser.name,
                'Email': sessionUser.email,
                'Role': sessionUser.isAdmin ? 'Admin' : 'User',
                'Points': '${sessionUser.totalPoints} pts',
              },
            ),
          ],

          if (sessionId == null)
            const _EmptyState(
              message: 'No active session.\nLog in to create one.',
            ),

          const Spacer(),

          // Clear session button
          if (sessionId != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4E0000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text(
                  'Clear Session (Force Logout)',
                  style: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                onPressed: () async {
                  await box.delete(HiveInit.sessionKey);
                  onChanged();
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// REUSABLE WIDGETS
// ============================================================

class _InspectorCard extends StatefulWidget {
  final String title, subtitle, badge, keyString;
  final Color badgeColor;
  final Map<String, String> fields;
  final VoidCallback onDelete;

  const _InspectorCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.keyString,
    required this.fields,
    required this.onDelete,
  });

  @override
  State<_InspectorCard> createState() => _InspectorCardState();
}

class _InspectorCardState extends State<_InspectorCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF012E22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _expanded
              ? const Color(0xFF9AE600).withOpacity(0.5)
              : Colors.white10,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.badgeColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.badgeColor.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      widget.badge,
                      style: TextStyle(
                        color: widget.badgeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(color: Colors.white10, height: 1),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.keyString,
                      style: const TextStyle(
                        color: Colors.white30,
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _FieldCard(fields: widget.fields),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(
                          color: Colors.redAccent,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete this record'),
                      onPressed: widget.onDelete,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Field display table ───────────────────────────────────────

class _FieldCard extends StatelessWidget {
  final Map<String, String> fields;
  const _FieldCard({required this.fields});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: fields.entries.map((entry) {
          final isLast = entry.key == fields.keys.last;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Color(0xFF00D492),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox_outlined, color: Colors.white24, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white38, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// ── Delete confirmation dialog ────────────────────────────────
// ── Confirm delete (generic) ──────────────────────────────────
Future<bool> _confirmDelete(BuildContext context, String name) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF013C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete Record?',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'Delete "$name"?\nThis cannot be undone.',
        style: const TextStyle(color: Colors.white60),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF9AE600)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

// ── Confirm delete scan — shows what will be reversed ─────────
Future<bool> _confirmDeleteScan(
  BuildContext context,
  String wasteType,
  int points,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF013C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete Scan Record?',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        'This will delete the $wasteType scan and reverse '
        '$points points from the user\'s balance.\n\n'
        'This cannot be undone.',
        style: const TextStyle(color: Colors.white60),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF9AE600)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text(
            'Delete & Reverse',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

String _formatDate(DateTime dt) {
  return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:'
      '${dt.minute.toString().padLeft(2, '0')}:'
      '${dt.second.toString().padLeft(2, '0')}';
}
