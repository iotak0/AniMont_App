import 'dart:convert';

import 'package:anime_mont_test/Screens/Posts/post_class.dart';
import 'package:anime_mont_test/Screens/Posts/post_explore.dart';
import 'package:anime_mont_test/Screens/Posts/posts_all.dart';
import 'package:anime_mont_test/Screens/Posts/posts_frends.dart';
import 'package:anime_mont_test/helper/constans.dart';
import 'package:anime_mont_test/models/get_x_controller.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/create_post.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/keep_page.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key, required this.myId});
  final int myId;
  @override
  State<PostsPage> createState() => PostsPageState();
}

class PostsPageState extends State<PostsPage> {
  bool isExplore = true;
  final int maxLength = 15;
  static bool erorr = false;
  static int page = 1;
  static late ScrollController scrollController;

  static bool isLoading = false;
  static bool hasMore = true;
  static bool complet = false;

  getPosts() async {
    setState(() {
      hasMore = true;
      isLoading = true;
      erorr = false;
    });
    final response = await http
        .get(Uri.parse(isExplore
            ? "$all_posts?page=$page&user_id=${widget.myId}"
            : "$followers_posts?page=$page&user_id=${widget.myId}"))
        .catchError((erorr0) {
      isLoading = false;
      erorr = true;
      setState(() {});
      return Response('error', 400);
    });

    if (response.statusCode == 200) {
      var data;
      print(response.body);
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        setState(() {
          isLoading = false;
          complet = true;
        });
        return;
      }
      data.isNotEmpty ? page++ : page;
      List<Map<String, dynamic>> users = []; //user
      //List string = ["name", "username", "admin", "avata"];
      for (var e in data) {
        Map<String, dynamic> userPost = {};
        List list = e["user"];
        for (var user in list) {
          userPost.addAll(user);
        }
        users.add(userPost);
      }
      List<List<Map<String, dynamic>>> postsCont = []; //user
      //List string = ["name", "username", "admin", "avata"];
      for (var e in data) {
        List<Map<String, dynamic>> cont = [];

        List list = e["posts_cont"];
        for (var contItem in list) {
          cont.add(contItem);
        }

        postsCont.add(cont);
      }

      for (var e in data) {
        ChatGetX.posts.add(Post(
            e['id'] ?? '',
            e['post_user'] ?? '',
            users[data.indexOf(e)],
            e['caption'] ?? '',
            e['post_date'] ?? '',
            postsCont[data.indexOf(e)],
            e['is_like'],
            e['comments'] ?? 0,
            e['likes'] ?? 0,
            e['post_cont'] ?? 0,
            e["time"],
            e['is_followed'],
            e['admin'] ?? false));
      }
      setState(() {
        isLoading = false;

        hasMore = (data.length >= maxLength) ? true : false;
      });
    } else {
      setState(() {
        erorr = true;
        isLoading = false;
      });
    }
    complet = true;
    setState(() {});
  }

  Future refresh() async {
    hasMore = true;
    page = 1;
    erorr = false;
    isLoading = false;
    setState(() {});
    ChatGetX.posts.clear();
    getPosts();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPosts();

    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent * 0.95 &&
          !isLoading &&
          hasMore) {
        getPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: customColors.backgroundColor,
          elevation: 1,
          title: GestureDetector(
            onTap: () {
              if (!isLoading && complet) {
                showModalBottomSheet<dynamic>(
                  backgroundColor: Colors.transparent,
                  // isScrollControlled: true,
                  context: context,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    maxChildSize: .5,
                    builder: (context, scrollController) => Container(
                      //height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: customColors.backgroundColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12))),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExplore = !isExplore ? true : false;
                          });
                          complet = false;
                          erorr = false;

                          page = 1;
                          ChatGetX.posts.clear();
                          getPosts();
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: customColors.iconTheme,
                              child: SvgPicture.string(
                                isExplore
                                    ? '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                              <title>Iconly/Light-Outline/Star</title>
                              <g id="Iconly/Light-Outline/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                  <path d="M11.7499161,4.5 C11.6589161,4.5 11.4349161,4.525 11.3159161,4.763 L9.48991609,8.414 C9.20091609,8.991 8.64391609,9.392 7.99991609,9.484 L3.91191609,10.073 C3.64191609,10.112 3.54991609,10.312 3.52191609,10.396 C3.49691609,10.477 3.45691609,10.683 3.64291609,10.861 L6.59891609,13.701 C7.06991609,14.154 7.28391609,14.807 7.17191609,15.446 L6.47591609,19.456 C6.43291609,19.707 6.58991609,19.853 6.65991609,19.903 C6.73391609,19.959 6.93191609,20.07 7.17691609,19.942 L10.8319161,18.047 C11.4079161,17.75 12.0939161,17.75 12.6679161,18.047 L16.3219161,19.941 C16.5679161,20.068 16.7659161,19.957 16.8409161,19.903 C16.9109161,19.853 17.0679161,19.707 17.0249161,19.456 L16.3269161,15.446 C16.2149161,14.807 16.4289161,14.154 16.8999161,13.701 L19.8559161,10.861 C20.0429161,10.683 20.0029161,10.476 19.9769161,10.396 C19.9499161,10.312 19.8579161,10.112 19.5879161,10.073 L15.4999161,9.484 C14.8569161,9.392 14.2999161,8.991 14.0109161,8.413 L12.1829161,4.763 C12.0649161,4.525 11.8409161,4.5 11.7499161,4.5 M6.94691609,21.5 C6.53391609,21.5 6.12391609,21.37 5.77291609,21.114 C5.16691609,20.67 4.86991609,19.937 4.99891609,19.199 L5.69491609,15.189 C5.72091609,15.04 5.66991609,14.889 5.55991609,14.783 L2.60391609,11.943 C2.05991609,11.422 1.86491609,10.652 2.09491609,9.937 C2.32691609,9.214 2.94091609,8.697 3.69791609,8.589 L7.78591609,8 C7.94391609,7.978 8.07991609,7.881 8.14791609,7.743 L9.97491609,4.091 C10.3119161,3.418 10.9919161,3 11.7499161,3 L11.7499161,3 C12.5079161,3 13.1879161,3.418 13.5249161,4.091 L15.3529161,7.742 C15.4219161,7.881 15.5569161,7.978 15.7139161,8 L19.8019161,8.589 C20.5589161,8.697 21.1729161,9.214 21.4049161,9.937 C21.6349161,10.652 21.4389161,11.422 20.8949161,11.943 L17.9389161,14.783 C17.8289161,14.889 17.7789161,15.04 17.8049161,15.188 L18.5019161,19.199 C18.6299161,19.938 18.3329161,20.671 17.7259161,21.114 C17.1109161,21.565 16.3099161,21.626 15.6309161,21.272 L11.9779161,19.379 C11.8349161,19.305 11.6639161,19.305 11.5209161,19.379 L7.86791609,21.273 C7.57591609,21.425 7.26091609,21.5 6.94691609,21.5" id="Star" fill="#000000"></path>
                              </g>
                          </svg>'''
                                    : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                              <title>Iconly/Light-Outline/Discovery</title>
                              <g id="Iconly/Light-Outline/Discovery" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                  <g id="Discovery" transform="translate(2.000000, 2.000000)" fill="#000000">
                                      <path d="M10.3608,-2.13162821e-14 C16.0738,-2.13162821e-14 20.7218,4.648 20.7218,10.361 C20.7218,16.074 16.0738,20.722 10.3608,20.722 C4.6478,20.722 -0.0002,16.074 -0.0002,10.361 C-0.0002,4.648 4.6478,-2.13162821e-14 10.3608,-2.13162821e-14 Z M10.3608,1.5 C5.4748,1.5 1.4998,5.476 1.4998,10.361 C1.4998,15.247 5.4748,19.222 10.3608,19.222 C15.2468,19.222 19.2218,15.247 19.2218,10.361 C19.2218,5.476 15.2468,1.5 10.3608,1.5 Z M14.2324,6.4899 C14.4294,6.6879 14.5014,6.9789 14.4174,7.2439 L12.8254,12.3329 C12.7524,12.5679 12.5674,12.7519 12.3334,12.8249 L7.2444,14.4179 C7.1704,14.4409 7.0944,14.4519 7.0204,14.4519 C6.8244,14.4519 6.6324,14.3749 6.4894,14.2329 C6.2924,14.0349 6.2204,13.7439 6.3044,13.4789 L7.8974,8.3899 C7.9704,8.1539 8.1544,7.9709 8.3884,7.8979 L13.4774,6.3049 C13.7444,6.2199 14.0344,6.2929 14.2324,6.4899 Z M12.5584,8.1639 L9.2114,9.2119 L8.1644,12.5589 L11.5104,11.5109 L12.5584,8.1639 Z" id="Combined-Shape"></path>
                                  </g>
                              </g>
                          </svg>''',
                                color: customColors.primaryColor,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            LocaleText(isExplore ? "following" : "explore",
                                style: TextStyle(
                                    fontFamily: 'SFPro',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: customColors.primaryColor))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LocaleText(
                  'community',
                  style: TextStyle(
                      fontFamily: 'SFPro',
                      fontWeight: FontWeight.bold,
                      color: customColors.primaryColor),
                ),
                SizedBox(
                  width: 2,
                ),
                isLoading
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: customColors.iconTheme,
                          child: SvgPicture.string(
                            '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
              <title>Iconly/Light-Outline/Arrow - Down 2</title>
              <g id="Iconly/Light-Outline/Arrow---Down-2" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                  <g id="Arrow---Down-2" transform="translate(4.000000, 7.500000)" fill="#000000" fill-rule="nonzero">
              <path d="M0.469669914,0.469669914 C0.735936477,0.203403352 1.15260016,0.1791973 1.44621165,0.397051761 L1.53033009,0.469669914 L8,6.939 L14.4696699,0.469669914 C14.7359365,0.203403352 15.1526002,0.1791973 15.4462117,0.397051761 L15.5303301,0.469669914 C15.7965966,0.735936477 15.8208027,1.15260016 15.6029482,1.44621165 L15.5303301,1.53033009 L8.53033009,8.53033009 C8.26406352,8.79659665 7.84739984,8.8208027 7.55378835,8.60294824 L7.46966991,8.53033009 L0.469669914,1.53033009 C0.176776695,1.23743687 0.176776695,0.762563133 0.469669914,0.469669914 Z" id="Stroke-1"></path>
                  </g>
              </g>
          </svg>''',
                            color: customColors.primaryColor,
                            height: 15,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePost(),
                        settings: RouteSettings())),
                child: SizedBox(
                  child: SvgPicture.string(
                    '<?xml version="1.0" encoding="utf-8"?><svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="122.879px" height="122.88px" viewBox="0 0 122.879 122.88" enable-background="new 0 0 122.879 122.88" xml:space="preserve"><g><path d="M17.995,17.995C29.992,5.999,45.716,0,61.439,0s31.448,5.999,43.445,17.995c11.996,11.997,17.994,27.721,17.994,43.444 c0,15.725-5.998,31.448-17.994,43.445c-11.997,11.996-27.722,17.995-43.445,17.995s-31.448-5.999-43.444-17.995 C5.998,92.888,0,77.164,0,61.439C0,45.716,5.998,29.992,17.995,17.995L17.995,17.995z M57.656,31.182 c0-1.84,1.492-3.332,3.333-3.332s3.333,1.492,3.333,3.332v27.383h27.383c1.84,0,3.332,1.492,3.332,3.332 c0,1.841-1.492,3.333-3.332,3.333H64.321v27.383c0,1.84-1.492,3.332-3.333,3.332s-3.333-1.492-3.333-3.332V65.229H30.273 c-1.84,0-3.333-1.492-3.333-3.333c0-1.84,1.492-3.332,3.333-3.332h27.383V31.182L57.656,31.182z M61.439,6.665 c-14.018,0-28.035,5.348-38.731,16.044C12.013,33.404,6.665,47.422,6.665,61.439c0,14.018,5.348,28.036,16.043,38.731 c10.696,10.696,24.713,16.044,38.731,16.044s28.035-5.348,38.731-16.044c10.695-10.695,16.044-24.714,16.044-38.731 c0-14.017-5.349-28.035-16.044-38.73C89.475,12.013,75.457,6.665,61.439,6.665L61.439,6.665z"/></g></svg>',
                    height: 25,
                    width: 25,
                    color: customColors.primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
        body: (isLoading && !erorr && ChatGetX.posts.isEmpty)
            ? LoadingGif(
                logo: true,
              )
            : (erorr && posts.isEmpty)
                ? AlartInternet(onTap: () => isLoading ? null : getPosts())
                : (complet && ChatGetX.posts.isEmpty)
                    ? Alart(body: 'no_posts_yet', icon: noPosts)
                    : RefreshIndicator(
                        onRefresh: () => refresh(),
                        child: AllPostsPage(
                          explore: isExplore,
                          myId: widget.myId,
                        ),
                      ));
  }
}
