import 'dart:isolate';
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  Future download(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectories();
      await FlutterDownloader.enqueue(
    
        url: url,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: baseStorage![0].path,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print(
            "///////////////////////////////  complete  ///////////////////////////////");
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  //@pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: Center(
          child: Container(
            width: 50,
            height: 100,
            child: TextButton(
              onPressed: () {
                download(
                    "https://i1.wp.com/animetitans.com/wp-content/uploads/Detective-Conan-Movie-25.jpg");
              },
              child: Text(
                "Download",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ));
  }
}
