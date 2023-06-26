import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:shimmer/shimmer.dart';
import '../../provider/user_model.dart';
import 'avatar.dart';
import 'follow_sec.dart';
import 'name_sec.dart';

class ProfileAppBar extends StatefulWidget {
  const ProfileAppBar({
    Key? key,
    required this.profail,
    required this.myId,
    required this.myProfile,
    required this.account,
  }) : super(key: key);

  final UserProfial profail;
  final UserProfial account;

  final String myId;
  final bool myProfile;

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  @override
  void initState() {
    widget.profail.avatar = widget.profail.avatar.toString().startsWith('http')
        ? widget.profail.avatar
        : image + widget.profail.avatar;
    if (!widget.myProfile) {
      CachedNetworkImage.evictFromCache(widget.profail.avatar);
      CachedNetworkImage.evictFromCache(image + widget.profail.backGroung);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Stack(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                child: CachedNetworkImage(
                  height: 150,
                  width: double.infinity,
                  key: UniqueKey(),
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: customColors.iconTheme,
                    highlightColor: customColors.bottomDown,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: customColors.iconTheme,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12))),
                    ),
                  ),
                  errorWidget: (context, url, error) => GestureDetector(
                    onTap: () => setState(() {}),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          color: customColors.iconTheme,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12))),
                    ),
                  ),
                  imageUrl: image + widget.profail.backGroung,
                  fit: BoxFit.cover,
                )),
            Positioned(
              bottom: -50,
              height: 110,
              width: 110,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: customColors.backgroundColor),
                      borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),

                      //clipBehavior:

                      child: GestureDetector(
                        onTap: () {},
                        child: CachedNetworkImage(
                          //height: 50,
                          //width: double.infinity,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: customColors.iconTheme,
                            highlightColor: customColors.bottomDown,
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                  color: customColors.iconTheme,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),

                          key: UniqueKey(),
                          errorWidget: (context, url, error) => GestureDetector(
                            onTap: () => setState(() {}),
                            child: Container(
                              height: 110,
                              decoration: BoxDecoration(
                                  color: customColors.iconTheme,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          imageUrl: widget.profail.avatar,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              ),
            ),
          ],
        ),

        NameSec(
          account: widget.account,
          profail: widget.profail,
          myId: int.parse(widget.myId),
        ),

        // Avatar(
        //     profail: widget.profail,
        //     isEn: context.currentLocale.toString() == 'en' ? true : false),
        // Padding(
        //   padding: const EdgeInsets.only(top: 5.0),
        //   child: ArrowBackButton(
        //     size: MediaQuery.of(context).size,
        //   ),
        // )
      ],
    );
  }
}
