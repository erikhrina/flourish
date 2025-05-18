import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class ImagesService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<Uint8List> convertToJPG(Uint8List photoBytes) async {
    img.Image? photoImage = img.decodeImage(photoBytes);

    Uint8List pngBytes = Uint8List.fromList(img.encodeJpg(photoImage!));
    return pngBytes;
  }

  Future<Uint8List?> pickAndConvertImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      Uint8List imageBytes = File(image.path).readAsBytesSync();
      return convertToJPG(imageBytes);
    }
    return null;
  }
}
