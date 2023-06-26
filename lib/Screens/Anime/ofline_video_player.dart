import 'dart:io';

import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:flutter_locales/flutter_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class OflinePlayer extends StatefulWidget {
  final String path;

  const OflinePlayer({
    super.key,
    required this.path,
  });
  @override
  _OflinePlayerState createState() => _OflinePlayerState();
}

class _OflinePlayerState extends State<OflinePlayer> {
  late VideoPlayerController _videoPlayerController;
//  late ChewieController _chewieController;

  //  List<DropdownMenuItem<String>> _aspectRatioOptions = [
  //   DropdownMenuItem(value: 'fit', child: Text('Fit')),
  //   DropdownMenuItem(value: 'fill', child: Text('Fill')),
  //   DropdownMenuItem(value: '16:9', child: Text('16:9')),
  //   DropdownMenuItem(value: '4:3', child: Text('4:3')),
  // ];
  bool showControllers = false;
  bool fullscreen = false;
  bool backTime = false;
  bool plusTime = false;
  bool loading = false;
  bool? autoPlay;
  double aspectRatio = 16 / 9;
  late Duration position;

  ChangeAspectRatio(Size size) {
    setState(() {
      if (aspectRatio == 16 / 9) {
        aspectRatio = size.aspectRatio;
      } else {
        aspectRatio = 16 / 9;
      }
    });
  }

