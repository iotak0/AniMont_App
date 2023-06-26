import 'dart:convert';
import 'dart:io';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/cust_snak_bar.dart';
import 'package:anime_mont_test/widgets/dialog_box.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../helper/constans.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late String myId;
  bool isUploading = false;
  bool error = false;
  final Server _server = Server();
  addPost(context) async {
    setState(() {
      isUploading = true;
    });
    var response;
    var body;

    response = await http.post(Uri.parse(add_post), body: {
      "post_user": myId,
      "caption": '${controller.text}',
    }).catchError((error0) {
      isUploading = false;
      error = true;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
          headLine: context.localeString('erorr'),
          erorr: context.localeString("try_again"),
          color: Color(0xFFC72C41),
          image: danger,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    });
    body = await json.decode(response.body);
    if (body['status'] == "success") {
      for (int i = 0; i < posts.length; i++) {
        print(i);
        await posts[i].isImage
            ? addContentImage(posts[i], body['post_cont'])
            : addContent(posts[i], body['post_cont']);
        await Future.delayed(const Duration(seconds: 2), () {})
            .then((value) => null);
      }
      setState(() {
        isUploading = false;
        Navigator.pop(context);
      });
      //print(body['post_cont']);
    } else {
      setState(() {
        isUploading = false;
        error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
          headLine: body['message'] == "error"
              ? context.localeString('erorr')
              : context.localeString('you_have_been_banned'),
          erorr: body['message'] == "error"
              ? context.localeString("try_again")
              : context.localeString("your_account_is_banned"),
          color: Color(0xFFC72C41),
          image: danger,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
      //  print("add comment fail");
    }
    setState(() {
      isUploading = false;
    });
  }

  addContent(CreatePostClass p, String post_cont) async {
    var response = await http.post(Uri.parse(add_post_cont), body: {
      "post_cont": "${post_cont}",
      "post_content": "${p.content}",
      "post_color": "${p.color}",
      "text_color": "${p.textColor}",
      "is_image": '0',
    }).catchError((error0) {
      setState(() {
        isUploading = false;
        error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('erorr'),
            erorr: context.localeString("try_again")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    });
    final body = json.decode(response.body);
    if (body['status'] == "success") {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: 'erorr',
            erorr: "try_again"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
    await Future.delayed(const Duration(seconds: 2), () {})
        .then((value) => null);
    // Navigator.pop(context);
  }

  addContentImage(CreatePostClass p, String post_cont) async {
    final response = await Server.postRequestWithFiles(
            add_post_cont_image,
            {
              "post_cont": "${post_cont}",
              "post_color": "${p.color}",
              "text_color": "${p.textColor}",
              "is_image": '1',
            },
            p.imagePath)
        .catchError((error0) {
      setState(() {
        isUploading = false;
        error = true;
      });
    });
    final body = json.decode(response.body);
    if (body['status'] == "success") {
    } else {
      setState(() {
        error = true;
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: context.localeString('erorr'),
            erorr: context.localeString("try_again")),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
    await Future.delayed(const Duration(seconds: 2), () {})
        .then((value) => null);
  }

  getMyId() async {
    Map<String, dynamic> user = await UserModel.getAcount();
    myId = user["id"].toString();
    print("MYID   $myId");
  }

  late int maxImages;
  late int m;
  @override
  void initState() {
    super.initState();
    getMyId();
    maxImages = 10;
    m = maxImages - 1;
  }

  List<CreatePostClass> posts = [];

  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();
  final MultiImagePicker _multiImagePicker = MultiImagePicker();
  ImageSource? _source = ImageSource.gallery;
  selectImage(CustomColors customColors) async {
    // final files = await pickImage(multiple: true);
    final files = await multipickImage(customColors: customColors);
    for (var e in files) {
      posts.add(CreatePostClass(true, "Image", File(e!.path),
          Colors.white.value, Colors.white.value));
      setState(() {});
    }
    // print(posts[0].imagePath);
  }

  TextEditingController controller = TextEditingController();
  TextEditingController postController = TextEditingController();
  Future<CroppedFile?> crop2({
    required File file,
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
                toolbarTitle: context.localeString('edit'),
                toolbarWidgetColor: CustomColors(context).primaryColor,
                activeControlsWidgetColor: CustomColors(context).bottomDown,
                cropFrameColor: CustomColors(context).bottomDown,
                cropGridColor: CustomColors(context).bottomDown,
                statusBarColor: CustomColors(context).backgroundColor,
                dimmedLayerColor:
                    CustomColors(context).backgroundColor.withOpacity(.3),
                toolbarColor: CustomColors(context).backgroundColor,
                backgroundColor: CustomColors(context).backgroundColor)
          ]);
  Future<List<XFile?>> pickImage({
    //ImageSource source = ImageSource.gallery
    //,

    int imageQualtiy = 100,
    bool multiple = false,
  }) async {
    if (multiple) {
      return await _imagePicker.pickMultiImage(imageQuality: imageQualtiy);
    }
    final file = await _imagePicker.pickImage(
        source: _source!, imageQuality: imageQualtiy);
    if (file != null) return [file];
    return [];
  }

  Future<File> getImagePath(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  multipickImage({
    //ImageSource source = ImageSource.gallery
    //,
    required CustomColors customColors,
    int imageQualtiy = 100,
    bool multiple = false,
  }) async {
    var assets;
    if (maxImages > 1) {
      assets = await MultiImagePicker.pickImages(
          maxImages: maxImages,
          //selectedAssets: i,
          enableCamera: false,
          materialOptions: MaterialOptions(
              autoCloseOnSelectionLimit: false,
              lightStatusBar: false,
              statusBarColor: 'grey',
              selectionLimitReachedText:
                  context.currentLocale!.languageCode == 'ar'
                      ? 'لا يمكنك تحديد المزيد'
                      : 'There is no selected image',
              actionBarTitle: context.currentLocale!.languageCode == 'ar'
                  ? "حدد صورة او اكثر"
                  : 'Select Image/s',
              actionBarTitleColor: 'white',
              textOnNothingSelected: context.currentLocale!.languageCode == 'ar'
                  ? 'حدد صورة واحدة على الاقل'
                  : 'Select at least one image',
              useDetailsView: true,
              allViewTitle:
                  context.currentLocale!.languageCode == 'ar' ? 'الكل' : 'All',
              actionBarColor:
                  ThemeData == ThemeData.dark() ? 'black' : 'black'));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: CustSnackBar(
            color: Color(0xFFC72C41),
            image: danger,
            headLine: 'لقد تجاوزت الحد الاقصى المسموح به',
            erorr: "اضغط ضغطة مطولة على المنشور لحذفه"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ));
    }
    List<File> listFiles = [];
    if (assets != null) {
      maxImages - 2;
      for (var asset in assets) {
        final file = await getImagePath(asset);
        listFiles.add(file);
        maxImages--;
        print(asset);
        setState(() {});
      }

      return listFiles;
    } else
      return [];
  }

  changeColor(bool isText, BuildContext context, int index) {
    if (isText) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: LocaleText("picktextcolor"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                        pickerColor: Color(posts[index].textColor),
                        // ignore: deprecated_member_use
                        enableAlpha: false,
                        showLabel: false,
                        onColorChanged: (color) {
                          setState(() {
                            posts[index].textColor = color.value;
                          });
                          setState(() {});
                        }),
                  ],
                ),
              ));
      setState(() {});
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: LocaleText("pickbackgroundcolor"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ColorPicker(
                        enableAlpha: true,
                        showLabel: false,
                        pickerColor: Color(posts[index].color),
                        onColorChanged: (color) {
                          setState(() {
                            posts[index].color = color.value;
                          });
                          setState(() {});
                        }),
                  ],
                ),
              ));
      setState(() {});
    }
    setState(() {});
  }

  editImage(File file, int index) async {
    final croppedFile = await crop2(
      file: file,
      cropStyle: CropStyle.rectangle,
    );
    if (croppedFile != null) {
      posts[index].imagePath = File(croppedFile.path);
    }
    setState(() {});
  }

  textPost() async {
    posts.add(CreatePostClass(false, context.localeString("taptoedit"),
        File(''), Color.fromARGB(255, 29, 28, 28).value, Colors.white.value));
    maxImages--;
    setState(() {});
  }

  editTextPost(context, int index) async {
    await showDialog(
        context: context,
        builder: (context) => WriteAPost(postController: postController));
    posts[index].content = postController.text;
    setState(() {});
  }

  deletePost(int index) {
    posts.removeAt(index);
    maxImages++;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);

    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: LocaleText(
              'newpost',
              style: TextStyle(
                  color: customColors.primaryColor,
                  fontFamily: 'SFPro',
                  fontWeight: FontWeight.bold),
            ),
            leading: isUploading
                ? SizedBox()
                : GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: customColors.primaryColor,
                    ),
                  ),
            backgroundColor: customColors.backgroundColor,
            elevation: 1,
            actions: [
              GestureDetector(
                onTap: () {
                  (posts.isNotEmpty && !isUploading)
                      ? {
                          FocusScope.of(context).requestFocus(FocusNode()),
                          addPost(context),
                        }
                      : FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: isUploading
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: LoadingGif(
                            logo: false,
                          ))
                      : SvgPicture.string(
                          '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                          height: 25,
                          width: 25,
                          color: posts.isNotEmpty && !isUploading
                              ? customColors.bottomDown
                              : customColors.primaryColor,
                        ),
                ),
              )
            ],
          ),
          floatingActionButton: isUploading
              ? SizedBox()
              : SpeedDial(
                  onOpen: () =>
                      FocusScope.of(context).requestFocus(FocusNode()),
                  visible: !isUploading && maxImages > 0,
                  buttonSize: const Size(45.0, 45.0),
                  backgroundColor: customColors.bottomDown,
                  child: SvgPicture.string(
                    '<?xml version="1.0" encoding="utf-8"?><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="122.879px" height="122.88px" viewBox="0 0 122.879 122.88" enable-background="new 0 0 122.879 122.88" xml:space="preserve"><g><path d="M17.995,17.995C29.992,5.999,45.716,0,61.439,0s31.448,5.999,43.445,17.995c11.996,11.997,17.994,27.721,17.994,43.444 c0,15.725-5.998,31.448-17.994,43.445c-11.997,11.996-27.722,17.995-43.445,17.995s-31.448-5.999-43.444-17.995 C5.998,92.888,0,77.164,0,61.439C0,45.716,5.998,29.992,17.995,17.995L17.995,17.995z M57.656,31.182 c0-1.84,1.492-3.332,3.333-3.332s3.333,1.492,3.333,3.332v27.383h27.383c1.84,0,3.332,1.492,3.332,3.332 c0,1.841-1.492,3.333-3.332,3.333H64.321v27.383c0,1.84-1.492,3.332-3.333,3.332s-3.333-1.492-3.333-3.332V65.229H30.273 c-1.84,0-3.333-1.492-3.333-3.333c0-1.84,1.492-3.332,3.333-3.332h27.383V31.182L57.656,31.182z M61.439,6.665 c-14.018,0-28.035,5.348-38.731,16.044C12.013,33.404,6.665,47.422,6.665,61.439c0,14.018,5.348,28.036,16.043,38.731 c10.696,10.696,24.713,16.044,38.731,16.044s28.035-5.348,38.731-16.044c10.695-10.695,16.044-24.714,16.044-38.731 c0-14.017-5.349-28.035-16.044-38.73C89.475,12.013,75.457,6.665,61.439,6.665L61.439,6.665z"/></g></svg>',
                    height: 100,
                    width: 100,
                    color: customColors.primaryColor,
                  ),
                  children: [
                      SpeedDialChild(
                          backgroundColor: customColors.iconTheme,
                          child: SvgPicture.string(
                            '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Image</title>
    <g id="Iconly/Light/Image" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Image" transform="translate(2.000000, 2.000000)" stroke="#000000" stroke-width="1.5">
            <path d="M19.21,5.8992 L19.21,14.0502 C19.21,17.0702 17.32,19.2002 14.3,19.2002 L5.65,19.2002 C2.63,19.2002 0.75,17.0702 0.75,14.0502 L0.75,5.8992 C0.75,2.8792 2.64,0.7502 5.65,0.7502 L14.3,0.7502 C17.32,0.7502 19.21,2.8792 19.21,5.8992 Z" id="Stroke-1"></path>
            <path d="M3.2813,14.4309 L4.8093,12.8179 C5.3403,12.2549 6.2253,12.2279 6.7893,12.7579 C6.8063,12.7749 7.7263,13.7099 7.7263,13.7099 C8.2813,14.2749 9.1883,14.2839 9.7533,13.7299 C9.7903,13.6939 12.0873,10.9079 12.0873,10.9079 C12.6793,10.1889 13.7423,10.0859 14.4623,10.6789 C14.5103,10.7189 16.6803,12.9459 16.6803,12.9459" id="Stroke-3"></path>
            <path d="M8.3126,7.1331 C8.3126,8.1021 7.5276,8.8871 6.5586,8.8871 C5.5896,8.8871 4.8046,8.1021 4.8046,7.1331 C4.8046,6.1641 5.5896,5.3791 6.5586,5.3791 C7.5276,5.3801 8.3126,6.1641 8.3126,7.1331 Z" id="Stroke-5"></path>
        </g>
    </g>
</svg>''',
                            height: 35,
                            width: 35,
                          ),
                          onTap: () => selectImage(customColors)),
                      SpeedDialChild(
                          backgroundColor: customColors.iconTheme,
                          child: SvgPicture.string(
                            '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Paper</title>
    <g id="Iconly/Light/Paper" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Paper" transform="translate(3.500000, 2.000000)" stroke="#000000" stroke-width="1.5">
            <path d="M11.2378,0.761771171 L4.5848,0.761771171 C2.5048,0.7538 0.7998,2.4118 0.7508,4.4908 L0.7508,15.2038 C0.7048,17.3168 2.3798,19.0678 4.4928,19.1148 C4.5238,19.1148 4.5538,19.1158 4.5848,19.1148 L12.5738,19.1148 C14.6678,19.0298 16.3178,17.2998 16.3029015,15.2038 L16.3029015,6.0378 L11.2378,0.761771171 Z" id="Stroke-1"></path>
            <path d="M10.9751,0.75 L10.9751,3.659 C10.9751,5.079 12.1231,6.23 13.5431,6.234 L16.2981,6.234" id="Stroke-3"></path>
            <line x1="10.7881" y1="13.3585" x2="5.3881" y2="13.3585" id="Stroke-5"></line>
            <line x1="8.7432" y1="9.606" x2="5.3872" y2="9.606" id="Stroke-7"></line>
        </g>
    </g>
</svg>''',
                            height: 35,
                            width: 35,
                          ),
                          onTap: () => textPost())
                    ]),
          body: isUploading
              ? LoadingGif(
                  logo: true,
                )
              : (error && 1 == 2)
                  ? AlartInternet(onTap: () {
                      isUploading ? null : addPost(context);
                    })
                  : ListView(children: [
                      posts.isNotEmpty
                          ? Container(
                              constraints: const BoxConstraints(minHeight: 50),
                              height: 360,
                              child: Swiper(
                                loop: false,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onLongPress: () => deletePost(index),
                                    child: Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        posts[index].isImage
                                            ? GestureDetector(
                                                onTap: () => editImage(
                                                    posts[index].imagePath,
                                                    index),
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: ClipRRect(
                                                      child: Image.file(
                                                    posts[index].imagePath,
                                                    fit: BoxFit.cover,
                                                  )),
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () => editTextPost(
                                                    context, index),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(
                                                          posts[index].color)),
                                                  child: Center(
                                                      child: Text(
                                                          posts[index].content,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(posts[
                                                                      index]
                                                                  .textColor),
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'SFPro'))),
                                                ),
                                              ),
                                        !posts[index].isImage
                                            ? Positioned(
                                                bottom: 15,
                                                height: 30,
                                                width: 30,
                                                left: 15,
                                                child: GestureDetector(
                                                  onTap: () => changeColor(
                                                      false, context, index),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Color(
                                                              posts[index]
                                                                  .color)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                      )),
                                                ),
                                              )
                                            : SizedBox(),
                                        !posts[index].isImage
                                            ? Positioned(
                                                bottom: 15,
                                                height: 30,
                                                width: 30,
                                                right: 15,
                                                child: GestureDetector(
                                                  onTap: () => changeColor(
                                                      true, context, index),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          color: Color(
                                                              posts[index]
                                                                  .textColor)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                      )),
                                                ),
                                              )
                                            : SizedBox(),
                                        Positioned(
                                          right: 15,
                                          top: 15,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: const Color.fromARGB(
                                                      166, 0, 0, 0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  '${index + 1}/${posts.length}',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              )),
                                        ),
                                        Positioned(
                                          left: 15,
                                          top: 15,
                                          height: 30,
                                          width: 30,
                                          child: GestureDetector(
                                            onTap: () => posts[index].isImage
                                                ? editImage(
                                                    posts[index].imagePath,
                                                    index)
                                                : editTextPost(context, index),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: const Color.fromARGB(
                                                      166, 0, 0, 0),
                                                ),
                                                child: SvgPicture.string(
                                                  '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Edit</title>
    <g id="Iconly/Light-Outline/Edit" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Edit" transform="translate(2.000000, 3.000000)" fill="#000000">
            <path d="M18.7504743,17.4395426 C19.1644743,17.4395426 19.5004743,17.7755426 19.5004743,18.1895426 C19.5004743,18.6035426 19.1644743,18.9395426 18.7504743,18.9395426 L11.4974743,18.9395426 C11.0834743,18.9395426 10.7474743,18.6035426 10.7474743,18.1895426 C10.7474743,17.7755426 11.0834743,17.4395426 11.4974743,17.4395426 L18.7504743,17.4395426 Z M14.1162743,0.653642644 C14.1662743,0.692642644 15.8392743,1.99264264 15.8392743,1.99264264 C16.4472743,2.35464264 16.9222743,3.00164264 17.1022743,3.76764264 C17.2812743,4.52564264 17.1512743,5.30764264 16.7342743,5.96864264 C16.7314843,5.97305264 16.7287267,5.97740594 16.7190724,5.99036671 L16.7115384,6.00037748 C16.6438514,6.08958254 16.3496103,6.46163507 14.8645637,8.32222949 C14.8507703,8.34661541 14.8351388,8.36945203 14.8180743,8.39164264 C14.7930299,8.42435375 14.7657794,8.45442349 14.736689,8.48180241 C14.6353903,8.60933705 14.5284065,8.74334814 14.4159195,8.88423852 L14.1879908,9.16970248 C13.7176954,9.7586788 13.1598596,10.4570865 12.4980586,11.2854628 L12.1584183,11.7105768 C10.8807459,13.3097378 9.24443431,15.3572426 7.14827431,17.9796426 C6.68927431,18.5516426 6.00127431,18.8846426 5.26227431,18.8936426 L1.62327431,18.9396426 L1.61327431,18.9396426 C1.26627431,18.9396426 0.964274306,18.7016426 0.883274306,18.3626426 L0.0642743057,14.8916426 C-0.104725694,14.1726426 0.0632743057,13.4306426 0.524274306,12.8546426 L9.94427431,1.07264264 C9.94827431,1.06864264 9.95127431,1.06364264 9.95527431,1.05964264 C10.9882743,-0.175357356 12.8562743,-0.357357356 14.1162743,0.653642644 Z M8.894,4.787 L1.69527431,13.7916426 C1.52427431,14.0056426 1.46127431,14.2816426 1.52427431,14.5466426 L2.20527431,17.4316426 L5.24427431,17.3936426 C5.53327431,17.3906426 5.80027431,17.2616426 5.97727431,17.0416426 C6.88875764,15.901226 8.03433097,14.4678757 9.21212914,12.9940199 L9.62883197,12.4725647 L9.62883197,12.4725647 L10.0462387,11.9502119 C11.1508202,10.5678883 12.2420592,9.20206663 13.1551253,8.05886375 L8.894,4.787 Z M11.1102743,2.01664264 L9.831,3.615 L14.0917742,6.88592888 C14.9118863,5.85869797 15.4513975,5.1821385 15.5012743,5.11764264 C15.6652743,4.85164264 15.7292743,4.47564264 15.6432743,4.11364264 C15.5552743,3.74264264 15.3242743,3.42764264 14.9912743,3.22664264 C14.9202743,3.17764264 13.2352743,1.86964264 13.1832743,1.82864264 C12.5492743,1.32064264 11.6242743,1.40864264 11.1102743,2.01664264 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                                  fit: BoxFit.cover,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 15,
                                          height: 30,
                                          width: 30,
                                          child: GestureDetector(
                                            onTap: () => deletePost(index),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: const Color.fromARGB(
                                                      166, 0, 0, 0),
                                                ),
                                                child: SvgPicture.string(
                                                  '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Delete</title>
    <g id="Iconly/Light-Outline/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000">
            <path d="M16.3846,6.72 C16.7976,6.754 17.1056,7.115 17.0726,7.528 C17.0666,7.596 16.5246,14.307 16.2126,17.122 C16.0186,18.869 14.8646,19.932 13.1226,19.964 C11.7896,19.987 10.5036,20 9.2466,20 C7.8916,20 6.5706,19.985 5.2636,19.958 C3.5916,19.925 2.4346,18.841 2.2456,17.129 C1.9306,14.289 1.3916,7.595 1.3866,7.528 C1.3526,7.115 1.6606,6.753 2.0736,6.72 C2.4806,6.709 2.8486,6.995 2.8816,7.407 C2.88479149,7.45040426 3.10514006,10.1840303 3.34526171,12.888712 L3.3934912,13.4284567 C3.5144316,14.7728253 3.63702553,16.0646383 3.7366,16.964 C3.8436,17.937 4.3686,18.439 5.2946,18.458 C7.7946,18.511 10.3456,18.514 13.0956,18.464 C14.0796,18.445 14.6116,17.953 14.7216,16.957 C15.0316,14.163 15.5716,7.475 15.5776,7.407 C15.6106,6.995 15.9756,6.707 16.3846,6.72 Z M11.3454,0.0003 C12.2634,0.0003 13.0704,0.6193 13.3074,1.5063 L13.5614,2.7673 C13.6434814,3.18067391 14.0062454,3.48255718 14.426277,3.48918855 L17.708,3.4893 C18.122,3.4893 18.458,3.8253 18.458,4.2393 C18.458,4.6533 18.122,4.9893 17.708,4.9893 L14.455585,4.98914909 C14.4505353,4.98924954 14.4454735,4.9893 14.4404,4.9893 L14.416,4.9883 L4.04161866,4.98917751 C4.03355343,4.98925911 4.02548047,4.9893 4.0174,4.9893 L4.002,4.9883 L0.75,4.9893 C0.336,4.9893 0,4.6533 0,4.2393 C0,3.8253 0.336,3.4893 0.75,3.4893 L4.031,3.4883 L4.13202059,3.48190556 C4.50830909,3.43308512 4.82103636,3.1473 4.8974,2.7673 L5.1404,1.5513 C5.3874,0.6193 6.1944,0.0003 7.1124,0.0003 L11.3454,0.0003 Z M11.3454,1.5003 L7.1124,1.5003 C6.8724,1.5003 6.6614,1.6613 6.6004,1.8923 L6.3674,3.0623 C6.33778734,3.2104961 6.29466721,3.35331391 6.23948439,3.48956855 L12.2186152,3.48956855 C12.1633631,3.35331391 12.1201455,3.2104961 12.0904,3.0623 L11.8474,1.8463 C11.7964,1.6613 11.5854,1.5003 11.3454,1.5003 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                                  fit: BoxFit.cover,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: posts.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                //print(controller.text);
                                debugPrint(controller.text);
                              },
                              child: Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 50),
                                  height: 360,
                                  color: customColors.iconTheme,
                                  child: Center(
                                      child: LocaleText("addTextOrPhoto",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: customColors.primaryColor,
                                              fontSize: 30,
                                              fontFamily: 'SFPro')))),
                            ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            LocaleText(
                              'caption',
                              textAlign: TextAlign.justify,

                              // textDirection: ,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SFPro',
                                  color: customColors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Settings(
                          controller: controller, customColors: customColors),
                    ])),
    );
  }
}

class WriteAPost extends StatelessWidget {
  const WriteAPost({
    Key? key,
    required this.postController,
  }) : super(key: key);

  final TextEditingController postController;

  @override
  Widget build(BuildContext context) {
    return DialogBox(
        text: context.localeString("typesomething"),
        controller: postController);
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
    required this.controller,
    required this.customColors,
  }) : super(key: key);

  final TextEditingController controller;
  final CustomColors customColors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: customColors.iconTheme,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 5,
            minLines: 1,
            maxLength: 200,
            style: TextStyle(color: customColors.primaryColor),
            cursorColor: Colors.blueAccent,
            //autocorrect: true,
            //enableSuggestions: true,
            //textCapitalization: TextCapitalization.sentences,
            controller: controller,

            decoration: InputDecoration(
              border: InputBorder.none,
              //filled: true,
              hintText: context.localeString('write_a_caption'),
              hintStyle: TextStyle(
                fontFamily: 'SFPro',
                color: customColors.primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePostClass {
  bool isImage;
  String content;
  File imagePath;
  int color;
  int textColor;
  CreatePostClass(
      this.isImage, this.content, this.imagePath, this.color, this.textColor);
}
