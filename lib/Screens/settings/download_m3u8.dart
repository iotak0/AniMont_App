// import 'dart:async';
// import 'dart:io';
// import 'package:anime_mont_test/Screens/settings/download_m3u8_2.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: DownloadScreen(),
//     );
//   }
// }

// class DownloadScreen extends StatefulWidget {
//   @override
//   _DownloadScreenState createState() => _DownloadScreenState();
// }

// class _DownloadScreenState extends State<DownloadScreen> {
//   final TextEditingController _urlController = TextEditingController();
//   final FFmpegKit _flutterFFmpeg = FFmpegKit();

//   String? _taskId;

//   @override
//   void initState() {
//     super.initState();
//     //FlutterDownloader.initialize();
//   }

//   Future<String?> getDownloadPath() async {
//     Directory? directory;
//     try {
//       if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = Directory(
//             '/storage/emulated/0/Download/AniMont/Anime' + '/video.mp4');

//         // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
//         // ignore: avoid_slow_async_io
//         if (!await directory.exists())
//           directory = await getExternalStorageDirectory();
//       }
//     } catch (err, stack) {
//       print("Cannot get download folder path");
//     }
//     return directory?.path;
//   }

//   void _downloadAndConvert() async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       var appDocDir = await Directory('/storage/emulated/0/Download/AniMont')
//           .create(recursive: true);
//       print('/storage/emulated/0/Download/AniMont');
//       final String savePath = appDocDir.path + '/video.mp4';
//       //await getDownloadPath();
//       /*final taskId = await FlutterDownloader.enqueue(
//         //fileName: epName + '.mp4',
//         url: _urlController.text,
//         headers: {}, // optional: header send with url (auth token etc)
//         savedDir: baseStorage,
//         fileName: 'video.m3u8',
//         showNotification:
//             true, // show download progress in status bar (for Android)
//         openFileFromNotification:
//             true, // click on notification to open downloaded file (for Android)
//       );*/
//       // Directory appDocDir = await getApplicationDocumentsDirectory();
//       // final String savePath = appDocDir.path + '/video.mp4';

//       final taskId = await FlutterDownloader.enqueue(
//         url: _urlController.text,
//         savedDir: appDocDir.path,
//         fileName: 'video2.m3u8',
//         showNotification: true,
//         openFileFromNotification: true,
//       );

//       // FFmpegKit.execute('-i $appDocDir/video.m3u8 -c copy $savePath')
//       //     //FFmpegKit.execute('-i $appDocDir/video.m3u8 -c copy $savePath')
//       //     .then((result) {
//       //   print("FFmpeg process exited with rc $result");

//       //   if (result == 0) {
//       //     setState(() {
//       //       _taskId = null;
//       //     });
//       //     showDialog(
//       //       context: context,
//       //       builder: (ctx) => AlertDialog(
//       //         title: Text('Success!'),
//       //         content: Text('Your video has been downloaded and converted.'),
//       //       ),
//       //     );
//       //   }
//       // });

//       setState(() {
//         _taskId = taskId;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Download and Convert'),
//       ),
//       body: SizedBox(
//         height: 500,
//         child: Column(
//           children: [
//             TextField(
//               controller: _urlController,
//               decoration: InputDecoration(
//                 labelText: 'Enter m3u8 URL',
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: GestureDetector(
//                   child: Text(_taskId == null
//                       ? 'Download and Convert'
//                       : 'Downloading...'),
//                   onTap: () {
//                     _downloadAndConvert();
//                     setState(() {});
//                   }),
//             ),
//             GestureDetector(
//               child: Text('ok'),
//               onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DownloadScreen2(
//                         m3u8Url: _urlController.text
//                         //'https://assets.afcdn.com/video49/20210722/v_645516.m3u8'
//                         ),
//                   )),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
