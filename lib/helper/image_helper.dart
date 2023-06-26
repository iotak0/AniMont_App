import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageSource? source,
    BuildContext? context,
    ImageCropper? imageCropper,
  })  : _context = context!,
        _source = source!,
        _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;
  final ImageSource _source;
  final BuildContext _context;
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
    CropAspectRatio cropAspectRatio =
        const CropAspectRatio(ratioX: 100, ratioY: 100),
    CropStyle cropStyle = CropStyle.rectangle,
  }) async =>
      await _imageCropper.cropImage(
          //compressFormat: ImageCompressFormat.png,
          cropStyle: cropStyle,
          aspectRatio: cropAspectRatio,
          sourcePath: file.path,
          compressQuality: 100,
          uiSettings: [
            IOSUiSettings(),
            AndroidUiSettings(
                toolbarTitle: _context.localeString('edit'),
                toolbarWidgetColor: CustomColors(_context).primaryColor,
                activeControlsWidgetColor: CustomColors(_context).bottomDown,
                cropFrameColor: CustomColors(_context).bottomDown,
                cropGridColor: CustomColors(_context).bottomDown,
                statusBarColor: CustomColors(_context).backgroundColor,
                dimmedLayerColor:
                    CustomColors(_context).backgroundColor.withOpacity(.3),
                toolbarColor: CustomColors(_context).backgroundColor,
                backgroundColor: CustomColors(_context).backgroundColor)
          ]);
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
