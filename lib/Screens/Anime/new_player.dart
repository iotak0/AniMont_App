import 'package:anime_mont_test/Screens/Player/video_page.dart';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class NewPlayer extends StatefulWidget {
  final String link;
  final int allEPCount;
  final String epName;
  final int eNP;
  final String animeLink;
  final int myId;
  final List<Episode> allEp;
  final int i;
  const NewPlayer(
      {super.key,
      required this.link,
      required this.myId,
      required this.allEp,
      required this.i,
      required this.allEPCount,
      required this.eNP,
      required this.animeLink,
      required this.epName});
  @override
  _NewPlayerState createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  late VideoPlayerController _videoPlayerController;
  int time = 0;

//  late ChewieController _chewieController;
  List<DropdownMenuItem> _qualityOptions = [
    DropdownMenuItem(
        value: '240p',
        child: Text('240p',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                fontWeight: FontWeight.bold))),
    DropdownMenuItem(
        value: '360p',
        child: Text('360p',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                fontWeight: FontWeight.bold))),
    DropdownMenuItem(
        value: '480p',
        child: Text('480p',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                fontWeight: FontWeight.bold))),
    DropdownMenuItem(
        value: '720p',
        child: Text('720p',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                fontWeight: FontWeight.bold))),
    DropdownMenuItem(
        value: '1080p',
        child: Text('1080p',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 12)],
                fontWeight: FontWeight.bold))),
  ];
  //  List<DropdownMenuItem<String>> _aspectRatioOptions = [
  //   DropdownMenuItem(value: 'fit', child: Text('Fit')),
  //   DropdownMenuItem(value: 'fill', child: Text('Fill')),
  //   DropdownMenuItem(value: '16:9', child: Text('16:9')),
  //   DropdownMenuItem(value: '4:3', child: Text('4:3')),
  // ];
  String? _quality;
  bool showControllers = false;
  bool fullscreen = false;
  bool backTime = false;
  bool plusTime = false;
  bool loading = false;
  bool? autoPlay;

  double aspectRatio = 16 / 9;
  late Duration position;

  getSettings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    autoPlay = pref.getBool('autoPlay') ?? true;
    _quality = pref.getString('quality') ?? '720p';
    reloadPlayer(_quality);
  }

  ChangeAspectRatio(Size size) {
    setState(() {
      if (aspectRatio == 16 / 9) {
        aspectRatio = size.aspectRatio;
      } else {
        aspectRatio = 16 / 9;
      }
    });
  }

  playNext() {
    String url = widget.animeLink;
    String ep = (widget.eNP + 1).toString();
    String urlNext =
        url.substring(0, url.indexOf('-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-'));
    urlNext = '$urlNext-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-$ep';
    print('///////////////////////////// $urlNext');
    if (widget.allEp.length > widget.eNP) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  NewPlayerPage(url: urlNext, myId: widget.myId)));
    }
  }

  @override
  void initState() {
    loading = true;
    getSettings();
    setState(() {});
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.link.replaceAll('0p', '240p_1'))
          ..addListener(() {
            setState(() {
              if (!_videoPlayerController.value.isPlaying) {
                showControllers = true;
              }
              if (autoPlay! &&
                  _videoPlayerController.value.duration ==
                      _videoPlayerController.value.position &&
                  _videoPlayerController.value.position !=
                      Duration(seconds: 0)) {
                playNext();
              }
            });
          })
          ..setLooping(false)
          ..initialize();
    //.then((value) => _videoPlayerController.play());
    _videoPlayerController.addListener(() {
      setState(() {
        if (!_videoPlayerController.value.isPlaying) {
          showControllers = true;
        }
        if (autoPlay! &&
            _videoPlayerController.value.duration ==
                _videoPlayerController.value.position &&
            _videoPlayerController.value.position != Duration(seconds: 0)) {
          playNext();
        }
      });
    });
    loading = false;
    setState(() {});
    //_videoPlayerController.addListener(() {});
  }

  reloadPlayer(_quality) {
    loading = true;
    position = _videoPlayerController.value.position;
    setState(() {});
    _videoPlayerController.dispose();
    _videoPlayerController = VideoPlayerController.network(
        widget.link.replaceAll('0p', _quality + '_1'))
      ..addListener(() {
        setState(() {
          if (!_videoPlayerController.value.isPlaying) {
            showControllers = true;
          }
          if (autoPlay! &&
              _videoPlayerController.value.duration ==
                  _videoPlayerController.value.position &&
              _videoPlayerController.value.position != Duration(seconds: 0)) {
            playNext();
          }
        });
      })
      ..setLooping(false)
      ..initialize()
          .then((value) => _videoPlayerController.value.hasError
              ? reloadPlayer(_quality)
              : null)
          .then((value) => _videoPlayerController.seekTo(position))
          .then((value) => _videoPlayerController.play());
    loading = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    NewPlayerPageState.fullScreen = false;
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
      setState(() {
        time += 3;
      });
      await Future.delayed(Duration(seconds: time), () {
        showControllers = false;
        tap = false;
        setState(() {});
      }).then((value) => time = 0);
    }
  }

  fullScreenMethod() {
    if (!fullscreen) {
      setState(() {
        fullscreen = true;
        NewPlayerPageState.fullScreen = true;

        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft],
        );
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    } else {
      fullscreen = false;
      NewPlayerPageState.fullScreen = false;
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
                                                    return SizedBox(
                                                      height: 180,
                                                      child:
                                                          DraggableScrollableSheet(
                                                              initialChildSize:
                                                                  .9,
                                                              minChildSize: 0.3,
                                                              builder: (context,
                                                                      scrollController) =>
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.vertical(
                                                                            top: Radius.circular(
                                                                                12)),
                                                                        color: customColors
                                                                            .backgroundColor),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              100,
                                                                          child: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                  child: Row(children: [
                                                                                    Center(
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                        child: Icon(Icons.settings, size: 35),
                                                                                      ),
                                                                                    ),
                                                                                    LocaleText('quality',
                                                                                        style: TextStyle(
                                                                                          fontSize: 20,
                                                                                        )),
                                                                                    Expanded(
                                                                                      child: Align(
                                                                                        alignment: context.currentLocale!.languageCode == 'ar' ? Alignment.centerLeft : Alignment.centerRight,
                                                                                        child: DropdownButton(
                                                                                          value: _quality,
                                                                                          icon: Icon(
                                                                                            Icons.arrow_drop_down_circle_outlined,
                                                                                            color: customColors.primaryColor,
                                                                                          ),
                                                                                          itemHeight: 50,
                                                                                          underline: SizedBox(),
                                                                                          menuMaxHeight: 300,
                                                                                          style: TextStyle(color: customColors.primaryColor),
                                                                                          dropdownColor: customColors.primaryColor.withOpacity(.8),
                                                                                          elevation: 20,
                                                                                          focusColor: customColors.iconTheme,
                                                                                          items: _qualityOptions,
                                                                                          borderRadius: BorderRadius.circular(12),
                                                                                          isExpanded: false,
                                                                                          onChanged: (value) {
                                                                                            if (_quality != value) {
                                                                                              setState(() {
                                                                                                Navigator.pop(context);
                                                                                                _quality = value.toString();
                                                                                                reloadPlayer(value.toString());
                                                                                              });
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ]),
                                                                                ),
                                                                                GestureDetector(
                                                                                    child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                  child: Row(children: [
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
                                                                      ),
                                                                    ),
                                                                  )),
                                                    );
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
                                        : widget.allEp.length == 1
                                            ? SizedBox()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    showModalBottomSheet<
                                                        dynamic>(
                                                      // backgroundColor: widget.color[1],
                                                      isScrollControlled: true,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .vertical(
                                                        top:
                                                            Radius.circular(30),
                                                      )),
                                                      context: context,
                                                      builder: (context) {
                                                        Size size =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size;
                                                        return widget.allEp
                                                                .isNotEmpty
                                                            ? Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                            begin: Alignment
                                                                                .topCenter,
                                                                            end: Alignment
                                                                                .bottomCenter,
                                                                            colors: [
                                                                              customColors.backgroundColor,
                                                                              customColors.iconTheme,
                                                                              customColors.iconTheme,
                                                                              customColors.backgroundColor,
                                                                            ]),
                                                                        borderRadius:
                                                                            BorderRadius.vertical(top: Radius.circular(30))),
                                                                child:
                                                                    DraggableScrollableSheet(
                                                                        expand:
                                                                            false,
                                                                        maxChildSize:
                                                                            0.95,
                                                                        initialChildSize:
                                                                            0.7,
                                                                        minChildSize:
                                                                            0.3,
                                                                        builder: (context,
                                                                                scrollController) =>
                                                                            Stack(
                                                                              clipBehavior: Clip.none,
                                                                              alignment: AlignmentDirectional.topCenter,
                                                                              children: [
                                                                                Positioned(
                                                                                  top: 10,
                                                                                  child: Container(height: 8, width: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.horizontal(right: Radius.circular(30), left: Radius.circular(30)))),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 20.0),
                                                                                  child: SingleChildScrollView(
                                                                                      controller: scrollController,
                                                                                      child: Column(
                                                                                          children: List.generate(
                                                                                        widget.i,
                                                                                        (index) {
                                                                                          return GestureDetector(
                                                                                            onTap: widget.epName == widget.allEp[index].name
                                                                                                ? () => Navigator.pop(context)
                                                                                                : () {
                                                                                                    Navigator.pop(context);
                                                                                                    Navigator.push(
                                                                                                        context,
                                                                                                        MaterialPageRoute(
                                                                                                            builder: (context) => NewPlayerPage(
                                                                                                                  myId: widget.myId,
                                                                                                                  url: widget.allEp[index].link,
                                                                                                                )));
                                                                                                  },
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: widget.epName == widget.allEp[index].name ? customColors.bottomDown.withOpacity(.7) : Colors.transparent),
                                                                                                height: 80,
                                                                                                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                                  CircleAvatar(
                                                                                                    radius: 30,
                                                                                                    backgroundColor: customColors.iconTheme,
                                                                                                    child: Text(
                                                                                                      widget.allEp[index].numb,
                                                                                                      style: TextStyle(color: customColors.primaryColor, fontWeight: FontWeight.bold, fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', fontSize: 25),
                                                                                                    ),
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.only(left: 10),
                                                                                                    child: Column(
                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: size.width - 100,
                                                                                                          child: Text(
                                                                                                            widget.allEp[index].name,
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: customColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 15.5),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(''),
                                                                                                        Container(
                                                                                                          width: size.width - 100,
                                                                                                          child: Text(
                                                                                                            widget.allEp[index].sub,
                                                                                                            overflow: TextOverflow.ellipsis,
                                                                                                            style: TextStyle(fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', color: customColors.primaryColor, fontSize: 12.5),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  )
                                                                                                ]),
                                                                                              ),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                      ))),
                                                                                ),
                                                                              ],
                                                                            )),
                                                              )
                                                            : Container(
                                                                height:
                                                                    size.height,
                                                                width:
                                                                    size.width,
                                                                color: Colors
                                                                    .transparent,
                                                                child: Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                      child: Icon(
                                                    Icons.playlist_play_rounded,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )),
                                                ),
                                              ),
                                    (!showControllers)
                                        ? SizedBox()
                                        : !NewPlayerPageState.fullScreen
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
                                    Expanded(child: SizedBox()),
                                    (!showControllers)
                                        ? SizedBox()
                                        : GestureDetector(
                                            onTap: () {
                                              NewPlayerPageState.fullScreen
                                                  ? fullScreenMethod()
                                                  : Navigator.pop(context);
                                            },
                                            child: Icon(
                                                NewPlayerPageState.fullScreen
                                                    ? Icons
                                                        .keyboard_arrow_down_rounded
                                                    : Icons
                                                        .arrow_back_ios_rounded,
                                                color: Colors.white),
                                          )
                                  ]),
                            )),
                        Expanded(
                            child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  (!showControllers)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () async {
                                            String url = widget.animeLink;
                                            String ep =
                                                (widget.eNP - 1).toString();
                                            String urlLast = url.substring(
                                                0,
                                                url.indexOf(
                                                    '-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-'));
                                            urlLast =
                                                '$urlLast-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-$ep';

                                            print(
                                                '///////////////////////////// $urlLast');
                                            if (widget.eNP > 1) {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewPlayerPage(
                                                              url: urlLast,
                                                              myId: widget
                                                                  .myId)));
                                            }
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: widget.eNP > 1
                                                      ? Colors.black
                                                          .withOpacity(.5)
                                                      : Colors.black
                                                          .withOpacity(.2)),
                                              child: Center(
                                                  child: Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationY(
                                                    context.currentLocale!
                                                                .languageCode ==
                                                            "ar"
                                                        ? math.pi
                                                        : math.pi * 2),
                                                child: Icon(
                                                  (Icons.skip_previous_rounded),
                                                  size: 35,
                                                  color: widget.eNP > 1
                                                      ? Colors.white
                                                      : Colors.white
                                                          .withOpacity(.5),
                                                ),
                                              ))),
                                        ),
                                  (!showControllers &&
                                          !_videoPlayerController
                                              .value.isBuffering)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _videoPlayerController
                                                      .value.isBuffering
                                                  ? null
                                                  : _videoPlayerController
                                                          .value.isPlaying
                                                      ? _videoPlayerController
                                                          .pause()
                                                      : ({
                                                          _videoPlayerController
                                                              .play(),
                                                          unDisplay()
                                                        });
                                            });
                                          },
                                          child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.black
                                                      .withOpacity(.5)),
                                              child: _videoPlayerController
                                                      .value.isBuffering
                                                  ? LoadingGif(
                                                      logo: true,
                                                    )
                                                  : Center(
                                                      child: Icon(
                                                      size: 50,
                                                      (_videoPlayerController
                                                                  .value
                                                                  .duration ==
                                                              _videoPlayerController
                                                                  .value
                                                                  .position)
                                                          ? Icons
                                                              .replay_outlined
                                                          : _videoPlayerController
                                                                  .value
                                                                  .isPlaying
                                                              ? Icons
                                                                  .pause_outlined
                                                              : Icons
                                                                  .play_arrow_outlined,
                                                      color: Colors.white,
                                                    ))),
                                        ),
                                  (!showControllers)
                                      ? SizedBox()
                                      : GestureDetector(
                                          onTap: () async {
                                            String url = widget.animeLink;
                                            String ep =
                                                (widget.eNP + 1).toString();
                                            String urlNext = url.substring(
                                                0,
                                                url.indexOf(
                                                    '-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-'));
                                            urlNext =
                                                '$urlNext-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a9-$ep';
                                            print(
                                                '///////////////////////////// $urlNext');
                                            if (widget.allEp.length >
                                                widget.eNP) {
                                              Navigator.pop(context);

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewPlayerPage(
                                                              url: urlNext,
                                                              myId: widget
                                                                  .myId)));
                                            }
                                          },
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: widget.allEp.length <=
                                                          widget.eNP
                                                      ? Colors.black
                                                          .withOpacity(.3)
                                                      : Colors.black
                                                          .withOpacity(.5)),
                                              child: Center(
                                                  child: Transform(
                                                alignment: Alignment.center,
                                                transform: Matrix4.rotationY(
                                                    context.currentLocale!
                                                                .languageCode ==
                                                            "ar"
                                                        ? math.pi
                                                        : math.pi * 2),
                                                child: Icon(
                                                  (Icons.skip_next_rounded),
                                                  size: 35,
                                                  color: widget.allEp.length <=
                                                          widget.eNP
                                                      ? Colors.white
                                                          .withOpacity(.5)
                                                      : Colors.white,
                                                ),
                                              ))),
                                        ),
                                ]),
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical:
                                  NewPlayerPageState.fullScreen ? 30 : 15),
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
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      height: 8,
                                      //  width: size.width - 100,
                                      child: (!showControllers &&
                                              !_videoPlayerController
                                                  .value.isBuffering)
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