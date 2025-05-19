import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flourish/models/plant_model.dart';
import 'package:flourish/pages/detail/detail_page.dart';
import 'package:flourish/services/classifier_service.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flourish/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flourish/services/images_service.dart';
import 'package:flourish/widgets/navigation_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late CameraController _cameraController;
  final _imagesService = ImagesService();
  final _objectboxService = GetIt.instance<ObjectboxService>();
  final _classifierService = GetIt.instance<ClassifierService>();
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    if (context.mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    if (_cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  void _toggleFlash() async {
    if (_isFlashOn) {
      await _cameraController.setFlashMode(FlashMode.off);
    } else {
      await _cameraController.setFlashMode(FlashMode.torch);
    }
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _takePhoto() async {
    if (!_cameraController.value.isInitialized ||
        _cameraController.value.isTakingPicture) {
      return;
    }

    try {
      final XFile file = await _cameraController.takePicture();
      final Uint8List imageBytes = await file.readAsBytes();
      _toggleFlash();

      final jpgImage = await _imagesService.convertToJPG(imageBytes);

      _handleImage(jpgImage);
    } catch (e) {
      debugPrint('Error capturing photo: $e');
    }
  }

  Widget buildPreview() {
    if (_isCameraInitialized) {
      return CameraPreview(_cameraController);
    } else {
      return Center(child: LoadingIndicatorWrapper());
    }
  }

  Future<void> _handleImage(Uint8List? jpgImage) async {
    if (jpgImage != null) {
      // Obtain a prediction
      int id = _classifierService.predict(jpgImage);
      PlantModel? identifiedPlant = _objectboxService.getPlantById(id);

      if (identifiedPlant != null && mounted) {
        // Save as a recent search
        identifiedPlant.recent = true;
        _objectboxService.savePlant(identifiedPlant);

        // Show the result
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(identifiedPlant),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.green,
                                width: 4,
                              ),
                            ),
                            child: buildPreview(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isFlashOn
                                    ? Icons.flash_off_outlined
                                    : MingCute.flash_line,
                                color: AppTheme.of(context).primary,
                              ),
                              onPressed: _toggleFlash,
                            ),
                            SizedBox(
                              height: 95,
                              width: 95,
                              child: IconButton(
                                icon: Icon(
                                  Icons.circle_outlined,
                                  color: AppTheme.of(context).primaryText,
                                  size: 80,
                                ),
                                onPressed: _takePhoto,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                MingCute.photo_album_line,
                                color: AppTheme.of(context).primary,
                              ),
                              onPressed: () async {
                                if (!_cameraController.value.isInitialized ||
                                    _cameraController.value.isTakingPicture) {
                                  return;
                                }
                                // Pick and convert image to JPG
                                Uint8List? image =
                                    await _imagesService.pickAndConvertImage();
                                await _handleImage(image);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBarWrapper('scanner'),
      ),
    );
  }
}
