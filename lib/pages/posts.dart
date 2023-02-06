import 'package:anime_mont_test/pages/post_comments.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List images = ['images/reigen2.gif', 'images/reigen.gif'];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Posts(size: size, images: images),
    ));
  }
}

class Posts extends StatelessWidget {
  const Posts({
    Key? key,
    required this.size,
    required this.images,
  }) : super(key: key);

  final Size size;
  final List images;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
        ),
        Container(
            child: Column(
          children: [
            Container(
              height: 50,
              width: size.width,
              color: Color.fromARGB(255, 6, 0, 24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage('images/reigen2.gif'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Mont',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 184, 183, 183)),
                            ),
                            Text(
                              'mont999',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(minHeight: 50),
              height: 450,
              child: Swiper(
                loop: false,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(images[index]),
                                fit: BoxFit.cover)),
                      ),
                      Positioned(
                        right: 15,
                        top: 15,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(166, 0, 0, 0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                '${index + 1}/${images.length}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )),
                      ),
                    ],
                  );
                },
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
            Container(
                height: 50,
                width: size.width,
                color: Color.fromARGB(255, 6, 0, 24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: ImageIcon(
                                AssetImage('images/Light/Heart.png'),
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostComments(
                                                animeId: 5,
                                                myId: 5,
                                              )));
                                },
                                child: ImageIcon(
                                  AssetImage('images/Light/Chat.png'),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: ImageIcon(
                                AssetImage('images/Light/Send.png'),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(flex: 3, child: Container()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: ImageIcon(
                            AssetImage('images/Light/Wallet.png'),
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        )),
        Container(
          //height: 50,
          width: size.width,
          color: Color.fromARGB(255, 6, 0, 24),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Liked by iotak0 and others',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Text(
                  'mont999 ريغن شوشو (:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostComments(
                                  animeId: 5,
                                  myId: 0,
                                )));
                  },
                  child: Text(
                    'View all 52 comments',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 128, 126, 126)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 2),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundImage: AssetImage('images/reigen2.gif'),
                      ),
                    ),
                    Text(
                      'Add a comment',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 128, 126, 126)),
                    ),
                  ]),
                ),
                Row(
                  children: [
                    Text(
                      '3 days ago . ',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 128, 126, 126)),
                    ),
                    Text(
                      'See translation',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Post {
  final String id;
  final String username;
  final String name;
  final String avatar;
  final String description;
  final String postTime;
  final List<String> likedBy;
  final List<String> postCont;
  final int commentsCount;

  Post(this.id, this.username, this.name, this.avatar, this.description,
      this.postTime, this.likedBy, this.postCont, this.commentsCount);
}
