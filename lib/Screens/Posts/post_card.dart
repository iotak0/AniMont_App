import 'package:anime_mont_test/Screens/Posts/post_class.dart';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/settings/circleBotton.dart';
import 'package:anime_mont_test/Screens/signup&login/onboarding_page.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/server_php.dart';
import 'dart:math' as math;
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:anime_mont_test/widgets/alart_internet.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/post_comments.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';

import 'package:http/http.dart' as http;
import 'package:readmore/readmore.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends StatefulWidget {
  const PostCard(
      {Key? key,
      required this.size,
      required this.post,
      required this.myId,
      required this.index,
      required this.profile})
      : super(key: key);

  final int myId;
  final int index;
  final bool profile;
  final Size size;

  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  bool isDeleting = false;
  bool deleted = false;
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  late Post post;
  late bool isFollowed;
  late bool following;
  bool myPost = false;
  bool showIndex = true;
  bool prese = false;
  OverlayEntry? entry;
  bool reporting = false;
  UserProfial? account;
  int index2 = 0;
  getMyAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? userPref = prefs.getString('userData');
    final body = json.decode(userPref!);
    account = UserProfial.fromJson(body);
    setState(() {});
  }

  @override
  void initState() {
    post = widget.post;

    if (post.user['id'].toString() == widget.myId.toString()) {
      isFollowed = true;
    }

    post.user['avatar'] = post.user['avatar'].toString().startsWith('http')
        ? post.user['avatar']
        : image + post.user['avatar'];
    try {
      if (account!.id != post.userId) {
        CachedNetworkImage.evictFromCache(post.user['avatar']);
      }
      //
    } catch (e) {}

    isFollowed = widget.post.isFollowed;
    following = false;
    getMyAccount();
    _loadNPHTime();
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )
      ..addListener(() => controller.value = animation!.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          removeOverlay();
        }
      });
  }

  DateTime ntpTime = DateTime.now();

  _loadNPHTime() async {
    setState(() {
      // ntpTime = await NTP.now();
      //ntpTime = ntpTime.toUtc().toLocal();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.forward(from: 0);
  }

  removeOverlay() {
    entry!.remove();
    entry = null;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    setState(() {});
  }

  showOverlay(BuildContext context, String url) {
    final RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = MediaQuery.of(context).size;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        child: buildImage(url),
      ),
    );
    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);
  }

  showMore(CustomColors customColor) {
    if (post.userId.toString() == widget.myId.toString()) {
      myPost = true;
    } else {
      myPost = false;
    }
    showModalBottomSheet<dynamic>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        )),
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;
          return Container(
              decoration: BoxDecoration(
                  color: customColor.backgroundColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12))),
              child: DraggableScrollableSheet(
                  expand: false,
                  maxChildSize: .2,
                  initialChildSize: 0.2,
                  minChildSize: 0.2,
                  builder: (context, scrollController) => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //(!account!.admin ||
                          !myPost
                              ? !account!.admin
                                  ? SizedBox()
                                  : Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            prese = true;

                                            isDeleting = true;
                                          });
                                          if (prese) {
                                            Navigator.pop(context);
                                            final respons =
                                                await Server.deletePost(
                                                    post.postContId);
                                            if (respons) {
                                              isDeleting = false;
                                              post.delete = true;
                                              setState(() {});
                                            }
                                          }
                                          setState(() {
                                            prese = false;
                                          });
                                        },
                                        child: CircBotton(
                                          title: 'delete',
                                          child: Center(
                                            child: SvgPicture.string(
                                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Delete</title>
                                                      <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                              color: customColor.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        prese = true;

                                        isDeleting = true;
                                      });
                                      if (prese) {
                                        Navigator.pop(context);
                                        final respons = await Server.deletePost(
                                            post.postContId);
                                        if (respons) {
                                          isDeleting = false;
                                          post.delete = true;
                                          setState(() {});
                                        }
                                      }
                                      setState(() {
                                        prese = false;
                                      });
                                    },
                                    child: CircBotton(
                                      title: 'delete',
                                      child: Center(
                                        child: SvgPicture.string(
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                      <title>Iconly/Bold/Delete</title>
                                                      <g id="Iconly/Bold/Delete" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                          <g id="Delete" transform="translate(3.000000, 2.000000)" fill="#000000" fill-rule="nonzero">
                                                              <path d="M15.9390642,6.69713303 C16.1384374,6.69713303 16.3193322,6.78413216 16.4622974,6.93113069 C16.5955371,7.08812912 16.6626432,7.28312717 16.6431921,7.48912511 C16.6431921,7.55712443 16.1102334,14.297057 15.8058245,17.1340287 C15.6152042,18.8750112 14.4928788,19.9320007 12.8093905,19.9610004 C11.5149233,19.9900001 10.2496326,20 9.00379295,20 C7.68112168,20 6.38762697,19.9900001 5.13206181,19.9610004 C3.50498163,19.9220008 2.3816836,18.8460115 2.20078885,17.1340287 C1.88762697,14.2870571 1.36439378,7.55712443 1.35466825,7.48912511 C1.34494273,7.28312717 1.41107629,7.08812912 1.54528852,6.93113069 C1.67755565,6.78413216 1.86817592,6.69713303 2.06852172,6.69713303 L15.9390642,6.69713303 Z M11.0647288,-2.48689958e-14 C11.9487789,-2.48689958e-14 12.7384915,0.61699383 12.9670413,1.49698503 L12.9670413,1.49698503 L13.1304301,2.22697773 C13.2626972,2.82197178 13.77815,3.24296757 14.371407,3.24296757 L14.371407,3.24296757 L17.2871191,3.24296757 C17.67614,3.24296757 18,3.56596434 18,3.97696023 L18,3.97696023 L18,4.35695643 C18,4.75795242 17.67614,5.09094909 17.2871191,5.09094909 L17.2871191,5.09094909 L0.713853469,5.09094909 C0.323859952,5.09094909 1.95399252e-14,4.75795242 1.95399252e-14,4.35695643 L1.95399252e-14,4.35695643 L1.95399252e-14,3.97696023 C1.95399252e-14,3.56596434 0.323859952,3.24296757 0.713853469,3.24296757 L0.713853469,3.24296757 L3.62956559,3.24296757 C4.22185001,3.24296757 4.73730279,2.82197178 4.87054247,2.22797772 L4.87054247,2.22797772 L5.0232332,1.54598454 C5.26053598,0.61699383 6.04149557,-2.48689958e-14 6.93527123,-2.48689958e-14 L6.93527123,-2.48689958e-14 Z"></path>
                                                          </g>
                                                      </g>
                                                  </svg>''',
                                          color: customColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          //!myPost &&
                          1 == 1
                              ? SizedBox()
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        prese = true;
                                      });

                                      if (prese) {
                                        final textEdit =
                                            TextEditingController();
                                        Navigator.pop(context);
                                        EditCaption(textEdit,
                                            (vale) => setState(() {}));

                                        if (textEdit.text.isNotEmpty) {
                                          editCaption(textEdit.text);
                                        }
                                        setState(() {
                                          prese = false;
                                        });
                                      }
                                    },
                                    child: CircBotton(
                                      title: 'report',
                                      child: Center(
                                        child: SvgPicture.string(
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                                                        <title>Iconly/Bold/Danger</title>
                                                        <g id="Iconly/Bold/Danger" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                                            <g id="Danger" transform="translate(2.000000, 3.000000)" fill="#000000" fill-rule="nonzero">
                                                                <path d="M8.6279014,0.353093862 C9.98767226,-0.400979673 11.7173808,0.0944694301 12.4772527,1.44209099 L12.4772527,1.44209099 L19.7460279,14.057216 C19.9060009,14.4337574 19.9759891,14.7399449 19.9959857,15.0580232 C20.035979,15.8011969 19.7760228,16.5235617 19.2661087,17.0794556 C18.7561947,17.6333677 18.0663109,17.9603641 17.3164373,18 L17.3164373,18 L2.67890388,18 C2.36895611,17.9811729 2.05900834,17.9108192 1.7690572,17.8018204 C0.319301497,17.2171904 -0.380580564,15.5722994 0.20932003,14.1463969 L0.20932003,14.1463969 L7.52808673,1.43317291 C7.77804461,0.986277815 8.15798058,0.600818413 8.6279014,0.353093862 Z M9.99767057,12.2726084 C9.51775145,12.2726084 9.11781884,12.6689677 9.11781884,13.1455897 C9.11781884,13.6202299 9.51775145,14.0175801 9.99767057,14.0175801 C10.4775897,14.0175801 10.867524,13.6202299 10.867524,13.1346898 C10.867524,12.6600496 10.4775897,12.2726084 9.99767057,12.2726084 Z M9.99767057,6.09039447 C9.51775145,6.09039447 9.11781884,6.47585387 9.11781884,6.95247591 L9.11781884,6.95247591 L9.11781884,9.75572693 C9.11781884,10.2313581 9.51775145,10.6287083 9.99767057,10.6287083 C10.4775897,10.6287083 10.867524,10.2313581 10.867524,9.75572693 L10.867524,9.75572693 L10.867524,6.95247591 C10.867524,6.47585387 10.4775897,6.09039447 9.99767057,6.09039447 Z"></path>
                                                            </g>
                                                        </g>
                                                    </svg>''',
                                          color: customColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          myPost
                              ? SizedBox()
                              : Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        prese = true;
                                      });

                                      if (prese) {
                                        Navigator.pop(context);
                                        reporting = true;
                                        setState(() {});
                                        report().then((value) {
                                          reporting = false;
                                          setState(() {});
                                          !value
                                              ? null
                                              : showAboutDialog(
                                                  context: context);
                                        });
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content: Container(
                                                    //height: 50,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        color: customColor
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10.0),
                                                      child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            SizedBox(
                                                              child: SvgPicture
                                                                  .string(
                                                                '<?xml version="1.0" encoding="UTF-8"?> <svg xmlns="http://www.w3.org/2000/svg" id="Слой_1" data-name="Слой 1" viewBox="0 0 783 783"><path d="M911,170.5a362.21,362.21,0,1,1-141.48,28.55A361.31,361.31,0,0,1,911,170.5m0-28c-216.22,0-391.5,175.28-391.5,391.5S694.78,925.5,911,925.5,1302.5,750.22,1302.5,534,1127.22,142.5,911,142.5Z" transform="translate(-519.5 -142.5)"></path><path d="M651.5,487.5a363.14,363.14,0,0,1,34.75,16.12c11.35,5.91,22.43,12.3,33.34,19s21.61,13.63,32.17,20.8c5.29,3.57,10.49,7.25,15.71,10.92l7.75,5.6c2.59,1.86,5.18,3.73,7.72,5.64,20.48,15.16,40.38,31.05,59.83,47.44l14.48,12.42c4.8,4.18,9.55,8.4,14.31,12.63s9.44,8.54,14.14,12.86l7,6.52c2.35,2.22,4.6,4.35,7.06,6.74l-50.45,6.8,3.27-7.16c1-2.28,2.13-4.51,3.22-6.73,2.19-4.44,4.36-8.86,6.66-13.2s4.6-8.66,7-13,4.82-8.52,7.28-12.75Q891.62,592.86,908.8,569c11.5-15.87,23.72-31.27,36.77-46a528.87,528.87,0,0,1,41.74-42.18,429.2,429.2,0,0,1,47.08-36.94,342.92,342.92,0,0,1,52.66-29.4,259.29,259.29,0,0,1,57.55-18.23c4.94-.93,9.91-1.68,14.88-2.23s10-1,14.94-1.1c2.48-.1,5-.12,7.44-.13s5,.12,7.43.23A136.28,136.28,0,0,1,1204,394.5c-4.46,2.1-8.83,4.19-13.12,6.31l-3.2,1.6-3.16,1.65c-2.1,1.08-4.19,2.16-6.24,3.31q-12.36,6.76-23.84,14.2a437.23,437.23,0,0,0-43.34,32.19c-27.31,22.92-52.11,48.31-75.82,75q-17.76,20-34.66,41T967.35,612.2Q951,633.79,935.22,655.94q-4,5.52-7.86,11.09c-2.62,3.7-5.23,7.4-7.79,11.12s-5.16,7.42-7.66,11.14l-7.26,10.77-24.78,36.77-25.67-30L842.3,693l-12.16-14-12.25-14-12.29-14q-24.66-27.9-49.71-55.54c-16.74-18.4-33.61-36.73-50.9-54.75-8.64-9-17.33-18-26.25-26.88S660.77,496.28,651.5,487.5Z" transform="translate(-519.5 -142.5)"></path></svg>',
                                                                height: 50,
                                                                width: 50,
                                                                color: customColor
                                                                    .bottomDown,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            LocaleText(
                                                              'thax_report',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: customColor
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        .8),
                                                                //   fontFamily: 'SFPro',
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Divider(
                                                              height: 1,
                                                            ),
                                                            SizedBox(
                                                              height: 7,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    LocaleText(
                                                                  'close',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: customColor
                                                                        .primaryColor
                                                                        .withOpacity(
                                                                            .6),
                                                                    //   fontFamily: 'SFPro',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ]),
                                                    ),
                                                  ));
                                            });
                                        setState(() {
                                          prese = false;
                                        });
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 65,
                                          width: 65,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: customColor.iconTheme),
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          child: Icon(
                                            color: customColor.primaryColor,
                                            Icons.report,
                                            size: 30,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        LocaleText(
                                          'report',
                                          style: TextStyle(
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      )));
        });
  }

  Future<dynamic> EditCaption(
      TextEditingController textEdit, Function refresh) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      elevation: 2,
      builder: (context) {
        CustomColors customColors = CustomColors(context);

        return Edit(
          editCaption: (value) => editCaption(value),
          customColors: customColors,
          textEdit: textEdit,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    Color _color = widget.post.isLiked ? Colors.red : customColors.primaryColor;
    return post.delete
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: isDeleting
                ? LoadingGif(
                    logo: true,
                  )
                : Container(
                    //height: 360,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(12),
                        // gradient: LinearGradient(
                        //     begin: Alignment.topCenter,
                        //     end: Alignment.bottomCenter,
                        //     colors: [
                        //       customColors.backgroundColor,
                        //       ThemeMode == ThemeMode.dark ? Colors.black : Colors.white
                        //     ]),
                        ),
                    child: Column(
                      children: [
                        SizedBox(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: widget.size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfialPage(
                                                          myId: widget.myId,
                                                          id: int.parse(widget
                                                              .post.userId),
                                                          isMyProfile: false))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 13, vertical: 2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: CachedNetworkImage(
                                                  height: 35, width: 35,
                                                  // filterQuality: FilterQuality.low,
                                                  //cacheManager: customCachManager(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          SizedBox(),
                                                  key: UniqueKey(),
                                                  imageUrl: post.user["avatar"]
                                                          .toString()
                                                          .startsWith('http')
                                                      ? post.user["avatar"]
                                                      : image +
                                                          post.user["avatar"],
                                                  fit: BoxFit.cover,
                                                )),
                                            //  image2 +
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(post.user["name"],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: customColors
                                                          .primaryColor,
                                                    )),
                                                post.user["admin"] == '0'
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 4),
                                                        child: SvgPicture.string(
                                                            height: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    218,
                                                                    197,
                                                                    12),
                                                            '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>'''),
                                                      ),
                                              ],
                                            ),
                                            Text(
                                              post.user["username"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: customColors
                                                      .primaryColor),
                                            )
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            widget.profile
                                                ? SizedBox()
                                                : account == null
                                                    ? SizedBox()
                                                    : account!.id.toString() ==
                                                            post.userId
                                                                .toString()
                                                        ? SizedBox()
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              if (!following) {
                                                                //  following = true;
                                                                setState(() {});
                                                                if (isFollowed) {
                                                                  // final value =
                                                                  //     await UserModel.unFollow(
                                                                  //         widget.myId
                                                                  //             .toString(),
                                                                  //         post.userId
                                                                  //             .toString());
                                                                  // setState(() {
                                                                  //   isFollowed = value
                                                                  //       ? value
                                                                  //       : false;
                                                                  //   following = false;
                                                                  // });
                                                                } else {
                                                                  following =
                                                                      true;
                                                                  setState(
                                                                      () {});

                                                                  await UserModel.follow(
                                                                          widget
                                                                              .myId
                                                                              .toString(),
                                                                          post.userId
                                                                              .toString())
                                                                      .then(
                                                                          (value) {
                                                                    setState(
                                                                        () {
                                                                      if (value) {
                                                                        isFollowed =
                                                                            true;
                                                                      } else {}
                                                                      following =
                                                                          false;
                                                                    });
                                                                  });
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 30,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  color: isFollowed
                                                                      ? Colors
                                                                          .transparent
                                                                      : customColors
                                                                          .bottomDown),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0,
                                                                    vertical:
                                                                        2),
                                                                child: following
                                                                    ? SizedBox(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            30,
                                                                        child:
                                                                            LoadingGif(
                                                                          logo:
                                                                              false,
                                                                        ),
                                                                      )
                                                                    : isFollowed
                                                                        ? SizedBox()
                                                                        : LocaleText(
                                                                            'follow',
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'SFPro',
                                                                              fontSize: 15,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                              ),
                                                            ),
                                                          ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  showMore(customColors);
                                                },
                                                child: SizedBox(
                                                  child: Icon(
                                                    color: customColors
                                                        .primaryColor,
                                                    Icons.more_vert,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        /* widget.myId.toString() ==
                                    post.user["id"].toString()
                                ?*/

                                        //: SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onDoubleTap: () => like(widget.post.isLiked),
                              onTap: () => show(),
                              child: SizedBox(
                                height: 360,
                                child: Swiper(
                                  loop: false,
                                  onIndexChanged: (value) => setState(() {
                                    index2 = value;
                                  }),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 8.0),
                                      child: Stack(
                                        children: [
                                          post.postCont[index]["is_image"] ==
                                                      "1" ||
                                                  post.postCont[index]
                                                          ["is_image"] ==
                                                      1
                                              ? buildImage(post.postCont[index]
                                                  ["post_content"])
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      color: Color(int.parse(
                                                          post.postCont[index]
                                                              ["text_color"]))),
                                                  child: Center(
                                                      child: Text(
                                                          post.postCont[index]
                                                              ["post_content"],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color(
                                                                  int.parse(widget
                                                                          .post
                                                                          .postCont[index]
                                                                      [
                                                                      "post_color"])),
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'SFPro'))),
                                                ),
                                          (!showIndex)
                                              ? SizedBox()
                                              : post.postCont.length == 1
                                                  ? SizedBox()
                                                  : Positioned(
                                                      right: 15,
                                                      top: 15,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: const Color
                                                                      .fromARGB(
                                                                  166,
                                                                  0,
                                                                  0,
                                                                  0)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        5),
                                                            child: Text(
                                                              '${index + 1}/${post.postCont.length}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                            ),
                                                          )),
                                                    ),
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: post.postCont.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Row(
                                  // children: [
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      like(post.isLiked);
                                    }),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: SvgPicture.string(
                                        widget.post.isLiked
                                            ? '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                          <title>Iconly/Bold/Heart</title>
                          <g id="Iconly/Bold/Heart" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
      <g id="Heart" transform="translate(1.999783, 2.500540)" fill="#000000" fill-rule="nonzero">
          <path d="M6.28001656,3.46389584e-14 C6.91001656,0.0191596721 7.52001656,0.129159672 8.11101656,0.330159672 L8.11101656,0.330159672 L8.17001656,0.330159672 C8.21001656,0.349159672 8.24001656,0.370159672 8.26001656,0.389159672 C8.48101656,0.460159672 8.69001656,0.540159672 8.89001656,0.650159672 L8.89001656,0.650159672 L9.27001656,0.820159672 C9.42001656,0.900159672 9.60001656,1.04915967 9.70001656,1.11015967 C9.80001656,1.16915967 9.91001656,1.23015967 10.0000166,1.29915967 C11.1110166,0.450159672 12.4600166,-0.00984032788 13.8500166,3.46389584e-14 C14.4810166,3.46389584e-14 15.1110166,0.0891596721 15.7100166,0.290159672 C19.4010166,1.49015967 20.7310166,5.54015967 19.6200166,9.08015967 C18.9900166,10.8891597 17.9600166,12.5401597 16.6110166,13.8891597 C14.6800166,15.7591597 12.5610166,17.4191597 10.2800166,18.8491597 L10.2800166,18.8491597 L10.0300166,19.0001597 L9.77001656,18.8391597 C7.48101656,17.4191597 5.35001656,15.7591597 3.40101656,13.8791597 C2.06101656,12.5301597 1.03001656,10.8891597 0.390016562,9.08015967 C-0.739983438,5.54015967 0.590016562,1.49015967 4.32101656,0.269159672 C4.61101656,0.169159672 4.91001656,0.0991596721 5.21001656,0.0601596721 L5.21001656,0.0601596721 L5.33001656,0.0601596721 C5.61101656,0.0191596721 5.89001656,3.46389584e-14 6.17001656,3.46389584e-14 L6.17001656,3.46389584e-14 Z M15.1900166,3.16015967 C14.7800166,3.01915967 14.3300166,3.24015967 14.1800166,3.66015967 C14.0400166,4.08015967 14.2600166,4.54015967 14.6800166,4.68915967 C15.3210166,4.92915967 15.7500166,5.56015967 15.7500166,6.25915967 L15.7500166,6.25915967 L15.7500166,6.29015967 C15.7310166,6.51915967 15.8000166,6.74015967 15.9400166,6.91015967 C16.0800166,7.08015967 16.2900166,7.17915967 16.5100166,7.20015967 C16.9200166,7.18915967 17.2700166,6.86015967 17.3000166,6.43915967 L17.3000166,6.43915967 L17.3000166,6.32015967 C17.3300166,4.91915967 16.4810166,3.65015967 15.1900166,3.16015967 Z"></path>
      </g>
                          </g>
                      </svg>'''
                                            : '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light-Outline/Heart</title>
    <g id="Iconly/Light-Outline/Heart" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Heart" transform="translate(2.000000, 3.000000)" fill="#000000">
            <path d="M10.2347,1.039 C11.8607,0.011 14.0207,-0.273 15.8867,0.325 C19.9457,1.634 21.2057,6.059 20.0787,9.58 C18.3397,15.11 10.9127,19.235 10.5977,19.408 C10.4857,19.47 10.3617,19.501 10.2377,19.501 C10.1137,19.501 9.9907,19.471 9.8787,19.41 C9.5657,19.239 2.1927,15.175 0.3957,9.581 C0.3947,9.581 0.3947,9.58 0.3947,9.58 C-0.7333,6.058 0.5227,1.632 4.5777,0.325 C6.4817,-0.291 8.5567,-0.02 10.2347,1.039 Z M5.0377,1.753 C1.7567,2.811 0.9327,6.34 1.8237,9.123 C3.2257,13.485 8.7647,17.012 10.2367,17.885 C11.7137,17.003 17.2927,13.437 18.6497,9.127 C19.5407,6.341 18.7137,2.812 15.4277,1.753 C13.8357,1.242 11.9787,1.553 10.6967,2.545 C10.4287,2.751 10.0567,2.755 9.7867,2.551 C8.4287,1.53 6.6547,1.231 5.0377,1.753 Z M14.4677,3.7389 C15.8307,4.1799 16.7857,5.3869 16.9027,6.8139 C16.9357,7.2269 16.6287,7.5889 16.2157,7.6219 C16.1947,7.6239 16.1747,7.6249 16.1537,7.6249 C15.7667,7.6249 15.4387,7.3279 15.4067,6.9359 C15.3407,6.1139 14.7907,5.4199 14.0077,5.1669 C13.6127,5.0389 13.3967,4.6159 13.5237,4.2229 C13.6527,3.8289 14.0717,3.6149 14.4677,3.7389 Z" id="Combined-Shape"></path>
        </g>
    </g>
</svg>''',
                                        color: _color,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                    body: new PostCommentsPage(
                                                        myId: widget.myId,
                                                        pageId: int.parse(
                                                            widget.post.id),
                                                        isPost: false),
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(context
                                                    .currentLocale!
                                                    .languageCode ==
                                                "ar"
                                            ? math.pi
                                            : math.pi * 2),
                                        child: SvgPicture.string(
                                          '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                    <title>Iconly/Light-Outline/Chat</title>
                    <g id="Iconly/Light-Outline/Chat" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                        <g id="Chat" transform="translate(1.000000, 1.000000)" fill="#000000">
                            <path d="M10.7484,0.0003 C13.6214,0.0003 16.3214,1.1173 18.3494,3.1463 C22.5414,7.3383 22.5414,14.1583 18.3494,18.3503 C16.2944,20.4063 13.5274,21.4943 10.7244,21.4943 C9.1964,21.4943 7.6584,21.1713 6.2194,20.5053 C5.7954,20.3353 5.3984,20.1753 5.1134,20.1753 C4.7854,20.1773 4.3444,20.3293 3.9184,20.4763 C3.0444,20.7763 1.9564,21.1503 1.1514,20.3483 C0.3494,19.5453 0.7194,18.4603 1.0174,17.5873 C1.1644,17.1573 1.3154,16.7133 1.3154,16.3773 C1.3154,16.1013 1.1824,15.7493 0.9784,15.2423 C-0.8946,11.1973 -0.0286,6.3223 3.1484,3.1473 C5.1764,1.1183 7.8754,0.0003 10.7484,0.0003 Z M10.7494,1.5003 C8.2764,1.5003 5.9534,2.4623 4.2084,4.2083 C1.4744,6.9403 0.7304,11.1353 2.3554,14.6483 C2.5894,15.2273 2.8154,15.7913 2.8154,16.3773 C2.8154,16.9623 2.6144,17.5513 2.4374,18.0713 C2.2914,18.4993 2.0704,19.1453 2.2124,19.2873 C2.3514,19.4313 3.0014,19.2043 3.4304,19.0573 C3.9454,18.8813 4.5294,18.6793 5.1084,18.6753 C5.6884,18.6753 6.2354,18.8953 6.8144,19.1283 C10.3614,20.7683 14.5564,20.0223 17.2894,17.2903 C20.8954,13.6823 20.8954,7.8133 17.2894,4.2073 C15.5434,2.4613 13.2214,1.5003 10.7494,1.5003 Z M14.6963,10.163 C15.2483,10.163 15.6963,10.61 15.6963,11.163 C15.6963,11.716 15.2483,12.163 14.6963,12.163 C14.1443,12.163 13.6923,11.716 13.6923,11.163 C13.6923,10.61 14.1353,10.163 14.6873,10.163 L14.6963,10.163 Z M10.6875,10.163 C11.2395,10.163 11.6875,10.61 11.6875,11.163 C11.6875,11.716 11.2395,12.163 10.6875,12.163 C10.1355,12.163 9.6835,11.716 9.6835,11.163 C9.6835,10.61 10.1255,10.163 10.6785,10.163 L10.6875,10.163 Z M6.6783,10.163 C7.2303,10.163 7.6783,10.61 7.6783,11.163 C7.6783,11.716 7.2303,12.163 6.6783,12.163 C6.1263,12.163 5.6743,11.716 5.6743,11.163 C5.6743,10.61 6.1173,10.163 6.6693,10.163 L6.6783,10.163 Z" id="Combined-Shape"></path>
                        </g>
                    </g>
                </svg>''',
                                          color: customColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  ...List.generate(
                                      widget.post.postCont.length,
                                      (index) => widget.post.postCont.length < 2
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  right: context.currentLocale!
                                                              .languageCode ==
                                                          'en'
                                                      ? 4.0
                                                      : 0,
                                                  left: context.currentLocale!
                                                              .languageCode ==
                                                          'en'
                                                      ? 0
                                                      : 4.0),
                                              child: DotIndicator(
                                                isActive: index == index2,
                                              ),
                                            )),
                                  SizedBox(
                                    width: 10,
                                  )
                                  /* Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ImageIcon(
                  const AssetImage(
                      'images/Light/Send.png'),
                  color: customColors.primaryColor,
                ),
              )
            ],
          ),*/
                                  /* Expanded(child: Container()),
          (ImageIcon(
            const AssetImage(
                'images/Light/Wallet.png'),
            color: customColors.primaryColor,
          ))*/
                                ],
                              ),
                            )
                          ],
                        )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              post.likes < 2
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      child: Row(
                                        children: [
                                          Text(
                                            // 'Liked by ${post.likedBy} and others',
                                            "${post.likes} ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold,
                                              color: customColors.primaryColor,
                                            ),
                                          ),
                                          Text(
                                            // 'Liked by ${post.likedBy} and others',
                                            "${context.localeString('likes')}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold,
                                              color: customColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              post.caption.isEmpty
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ReadMoreText(
                                              lessStyle: TextStyle(
                                                  color:
                                                      customColors.bottomDown,
                                                  fontSize: 14),
                                              '${post.user["username"]} ${post.caption}',
                                              moreStyle: TextStyle(
                                                  color:
                                                      customColors.bottomDown,
                                                  fontSize: 14),
                                              trimLines: 1,
                                              trimCollapsedText: context
                                                  .localeString('read_more'),
                                              trimExpandedText: context
                                                  .localeString('show_less'),
                                              postDataText: '',
                                              preDataText: '',
                                              trimMode: TrimMode.Line,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 14,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                overflow: TextOverflow.ellipsis,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    customColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              post.commentsCount < 1
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                      body:
                                                          new PostCommentsPage(
                                                              myId: widget.myId,
                                                              pageId: int.parse(
                                                                  post.id),
                                                              isPost: false),
                                                    )));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1),
                                        child: Text(
                                          '${context.localeString('viewall')} ${post.commentsCount} ${context.localeString('comments')}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            textBaseline:
                                                TextBaseline.alphabetic,
                                            fontFamily: 'SFPro',
                                            fontWeight: FontWeight.bold,
                                            color: customColors.primaryColor
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ),
                                    ),
                              /* Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5),
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
                          color: customColors.primaryColor,
                        ),
                      ),
                    ]),
                  ),*/
                              Row(
                                children: [
                                  Text(
                                    Jiffy(DateTime.parse(post.postTime))
                                        .from((DateTime.parse(post.date))),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 10,
                                      textBaseline: TextBaseline.alphabetic,
                                      fontFamily: 'SFPro',
                                      fontWeight: FontWeight.w100,
                                      color: customColors.primaryColor
                                          .withOpacity(.7),
                                    ),
                                  ),
                                  /*Text(
                        ' . See translation',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: customColors.primaryColor,
                        ),
                      ),*/
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
  }

  addLike() async {
    setState(() {
      post.likes -= 1;
    });
    final response = await http.get(
        Uri.parse("$post_unlike?user_id=${widget.myId}&post_id=${post.id}"));
    var data = jsonDecode(response.body);
    print(data);
  }

  Future report() async {
    var response = await http
        .get(
            Uri.parse("$report_post?user_id=${widget.myId}&post_id=${post.id}"))
        .catchError((e) {
      return Response("body", 400);
    });
    var data;
    try {
      data = jsonDecode(response.body);
    } catch (e) {
      return false;
    }
    if (data['status'] == "success") {
      return true;
    }
  }

  editCaption(String caption) async {
    final response = await http
        .get(Uri.parse("$editCaptionLinke?caption=$caption&post_id=${post.id}"))
        .catchError((e) {})
        .then((value) {
      var data = jsonDecode(value.body);
      if (data != null) {
        return true;
      } else
        return false;
    });
  }

  unLike() async {
    setState(() {
      post.likes += 1;
    });
    final response = await http.get(Uri.parse(
        "$post_like?user_id=${widget.myId}&post_id=${post.id}&post_user=${post.userId}"));
    print(response.body);
    var data = jsonDecode(response.body);

    print(data);
  }

  // deletePost() async {
  //   setState(() {
  //     isDeletting = true;
  //   });

  //   final response = await http
  //       .get(Uri.parse("$deletePostUrl?post_id=${post.postContId}"));
  //   //var data = jsonDecode(response.body);
  //   setState(() {
  //     posts.removeAt(0);
  //   });
  //   setState(() {
  //     isDeletting = false;
  //   });
  //   // print(data);
  // }
  show() {
    if (showIndex) {
      showIndex = false;

      setState(() {});
    } else {
      showIndex = true;

      setState(() {});
    }
  }

  like(bool isLiked) {
    if (post.isLiked) {
      post.isLiked = false;
      addLike();
      setState(() {});
      print(isLiked);
    } else {
      post.isLiked = true;
      unLike();

      setState(() {});
      print(post.isLiked);
    }
    setState(() {});
  }

  Widget buildImage(String url) {
    return Builder(builder: (context) {
      CustomColors customColors = CustomColors(context);
      return InteractiveViewer(
        onInteractionEnd: (details) => resetAnimation(),
        onInteractionStart: (details) {
          if (details.pointerCount < 2) return;
          showOverlay(context, url);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          setState(() {});
        },
        transformationController: controller,
        maxScale: 4,
        minScale: 1,
        clipBehavior: Clip.none,
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  // filterQuality: FilterQuality.low,
                  //cacheManager: customCachManager(),
                  placeholder: (context, url) => Center(
                      child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: customColors.primaryColor),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  )),
                  errorWidget: (context, url, error) =>
                      AlartInternet(onTap: () => setState(() {})),
                  key: UniqueKey(),
                  imageUrl: image + url,
                  fit: BoxFit.cover,
                )),
          ),
        ),
      );
    });
  }
}

class Edit extends StatefulWidget {
  const Edit({
    Key? key,
    required this.customColors,
    required this.textEdit,
    required this.editCaption,
  }) : super(key: key);

  final CustomColors customColors;
  final TextEditingController textEdit;
  final Function editCaption;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  bool sending = false;
  sendCallBack() {}
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: widget.customColors.backgroundColor.withOpacity(.8),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        enabled: !PostCommentsPageState.sending,

                        maxLines: 5,
                        onChanged: (value) {
                          setState(() {});
                          ;
                        },
                        onEditingComplete:
                            (widget.textEdit.text.isEmpty && !sending)
                                ? () {
                                    null;
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }
                                : widget.editCaption(widget.textEdit.text),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: context.localeString('edit') +
                              " " +
                              context.localeString('caption'),
                          hintStyle: TextStyle(
                            fontFamily: 'SFPro',
                            color: widget.customColors.primaryColor
                                .withOpacity(0.6),
                          ),
                        ),
                        minLines: 1,

                        // expands: true,
                        textAlignVertical: TextAlignVertical.center,

                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        controller: widget.textEdit,
                        maxLength: widget.textEdit.text.isEmpty ? null : 150,

                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                    ),
                  ),
                  sending
                      ? LoadingGif(
                          logo: false,
                        )
                      : GestureDetector(
                          onTap: (widget.textEdit.text.isEmpty && !sending)
                              ? () {
                                  null;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              : widget.editCaption(widget.textEdit.text),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: PostCommentsPageState.sending
                                    ? LoadingGif(
                                        logo: false,
                                      )
                                    : Icon(
                                        Icons.send_rounded,
                                        color: widget.customColors.primaryColor
                                            .withOpacity(.9),
                                        textDirection: context.currentLocale!
                                                    .languageCode ==
                                                'ar'
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                        size: 35,
                                      ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
