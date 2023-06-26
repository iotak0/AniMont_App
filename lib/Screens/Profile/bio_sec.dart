import 'package:anime_mont_test/Screens/Profile/following.dart';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/Profile/shortcut.dart';
import 'package:anime_mont_test/Screens/Profile/followers.dart';
import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:jiffy/jiffy.dart';
import 'package:readmore/readmore.dart';

class BioSec extends StatefulWidget {
  const BioSec({
    Key? key,
    required this.profile,
    required this.myId,
  }) : super(key: key);

  final UserProfial profile;
  final String myId;

  @override
  State<BioSec> createState() => BioSecState(true, false);
}

class BioSecState extends State<BioSec> {
  late UserProfial profile;
  late int follower;

  BioSecState(bool plus, bool doing) {
    if (doing) {
      profile = widget.profile;
      int follower = profile.followers;
      if (plus && doing) {
        profile.followers = follower++;
        setState(() {});
      }
      if (!plus && doing) {
        profile.followers = follower--;
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    print(profile.toString());
    return Column(children: [
      profile.bio.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                alignment: context.currentLocale.toString() == "en"
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: ReadMoreText(
                  lessStyle:
                      TextStyle(color: customColor.bottomDown, fontSize: 14),
                  profile.bio,
                  moreStyle:
                      TextStyle(color: customColor.bottomDown, fontSize: 14),
                  trimLines: 1,
                  trimCollapsedText: context.localeString('read_more'),
                  trimExpandedText: context.localeString('show_less'),
                  postDataText: '',
                  preDataText: '',
                  trimMode: TrimMode.Line,
                  style: TextStyle(
                      color: customColor.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: context.localeString('en') == 'en'
                          ? 'Angie'
                          : 'SFPro'),
                ),
              ),
            )
          : SizedBox(),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
            width: double.infinity,
            child: Row(
              //

              children: [
                Wrap(
                  spacing: 0,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    profile.country.isEmpty
                        ? SizedBox()
                        : Shortcut(
                            height: 20.0,
                            icon:
                                '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                  <title>Iconly/Light-Outline/Location</title>
                  <g id="Iconly/Light-Outline/Location" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                      <g id="Location" transform="translate(4.000000, 1.000000)" fill="#000000">
                  <path d="M8.2495,1 C12.7985,1 16.4995,4.729 16.4995,9.313 C16.4995,14.948 10.0435,20.5 8.2495,20.5 C6.4555,20.5 -0.0005,14.948 -0.0005,9.313 C-0.0005,4.729 3.7005,1 8.2495,1 Z M8.2495,2.5 C4.5275,2.5 1.4995,5.557 1.4995,9.313 C1.4995,14.092 7.1235,18.748 8.2495,18.996 C9.3755,18.747 14.9995,14.091 14.9995,9.313 C14.9995,5.557 11.9715,2.5 8.2495,2.5 Z M8.2505,6 C10.0425,6 11.5005,7.458 11.5005,9.251 C11.5005,11.043 10.0425,12.5 8.2505,12.5 C6.4585,12.5 5.0005,11.043 5.0005,9.251 C5.0005,7.458 6.4585,6 8.2505,6 Z M8.2505,7.5 C7.2855,7.5 6.5005,8.285 6.5005,9.251 C6.5005,10.216 7.2855,11 8.2505,11 C9.2155,11 10.0005,10.216 10.0005,9.251 C10.0005,8.285 9.2155,7.5 8.2505,7.5 Z" id="Combined-Shape"></path>
                      </g>
                  </g>
              </svg>''',
                            text: profile.country),
                    Shortcut(
                        height: 15.0,
                        icon:
                            '''<svg width="24px" height="24px" version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 122.88 122.88" style="enable-background:new 0 0 122.88 122.88" xml:space="preserve"><g><path d="M81.61,4.73c0-2.61,2.58-4.73,5.77-4.73c3.19,0,5.77,2.12,5.77,4.73v20.72c0,2.61-2.58,4.73-5.77,4.73 c-3.19,0-5.77-2.12-5.77-4.73V4.73L81.61,4.73z M66.11,103.81c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,103.81z M15.85,67.09c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,67.09z M40.98,67.09 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,67.09z M66.11,67.09c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9c0.34,0,0.61,1.43,0.61,3.2 c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,67.09z M91.25,67.09c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H91.25L91.25,67.09z M15.85,85.45c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,85.45z M40.98,85.45 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,85.45z M66.11,85.45c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2H81.9c0.34,0,0.61,1.43,0.61,3.2 c0,1.77-0.27,3.2-0.61,3.2H66.11L66.11,85.45z M91.25,85.45c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79 c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H91.25L91.25,85.45z M15.85,103.81c-0.34,0-0.61-1.43-0.61-3.2 c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H15.85L15.85,103.81z M40.98,103.81 c-0.34,0-0.61-1.43-0.61-3.2c0-1.77,0.27-3.2,0.61-3.2h15.79c0.34,0,0.61,1.43,0.61,3.2c0,1.77-0.27,3.2-0.61,3.2H40.98 L40.98,103.81z M29.61,4.73c0-2.61,2.58-4.73,5.77-4.73s5.77,2.12,5.77,4.73v20.72c0,2.61-2.58,4.73-5.77,4.73 s-5.77-2.12-5.77-4.73V4.73L29.61,4.73z M6.4,45.32h110.07V21.47c0-0.8-0.33-1.53-0.86-2.07c-0.53-0.53-1.26-0.86-2.07-0.86H103 c-1.77,0-3.2-1.43-3.2-3.2c0-1.77,1.43-3.2,3.2-3.2h10.55c2.57,0,4.9,1.05,6.59,2.74c1.69,1.69,2.74,4.02,2.74,6.59v27.06v65.03 c0,2.57-1.05,4.9-2.74,6.59c-1.69,1.69-4.02,2.74-6.59,2.74H9.33c-2.57,0-4.9-1.05-6.59-2.74C1.05,118.45,0,116.12,0,113.55V48.52 V21.47c0-2.57,1.05-4.9,2.74-6.59c1.69-1.69,4.02-2.74,6.59-2.74H20.6c1.77,0,3.2,1.43,3.2,3.2c0,1.77-1.43,3.2-3.2,3.2H9.33 c-0.8,0-1.53,0.33-2.07,0.86c-0.53,0.53-0.86,1.26-0.86,2.07V45.32L6.4,45.32z M116.48,51.73H6.4v61.82c0,0.8,0.33,1.53,0.86,2.07 c0.53,0.53,1.26,0.86,2.07,0.86h104.22c0.8,0,1.53-0.33,2.07-0.86c0.53-0.53,0.86-1.26,0.86-2.07V51.73L116.48,51.73z M50.43,18.54 c-1.77,0-3.2-1.43-3.2-3.2c0-1.77,1.43-3.2,3.2-3.2h21.49c1.77,0,3.2,1.43,3.2,3.2c0,1.77-1.43,3.2-3.2,3.2H50.43L50.43,18.54z"/></g></svg>''',
                        text: Jiffy(DateTime.parse(profile.birthday))
                            .MMMd
                            .toString()),
                  ],
                ),
              ],
            )),
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
              // width: double.infinity,
              child: Row(children: [
            GestureDetector(
              onTap: () {
                //Followers
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Followings(myId: profile.id)));
              },
              child: Text(
                '${context.localeString('following')} ${profile.following}',
                style: TextStyle(
                    color: customColor.primaryColor.withAlpha(230),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    fontFamily: 'SFPro'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                //Followers
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Followers(myId: profile.id)));
              },
              child: Text(
                '${context.localeString('followers')} ${profile.followers}',
                style: TextStyle(
                    color: customColor.primaryColor.withAlpha(230),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    fontFamily:
                        context.localeString('en') == 'en' ? 'Angie' : 'SFPro'),
              ),
            )
          ]))),
      //CustAppBarTital(tital: "followedby"),
      widget.myId != profile.id
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: double.infinity,
                child: Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    alignment: WrapAlignment.start,
                    children: List.generate(
                        profile.matual.length > 3 ? 3 : profile.matual.length,
                        (index) {
                      profile.matual[index].avatar = profile
                              .matual[index].avatar
                              .toString()
                              .startsWith('http')
                          ? profile.matual[index].avatar
                          : image + profile.matual[index].avatar;
                      try {
                        //if(widget.)
                        CachedNetworkImage.evictFromCache(
                            profile.matual[index].avatar);
                      } catch (e) {}
                      final matual = profile.matual[index];
                      if (index == 3) {
                        Text(
                          context.localeString('more'),
                          style: TextStyle(
                              color: customColor.primaryColor.withAlpha(230),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              fontFamily: context.localeString('en') == 'en'
                                  ? 'Angie'
                                  : 'SFPro'),
                        );
                      }
                      if (index == 0) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.localeString('followedby') + ":",
                              style: TextStyle(
                                  color:
                                      customColor.primaryColor.withAlpha(230),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  fontFamily: context.localeString('en') == 'en'
                                      ? 'Angie'
                                      : 'SFPro'),
                            ),
                            widget.myId == matual.id
                                ? SizedBox()
                                : FollowedBy(
                                    matual: matual,
                                    MyId: int.parse(widget.myId),
                                  )
                          ],
                        );
                      } else {
                        return widget.myId == matual.id
                            ? SizedBox()
                            : FollowedBy(
                                matual: matual,
                                MyId: int.parse(widget.myId),
                              );
                      }
                    })),
              ))
          : Container(),
      //MyBannerAd(),

      // Titel(size: size, title: "Favorite"),
      // AnimeScrollView2(size: size),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "")),
      // // Category(
      // //     list: anime.animeCategory, isLink: true, color: widget.color),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "Info")),
      // // Category(
      // //     list: anime.animeInfo, isLink: false, color: widget.color),
      // SliverToBoxAdapter(
      //     child: Titel(size: widget.size, title: "Episodes")),
    ]);
  }
}

