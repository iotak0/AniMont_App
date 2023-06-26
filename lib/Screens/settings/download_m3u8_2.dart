// import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// //import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_player/video_player.dart';

// class DownloadScreen2 extends StatefulWidget {
//   final String m3u8Url;

//   DownloadScreen2({required this.m3u8Url});

//   @override
//   _DownloadScreen2State createState() => _DownloadScreen2State();
// }

// class _DownloadScreen2State extends State<DownloadScreen2> {
//   late VideoPlayerController _controller;
//   bool loading = false;
//   var directory;
//   var filePath;
//   @override
//   void initState() {
//     super.initState();
//     FlutterDownloader.initialize();
//     download(widget.m3u8Url).then((value) async {
//       String outputPath = "${directory.path}/mp4";
//       String mp4Path = await Convert(value, outputPath);
//     });
//   }

//   Future downloadFile(String url) async {
//     loading = true;
//     setState(() {});
//     var httpC = HttpClient();
//     var req = await httpC.getUrl(Uri.parse(url));
//     var res = await req.close();
//     var bytes = await consolidateHttpClientResponseBytes(res);

//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       directory =
//           //await getApplicationDocumentsDirectory();
//           await Directory('/storage/emulated/0/Download/AniMont/')
//               .create(recursive: true);
//       filePath = '${directory.path}temp.m3u8';
//     }
//     File file = File(filePath);
//     await file.writeAsBytes(bytes);
//     loading = false;
//     setState(() {});
//     return filePath;
//   }

//   Future download(String url) async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       var directory =
//           await Directory('/storage/emulated/0/Download/AniMont/Anime/')
//               .create(recursive: true);
//       final baseStorage = directory.path;
//       await FlutterDownloader.enqueue(
//         fileName: 'temp.m3u8',
//         url: url,
//         headers: {}, // optional: header send with url (auth token etc)
//         savedDir: baseStorage,
//         showNotification:
//             true, // show download progress in status bar (for Android)
//         openFileFromNotification:
//             true, // click on notification to open downloaded file (for Android)
//       );
//     }
//     return '/storage/emulated/0/Download/AniMont/Anime/temp.m3u8';
//   }

//   Convert(String inputPath, String outputPath) async {
//     loading = true;
//     setState(() {});
//     // FlutterFFmpeg flutterFFmpeg = new FlutterFFmpeg();
//     var rc = await FFmpegKit.execute('-i $inputPath -c copy $outputPath');

//     //print("FFmpeg process exited with rc $rc");

//     if (rc != null) {
//       showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//           title: Text('Success!'),
//           content: Text('Your video has been downloaded and converted.'),
//         ),
//       );
//       loading = false;
//       setState(() {});

//       _controller = VideoPlayerController.file(File(outputPath))
//         ..initialize().then((_) {
//           setState(() {});
//           _controller.play();
//         });
//       return outputPath;
//     } else {
//       loading = false;
//       setState(() {});
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _controller.pause();
//     _controller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Download Screen'),
//       ),
//       body: Center(
//         child: !loading && _controller.value.isInitialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
