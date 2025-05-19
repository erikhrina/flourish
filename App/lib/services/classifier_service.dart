import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierService {
  late final Interpreter _interpreter;

  ClassifierService._create(this._interpreter);

  /// Factory method to asynchronously create and initialize the service.
  static Future<ClassifierService> create() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/models/plant_classifier.tflite',
    );
    return ClassifierService._create(interpreter);
  }

  /// Get prediction based on a JPG image
  int predict(Uint8List jpgImage) {
    // Preprocess the image
    List<double> input = _preprocessImage(jpgImage);

    // Run the model
    List<double> output = _runModel(input);

    // Interpret the output
    int id = _interpretOutput(output);

    print('Predicted ID: $id');

    return id;
  }

  /// Run model to get a prediction
  List<double> _runModel(List<double> input) {
    // Define input and output shapes
    var outputShape = _interpreter.getOutputTensor(0).shape;
    var output = List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

    // Reshape input for model compatibility
    var reshapedInput = input.reshape([1, 224, 224, 3]);

    // Run the model
    _interpreter.run(reshapedInput, output);

    // Close the interpreter
    _interpreter.close();

    return output[0].cast<double>();
  }

  /// Preprocess an image for use by the classifier
  List<double> _preprocessImage(Uint8List imageBytes) {
    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Failed to decode the image.");
    }

    // Resize to 224x224
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Normalize pixel values to range [0, 1] and flatten
    List<double> input = resizedImage
        .getBytes()
        .map((pixel) => pixel / 255.0) // Normalize
        .toList();

    return input;
  }

  /// Interpret the output of a model and return an id
  int _interpretOutput(List<double> modelOutput) {
    // Find the index of the maximum probability
    int predictedLabelIndex = modelOutput.indexWhere(
        (value) => value == modelOutput.reduce((a, b) => a > b ? a : b));

    // Return the ID of a plant
    return predictedLabelIndex + 1;
  }

  /// Close the interpreter when done
  void dispose() {
    _interpreter.close();
  }
}
