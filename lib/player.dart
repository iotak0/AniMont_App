import 'dart:io';

import 'package:anime_mont_test/utils/image_helper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final String url;
  const Player({Key? key, required this.url}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  var _file;
  ChewieController? _chewieController;
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    setState(() {
      _file = File('/storage/emulated/0/Movies/');
      initPlayer();
    });
  }

  void initPlayer() {
    // final ImageHelper imageHelper = ImageHelper(
    //   source: ImageSource.gallery,
    // );
    // final file = await imageHelper.pickVideo();
    // print("Video  ${file!.path.toString()}");

    setState(() {
      var directory = Directory('/storage/emulated/0/BTInsta/');

      _videoPlayerController = VideoPlayerController.file(
          File(directory.path + 'ellite.auto-20230104-0001.mp4'));
      print("Vidio  ${_videoPlayerController.dataSourceType.toString()}");
      _videoPlayerController.initialize();
    });
    _chewieController = ChewieController(
        cupertinoProgressColors: ChewieProgressColors(
            backgroundColor: Colors.pink,
            bufferedColor: Colors.pink,
            handleColor: Colors.pink,
            playedColor: Color.fromRGBO(233, 30, 99, 1)),
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: () => canLaunchUrlString('com.dv.adm'),
              iconData: Icons.download,
              title: "Download",
            ),
            OptionItem(
              onTap: () => debugPrint('Copy Url'),
              iconData: Icons.copy,
              title: "Copy Url",
            ),
          ];
        });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: _chewieController != null
          ? Chewie(
              controller: _chewieController!,
            )
          : Center(
              child: CircularProgressIndicator(color: Colors.pink),
            ),
    );
  }
}
