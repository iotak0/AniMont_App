import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:anime_mont_test/pages/content_screen.dart';

class Home extends StatelessWidget {
  final List<String> videos = [
    'videos/video2.mp4',
    'videos/video.mp4',
    'videos/video2.mp4',
    'videos/video2.mp4',
    'videos/video2.mp4',
    'videos/video2.mp4',
    'videos/video.mp4',
    'videos/video2.mp4',
    'videos/video2.mp4',
    'videos/video2.mp4',
    'videos/video.mp4',
    'videos/video2.mp4',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              //We need swiper for every content
              Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ContentScreen(
                    src: videos[index],
                  );
                },
                itemCount: videos.length,
                scrollDirection: Axis.vertical,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Flutter Shorts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.camera_alt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
