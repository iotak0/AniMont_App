import 'package:anime_mont_test/server/urls_php.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../provider/player_motif.dart';

class AnimeVideoPlayer extends StatefulWidget {
  const AnimeVideoPlayer({
    super.key,
    required this.url,
    required this.context,
  });

  final String url;
  final BuildContext context;

  @override
  State<AnimeVideoPlayer> createState() => AnimeVideoPlayerState();
}

class AnimeVideoPlayerState extends State<AnimeVideoPlayer> {
  static late VideoPlayerController videoPlayerController;
  static late ChewieController chewieController;
  static var overlay;
  Future initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      aspectRatio: 16 / 9,
      // customControls: Container(
      //     height: 30,
      //     width: 30,
      //     child: Image.asset('images/Light/Download.png')),
      optionsTranslation: OptionsTranslation(
          cancelButtonText: widget.context.localeString('Cancel'),
          playbackSpeedButtonText:
              widget.context.localeString('playbackSpeed')),
      autoPlay: false,

      showControls: true,
      fullScreenByDefault: false,
      allowFullScreen: true,
      looping: false,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
    chewieController.notifyListeners();
    videoPlayerController.addListener(() {
      if (chewieController.isPlaying) {
        if (vis) {
          vis = false;
          setState(() {});
        } else {
          vis = true;
          setState(() {});
        }
        setState(() {});
      } else {
        if (vis) {
          vis = false;
          setState(() {});
        } else {
          vis = true;
          setState(() {});
        }
        setState(() {});
      }
    });
  }

  static bool vis = false;
  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();

    super.dispose();
  }

  int time = DateTime.now().second;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          //alignment: AlignmentDirectional.topStart,
          fit: StackFit.passthrough,
          children: [
            GestureDetector(
              child: Container(
                height: 240,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25)),
                ),
                child: chewieController != null
                    ? Stack(
                        //alignment: AlignmentDirectional.topStart,
                        fit: StackFit.passthrough,
                        children: [
                          Chewie(
                            controller: chewieController,
                          ),
                          vis == true ? CustController() : Container(),
                        ],
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   decoration: BoxDecoration(
        //     color: Color.fromARGB(45, 0, 0, 0),
        //     borderRadius: BorderRadius.circular(14),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       Container(
        //         child: const Text(
        //           '04:55',
        //           style: TextStyle(
        //             fontSize: 16,
        //             color: Colors.grey,
        //           ),
        //         ),
        //       ),
        //       SizedBox(
        //         width: size.width / 3,
        //       ),
        //       Container(
        //         child: const Text(
        //           '24:00',
        //           style: TextStyle(
        //             fontSize: 16,
        //             color: Colors.grey,
        //           ),
        //         ),
        //       ),
        //       const Icon(
        //         Icons.settings,
        //         color: Colors.grey,
        //       ),
        //       const Icon(
        //         Icons.subtitles,
        //         color: Colors.grey,
        //       ),
        //       const Icon(
        //         Icons.fullscreen,
        //         color: Colors.grey,
        //       )
        //     ],
        //   ),
        // )
      ],
    );
  }
}

class CustController extends StatefulWidget {
  const CustController({
    Key? key,
  }) : super(key: key);

  @override
  State<CustController> createState() => _CustControllerState();
}

class _CustControllerState extends State<CustController> {
  @override
  void initState() {
    super.initState();
    AnimeVideoPlayerState.chewieController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 110,
      width: MediaQuery.of(context).size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        GestureDetector(
          onTap: () {
            AnimeVideoPlayerState.chewieController.seekTo(Duration(
                seconds: AnimeVideoPlayerState
                        .videoPlayerController.value.position.inSeconds -
                    10));
          },
          child: const ImageIcon(
            AssetImage('images/Light/Download.png'),
            color: Colors.white,
            size: 30,
          ),
        ),
        GestureDetector(
          onTap: () {
            AnimeVideoPlayerState.chewieController.seekTo(Duration(
                seconds: AnimeVideoPlayerState
                        .videoPlayerController.value.position.inSeconds +
                    10));
          },
          child: const ImageIcon(
            AssetImage('images/Light/Download.png'),
            color: Colors.white,
            size: 30,
          ),
        ),
      ]),
    );
  }
}
