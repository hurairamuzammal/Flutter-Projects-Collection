// ...existing code...
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Interpreter? interpreter;
  File? selectedImage;
  String prediction = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    setState(() {
      isLoading = true;
    });
    try {
      interpreter = await Interpreter.fromAsset('model.tflite');
      print('Model loaded successfully.');
    } catch (e) {
      print('Failed to load model: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        prediction = "";
      });
    }
  }

  List<List<List<List<int>>>>? preprocessImage(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) return null;
    final resizedImage = img.copyResize(image, width: 299, height: 299);
    final input = List.generate(
      1,
      (_) => List.generate(
        299,
        (y) => List.generate(299, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
        }),
      ),
    );
    return input;
  }

  Future<void> runInference() async {
    if (interpreter == null || selectedImage == null) {
      setState(() {
        prediction = "Model not loaded or no image selected.";
      });
      return;
    }
    setState(() {
      isLoading = true;
    });
    final preprocessedData = preprocessImage(selectedImage!);
    if (preprocessedData == null) {
      setState(() {
        prediction = "Failed to preprocess image.";
        isLoading = false;
      });
      return;
    }
    var output = List.filled(1, List.filled(2, 0.0));
    try {
      interpreter!.run(preprocessedData, output);
      final result = output[0];
      setState(() {
        if (result[0] > result[1]) {
          prediction = "Prediction: Cat";
        } else {
          prediction = "Prediction: Dog";
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        prediction = 'Inference failed: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cat vs Dog Classifier',
          style: GoogleFonts.poppins(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isLoading) ...[
                CircularProgressIndicator(color: colorScheme.primary),
                const SizedBox(height: 20),
              ],
              selectedImage == null
                  ? Text(
                      'No image selected.',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(selectedImage!, height: 300),
                    ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => pickImage(fromCamera: false),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => pickImage(fromCamera: true),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.tertiary,
                  foregroundColor: colorScheme.onTertiary,
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: runInference,
                child: const Text('Run Inference'),
              ),
              const SizedBox(height: 28),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: prediction.isEmpty
                    ? const SizedBox.shrink()
                    : Text(
                        prediction,
                        key: ValueKey(prediction),
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