class FollowedBy extends StatelessWidget {
  const FollowedBy({
    Key? key,
    required this.matual,
    required this.MyId,
  }) : super(key: key);
  final int MyId;
  final Matual matual;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfialPage(
                            myId: MyId,
                            id: int.parse(matual.id),
                            isMyProfile: false))),
                child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        matual.avatar.startsWith("http")
                            ? matual.avatar
                            : image2 + matual.avatar)),
              )),
          Text(matual.name)
        ]),
      ),
    );
  }
}

/*showModalBottomSheet<dynamic>(
                  //      backgroundColor: ,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  )),
                  context: context,
                  builder: (context) {
                   
                    Size size = MediaQuery.of(context).size;
                    return 1 == 1
                        //allEp.isNotEmpty
                        ? Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      // widget.color[1],
                                      iconTheme,
                                      iconTheme,
                                      backgroundColor,
                                    ]),
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30))),
                            child: DraggableScrollableSheet(
                                expand: false,
                                maxChildSize: 0.95,
                                initialChildSize: 0.7,
                                minChildSize: 0.3,
                                builder: (context, scrollController) => Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.topCenter,
                                      children: [
                                        Positioned(
                                          top: 10,
                                          child: Container(
                                              height: 8,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.horizontal(
                                                          right:
                                                              Radius.circular(
                                                                  30),
                                                          left: Radius.circular(
                                                              30)))),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Column(
                                                  children: List.generate(
                                                1,
                                                (index) =>GestureDetector(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                        height: 80,
                                                        child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                  radius: 30,
                                                                  // backgroundColor: widget.color[1],
                                                                  child: Text(
                                                                    '',
                                                                  )
                                                                  //   allEp[index].numb,
                                                                  //   style: TextStyle(color: widget.color[0], fontWeight: FontWeight.bold, fontFamily: Locales.currentLocale(context).toString() == 'en' ? 'Angie' : 'SFPro', fontSize: 25),
                                                                  // ),
                                                                  ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: size
                                                                              .width -
                                                                          100,
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        //allEp[index].name,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 'Angie'
                                                                                : 'SFPro',
                                                                            color:
                                                                                primaryColor,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: 15.5),
                                                                      ),
                                                                    ),
                                                                    Text(''),
                                                                    Container(
                                                                      width: size
                                                                              .width -
                                                                          100,
                                                                      child:
                                                                          Text(
                                                                        '',
                                                                        //allEp[index].sub,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily: Locales.currentLocale(context).toString() == 'en'
                                                                                ? 'Angie'
                                                                                : 'SFPro',
                                                                            color:
                                                                                primaryColor,
                                                                            fontSize:
                                                                                12.5),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ]),
                                                      ),
                                                    ),
                                                  )
                                                
                                              ))),
                                        ),
                                      ],
                                    )),
                          )

                        // } else {
                        //   return Container();
                        //   //     Padding(
                        //   //   padding:
                        //   //       const EdgeInsets.symmetric(vertical: 15),
                        //   //   child:
                        //   //       Center(child: const CircularProgressIndicator()),
                        //   // );
                        // }

                        : Container(
                            height: size.height,
                            width: size.width,
                            color: Colors.transparent,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                  },);*/