  @override
  void initState() {
    loading = true;
    setState(() {});
    super.initState();
    _videoPlayerController = VideoPlayerController.file(   File(widget.path))
      ..addListener(() {})
      ..setLooping(false)
      ..initialize()..play();
    //.then((value) => _videoPlayerController.play());
    _videoPlayerController.addListener(() {
      setState(() {
        if (autoPlay! &&
            _videoPlayerController.value.duration ==
                _videoPlayerController.value.position &&
            _videoPlayerController.value.position != Duration(seconds: 0)) {
        }
      });
    });
    loading = false;
    setState(() {});
    //_videoPlayerController.addListener(() {});
  }

  
    

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    fullscreen = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    //SystemChrome.restoreSystemUIOverlays();
    // _chewieController.dispose();
  }

  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minuttes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minuttes, seconds].join(':');
  }

  bool tap = false;
  unDisplay() async {
    if (!tap) {
      tap = true;
      setState(() {});
      await Future.delayed(const Duration(seconds: 3), () {
        showControllers = false;
        tap = false;
        setState(() {});
      });
    }
  }

  fullScreenMethod() {
    if (!fullscreen) {
      setState(() {
        fullscreen = true;

        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft],
        );
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    } else {
      fullscreen = false;
      setState(() {});
      setState(() {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      // onVerticalDragDown: (details) => setState(() {
      //   fullscreen ? fullscreen = false : null;
      //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      // }),
      child: WillPopScope(
        onWillPop: () async {
          if (fullscreen) {
            setState(() {
              fullscreen = false;
              SystemChrome.setPreferredOrientations(
                  [DeviceOrientation.portraitUp]);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
            });
            return false;
          }

          return fullscreen ? false : true;
        },
        child: SizedBox(
          height: fullscreen ? size.height : 200,
          width: size.width,
          child: GestureDetector(
            onTap: () => setState(() {
              showControllers = !showControllers ? true : false;

              _videoPlayerController.value.isPlaying ? unDisplay() : null;
            }),
            child: Stack(children: [
              (!loading)
                  ? Container(
                      color: Colors.black,
                      width: size.width,
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: aspectRatio,
                            child: VideoPlayer(_videoPlayerController)),
                      ),
                    )
                  : LoadingGif(
                      logo: true,
                    ),
              Container(
                height: fullscreen ? size.height : 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: (!showControllers)
                          ? [Colors.transparent, Colors.transparent]
                          : [
                              Colors.black.withOpacity(.7),
                              Colors.transparent,
                              Colors.black.withOpacity(.7),
                            ]),
                ),
                child: Stack(
                  children: [
                    Container(
                        //  height: fullscreen ? size.height : 200,
                        child: Row(children: [
                      GestureDetector(
                        onDoubleTap: () => plus(false),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(80)),
                            color: !backTime
                                ? Colors.transparent
                                : Colors.black.withOpacity(.3),
                          ),
                          height: fullscreen ? size.height : 200,
                          width: size.width / 2.5,
                          child: !backTime
                              ? SizedBox()
                              : Column(
                                  children: [
                                    Expanded(child: SizedBox()),
                                    context.currentLocale!.languageCode == 'en'
                                        ? Transform(
                                            alignment: Alignment.center,
                                            transform:
                                                Matrix4.rotationY(math.pi),
                                            child: Icon(
                                              size: 40,
                                              Icons.fast_forward_rounded,
                                              color: Colors.white,
                                            ))
                                        : Icon(
                                            size: 40,
                                            Icons.fast_forward_rounded,
                                            color: Colors.white,
                                          ),
                                    Expanded(
                                        child: Container(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              '10' +
                                                  context.localeString(
                                                    'sec',
                                                  ),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'SFPro',
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  ],
                                ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                          onDoubleTap: () => plus(true),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(80)),
                              color: !plusTime
                                  ? Colors.transparent
                                  : Colors.black.withOpacity(.3),
                            ),
                            height: fullscreen ? size.height : 200,
                            width: size.width / 2.5,
                            child: !plusTime
                                ? SizedBox()
                                : Column(
                                    children: [
                                      Expanded(child: SizedBox()),
                                      context.currentLocale!.languageCode ==
                                              'en'
                                          ? Icon(
                                              size: 40,
                                              Icons.fast_forward_rounded,
                                              color: Colors.white,
                                            )
                                          : Transform(
                                              alignment: Alignment.center,
                                              transform:
                                                  Matrix4.rotationY(math.pi),
                                              child: Icon(
                                                size: 40,
                                                Icons.fast_forward_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                      Expanded(
                                          child: Container(
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                '10' +
                                                    context.localeString(
                                                      'sec',
                                                    ),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'SFPro',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                    ],
                                  ),
                          ))
                    ])),
                    Column(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 12),
                            child: SizedBox(
                              height: 20,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    (!showControllers)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet<dynamic>(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return DraggableScrollableSheet(
                                                        initialChildSize: .4,
                                                        minChildSize: 0.3,
                                                        builder: (context,
                                                                scrollController) =>
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              12)),
                                                                  color: customColors
                                                                      .backgroundColor),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                    
                                                                      GestureDetector(
                                                                          child:
                                                                              Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 8),
                                                                        child: Row(
                                                                            children: [
                                                                              Center(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                  child: Icon(Icons.settings, size: 35),
                                                                                ),
                                                                              ),
                                                                              LocaleText('auto_play',
                                                                                  style: TextStyle(
                                                                                    fontSize: 20,
                                                                                  )),
                                                                              Expanded(
                                                                                  child: Align(
                                                                                alignment: context.currentLocale!.languageCode == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                                                                child: Switch.adaptive(
                                                                                    value: autoPlay!,
                                                                                    onChanged: (value) async {
                                                                                      Navigator.pop(context);
                                                                                      SharedPreferences pref = await SharedPreferences.getInstance();
                                                                                      pref.setBool('autoPlay', value);

                                                                                      autoPlay = value;
                                                                                      setState(() {});
                                                                                    }),
                                                                              ))
                                                                            ]),
                                                                      )),
                                                                    ]),
                                                              ),
                                                            ));
                                                  });
                                            },
                                            child: Icon(
                                              Icons.settings,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    (!showControllers)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _videoPlayerController
                                                            .value.volume ==
                                                        0
                                                    ? _videoPlayerController
                                                        .setVolume(100)
                                                    : _videoPlayerController
                                                        .setVolume(0);
                                              });
                                            },
                                            child: Icon(
                                              _videoPlayerController
                                                          .value.volume !=
                                                      0
                                                  ? Icons.volume_up_rounded
                                                  : Icons.volume_off_rounded,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                          ),
                                   
                                    (!showControllers)
                                        ? SizedBox()
                                        : !fullscreen
                                            ? SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: GestureDetector(
                                                    onTap: () =>
                                                        ChangeAspectRatio(size),
                                                    child: Icon(
                                                      Icons
                                                          .aspect_ratio_rounded,
                                                      color: Colors.white,
                                                      size: 30,
                                                    )),
                                              ),
                                    Expanded(child: SizedBox())
                                  ]),
                            )),
                      
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical:
                                  fullscreen ? 30 : 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (!showControllers &&
                                      !_videoPlayerController.value.isBuffering)
                                  ? SizedBox()
                                  : ValueListenableBuilder(
                                      valueListenable: _videoPlayerController,
                                      builder: (context, value, child) => Text(
                                        _videoDuration(value.position) +
                                            " / " +
                                            _videoDuration(
                                                _videoPlayerController
                                                    .value.duration),
                                        style: TextStyle(
                                            fontFamily: 'SFPro',
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                              (!showControllers)
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () => fullScreenMethod(),
                                      child: Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: fullscreen ? 15 : 0),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 8,
                    child: (!showControllers && fullscreen)
                        ? SizedBox()
                        : VideoProgressIndicator(
                            colors: VideoProgressColors(
                                //backgroundColor: Colors.black,
                                bufferedColor: Colors.grey,
                                playedColor: Colors.white),
                            _videoPlayerController,
                            allowScrubbing: true),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
  //   Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       IconButton(
  //         icon: Icon(Icons.forward_10),
  //         onPressed: () {
  //           _videoPlayerController.seekTo(Duration(
  //               seconds:
  //                   _videoPlayerController.value.position.inSeconds + 10));
  //         },
  //       ),
  //       DropdownButton(
  //         value: _aspectRatioValue,
  //         items: _aspectRatioOptions,
  //         onChanged: (value) {
  //           // setState(() {
  //           //   _aspectRatioValue = value.toString();
  //           //   if (_aspectRatioValue == 'fit') {
  //           //     _chewieController.aspectRatio !=
  //           //         _videoPlayerController.value.aspectRatio;
  //           //   } else if (_aspectRatioValue == 'fill') {
  //           //     _chewieController.aspectRatio !=
  //           //         MediaQuery.of(context).size.aspectRatio;
  //           //   } else {
  //           //     List<String> aspects = _aspectRatioValue.split(':');
  //           //     double aspectX = double.parse(aspects[0]);
  //           //     double aspectY = double.parse(aspects[1]);
  //           //     _chewieController.aspectRatio != aspectX / aspectY;
  //           //   }
  //           // });
  //         },
  //       ),
  //     ],
  //   )
  // ]),

  plus(bool plus) async {
    if (plus) {
      plusTime = true;

      setState(() {
        _videoPlayerController.seekTo(
            _videoPlayerController.value.position + Duration(seconds: 10))
          ..then((value) => _videoPlayerController.play());
      });
    } else {
      backTime = true;
      setState(() {
        setState(() {
          _videoPlayerController.seekTo(
              _videoPlayerController.value.position - Duration(seconds: 10))
            ..then((value) => _videoPlayerController.play());
        });
      });
    }
    await Future.delayed(const Duration(seconds: 2), () {});
    if (plus) {
      plusTime = false;
      setState(() {});
    } else {
      backTime = false;
      setState(() {});
    }
  }
}



  // _aspectRatioValue = value.toString();
  //                 if (_aspectRatioValue == 'fit') {
  //                   _chewieController.aspectRatio !=
  //                       _videoPlayerController.value.aspectRatio;
  //                 } else if (_aspectRatioValue == 'fill') {
  //                   _chewieController.aspectRatio !=
  //                       MediaQuery.of(context).size.aspectRatio;
  //                 } else {
  //                   List<String> aspects = _aspectRatioValue.split(':');
  //                   double aspectX = double.parse(aspects[0]);
  //                   double aspectY = double.parse(aspects[1]);
  //                   _chewieController.aspectRatio != aspectX / aspectY;
  //                 }