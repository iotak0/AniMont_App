import 'package:anime_mont_test/server/urls_php.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AnimeVideoPlayer extends StatefulWidget {
  const AnimeVideoPlayer({
    super.key,
    required this.url,
  });

  final String url;

  @override
  State<AnimeVideoPlayer> createState() => _AnimeVideoPlayerState();
}

class _AnimeVideoPlayerState extends State<AnimeVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  late ChewieController _chewieController;
  Future initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.url);
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      aspectRatio: 16 / 9,
      // customControls: Container(
      //     height: 30,
      //     width: 30,
      //     child: Image.asset('images/Light/Download.png')),

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
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topStart,
          fit: StackFit.passthrough,
          children: [
            Container(
              height: size.height / 3,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              child: _chewieController != null
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : Center(child: CircularProgressIndicator()),
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
