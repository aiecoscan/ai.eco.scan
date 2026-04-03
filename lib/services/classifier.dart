import 'dart:io';
import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// This class handles all the "Heavy Lifting" for the AI model
class Classifier {
  Interpreter? _interpreter;

  // Initialize the model
  Future<void> init() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("LOG: Model loaded successfully in Classifier.");
    } catch (e) {
      print("LOG: ERROR - Failed to load model: $e");
    }
  }

  /// The main function you will call from your UI
  /// Takes a File (the image) and returns a Map with label and score
  Future<Map<String, dynamic>> classify(File imageFile) async {
    if (_interpreter == null) {
      await init();
      if (_interpreter == null) return {"label": "Error", "score": 0.0};
    }

    try {
      // 1. Get model requirements
      var inputShape = _interpreter!.getInputTensor(0).shape;
      int modelHeight = inputShape[1];
      int modelWidth = inputShape[2];

      // 2. Pre-process Image
      var imageBytes = await imageFile.readAsBytes();
      var decodedImage = img.decodeImage(imageBytes)!;
      var resized = img.copyResize(
        decodedImage,
        width: modelWidth,
        height: modelHeight,
      );

      // 3. Normalize pixels (Float32 conversion)
      var input = Float32List(1 * modelHeight * modelWidth * 3);
      var buffer = Float32List.view(input.buffer);
      int pixelIndex = 0;
      for (var y = 0; y < modelHeight; y++) {
        for (var x = 0; x < modelWidth; x++) {
          var pixel = resized.getPixel(x, y);
          buffer[pixelIndex++] = pixel.r / 255.0;
          buffer[pixelIndex++] = pixel.g / 255.0;
          buffer[pixelIndex++] = pixel.b / 255.0;
        }
      }

      // 4. Run Inference (Object Detection parsing)
      var outputShape = _interpreter!.getOutputTensor(0).shape;
      var outputBuffer = List.filled(
        outputShape.reduce((a, b) => a * b),
        0.0,
      ).reshape(outputShape);
      _interpreter!.run(input.reshape(inputShape), outputBuffer);

      // 5. Parse Detection Output (Looking for Best Box)
      var rawValues = outputBuffer
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');
      List<double> values = rawValues
          .map((s) => double.parse(s.trim()))
          .toList();

      double bestScore = -1.0;
      double bestClass = -1.0;

      // Iterating through output groups of 6 (typical for object detectors)
      for (int i = 0; i < values.length - 5; i += 6) {
        double score = values[i + 4]; // Confidence Score
        double classId = values[i + 5]; // Category Index
        if (score > bestScore && score <= 1.0) {
          bestScore = score;
          bestClass = classId;
        }
      }

      // 6. Return Clean Result
      if (bestScore < 0.2) return {"label": "No Waste Detected", "score": 0.0};

      String label = (bestClass == 0.0 || bestClass == 1.0)
          ? "PLASTIC"
          : "METAL";
      return {"label": label, "score": bestScore};
    } catch (e) {
      print("LOG: Classification Error: $e");
      return {"label": "Error", "score": 0.0};
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
