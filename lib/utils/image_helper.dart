import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageSource? source,
    ImageCropper? imageCropper,
  })  : _source = source!,
        _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  final ImageSource _source;

  Future<List<XFile?>> pickImage({
    //ImageSource source = ImageSource.gallery,
    int imageQualtiy = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQualtiy);
    }
    final file = await _imagePicker.pickImage(
        source: _source, imageQuality: imageQualtiy);
    if (file != null) return [file];
    return [];
  }

  Future<XFile?> pickVideo({
    //ImageSource source = ImageSource.gallery,
    int imageQualtiy = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickVideo(
        source: _source,
      );
    }
    final file = await _imagePicker.pickVideo(
      source: _source,
    );
    if (file != null) return file;
    return null;
  }

  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async =>
      await _imageCropper.cropImage(
          //compressFormat: ImageCompressFormat.png,
          cropStyle: cropStyle,
          sourcePath: file.path,
          compressQuality: 100,
          uiSettings: [IOSUiSettings(), AndroidUiSettings()]);
}

class VideoHelper {
  VideoHelper({
    ImagePicker? imagePicker,
    ImageSource? source,
  })  : _source = source!,
        _imagePicker = imagePicker ?? ImagePicker();
  final ImagePicker _imagePicker;
  final ImageSource _source;

  Future<XFile?> pickVideo({
    //ImageSource source = ImageSource.gallery,
    int imageQualtiy = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickVideo(
        source: _source,
      );
    }
    final file = await _imagePicker.pickImage(
        source: _source, imageQuality: imageQualtiy);
    if (file != null) return file;
    return null;
  }
}
