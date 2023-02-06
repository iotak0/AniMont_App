import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/AnimeDetalis/components/background_widget.dart';
import '../utils/buttons/arrow_back_button.dart';
import '../utils/constes.dart';

class DetailsPage extends StatefulWidget {
  final Anime anime;
  const DetailsPage(this.anime, {Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final List<Color> light = [darkPink, lightPink];
  final List<Color> dark = [darkPurple, lightPurple];
  late List<Color> _color;
  bool _clicked = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: darkPurple,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              BackgroundWidget(size: size, anime: widget.anime),
              Container(
                height: size.height / 3.5,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [lightPurple2, darkPurple2],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
              ),
              ArrowBackButton(size: size),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 24.0, top: size.height / 4.5),
                    child: Row(
                      children: [
                        SizedBox(
                          width: size.width / 2.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              widget.anime.poster,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8, bottom: 8),
                              width: size.width,
                              child: Text(
                                widget.anime.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                      ),
                                      Icon(
                                        Icons.star,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${widget.anime.score}',
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                width: size.width,
                                child: const Text(
                                  'Action ,Adventure & comedy',
                                  style: TextStyle(fontSize: 16),
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                width: size.width,
                                child: const Text(
                                  'Winter 2022',
                                  style: TextStyle(fontSize: 16),
                                )),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      children: widget.anime.episode.asMap().entries.map((e) {
                        var index = e.key + 1;

                        return Padding(
                          padding: const EdgeInsets.all(14),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _clicked = true;
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => AllAnime(
                                //               link:
                                //                   'https://animetitans.com/anime/?order=update',
                                //               headLine: 'NEW EP ADDED',
                                //             )));
                              });
                            },
                            onDoubleTap: () {
                              setState(() {
                                _clicked = false;
                              });
                            },
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: _color = _clicked == false
                                                ? light
                                                : dark),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Text('$index'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}



// Scaffold(
//       backgroundColor: darkPurple,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(children: [
//               BackgroundWidget(size: size, anime: widget.anime),
//               Container(
//                 height: size.height / 3.5,
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: [lightPurple2, darkPurple2],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter),
//                 ),
//               ),
//               ArrowBackButton(size: size),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding:
//                         EdgeInsets.only(left: 24.0, top: size.height / 4.5),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: size.width / 2.5,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(14),
//                             child: Image.network(
//                               widget.anime.poster,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                             child: Column(
//                           children: [
//                             Container(
//                               padding:
//                                   const EdgeInsets.only(left: 8, bottom: 8),
//                               width: size.width,
//                               child: Text(
//                                 e.name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500, fontSize: 20),
//                               ),
//                             ),
//                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 3.0,
//                                                       vertical: 3),
//                                               child: Container(
//                                                 width: double.infinity,
//                                                 child: Wrap(
//                                                   spacing: 1,
//                                                   runSpacing: 1,
//                                                   alignment:
//                                                       WrapAlignment.start,
//                                                   children: e.category
//                                                       .asMap()
//                                                       .entries
//                                                       .map((e) {
//                                                     return Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               20),
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           setState(() {
//                                                             Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                     builder: (context) =>
//                                                                         GenrePage(
//                                                                             genre:
//                                                                                 e.value)));
//                                                           });
//                                                         },
//                                                         child: Expanded(
//                                                           child:
//                                                               GestureDetector(
//                                                             child: Container(
//                                                               height: 25,
//                                                               width: 50,
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               decoration: BoxDecoration(
//                                                                   gradient:
//                                                                       const LinearGradient(
//                                                                           colors: [
//                                                                         darkPurple,
//                                                                         darkPink
//                                                                       ]),
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               25)),
//                                                               child: Text(
//                                                                 '${e.value.trim()}',
//                                                                 style: const TextStyle(
//                                                                     fontSize:
//                                                                         14,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .bold),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     );
//                                                   }).toList(),
//                                                 ),
//                                               ),
//                                             )
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   buildTitle('Episodes'),
//                           ],
//                         )),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ]),
//             Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Wrap(
//                       children: e.ep.entries.map((e)  {
//                         var index = e.key;
//                         return Padding(
//                           padding: const EdgeInsets.all(14),
//                           child: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 _clicked = true;
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => RecentlyUpdated()));
//                               });
//                             },
//                             onDoubleTap: () {
//                               setState(() {
//                                 _clicked = false;
//                               });
//                             },
//                             child: SizedBox(
//                               width: 60,
//                               height: 60,
//                               child: Expanded(
//                                 child: GestureDetector(
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(
//                                             colors: _color = _clicked == false
//                                                 ? light
//                                                 : dark),
//                                         borderRadius:
//                                             BorderRadius.circular(14)),
//                                     child: Text('$index'),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ))
//           ],
//         ),
//       ),
//     );