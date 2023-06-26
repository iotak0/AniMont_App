import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:anime_mont_test/widgets/post_comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class AddCommentPost extends StatefulWidget {
  const AddCommentPost({
    Key? key,
    required this.myController,
    required this.customColors,
    required this.sendCallBack,
    required this.showEmoji,
  }) : super(key: key);

  final TextEditingController myController;
  final GestureTapCallback sendCallBack;
  final GestureTapCallback showEmoji;
  final CustomColors customColors;

  @override
  State<AddCommentPost> createState() => _AddCommentPostState();
}

class _AddCommentPostState extends State<AddCommentPost> {
  @override
  Widget build(BuildContext context) {
    CustomColors customColors = CustomColors(context);
    return Container(
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          // border: Border.all(width: 1),
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            (!PostCommentsPageState.reply)
                ? SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(PostCommentsPageState.reply
                              ? context.localeString('reply_to') +
                                  PostCommentsPageState
                                      .comments[PostCommentsPageState.select]
                                      .account
                                      .userName
                                      .toLowerCase()
                              : PostCommentsPageState.edit
                                  ? context.localeString('edit')
                                  : ''),
                        ),
                        // || !PostCommentsPageState.edit
                        GestureDetector(
                          onTap: () {
                            PostCommentsPageState.edit = false;
                            PostCommentsPageState.reply = false;
                            PostCommentsPageState.select = 0;
                            setState(() {});
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SvgPicture.string(
                              '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                            <title>Iconly/Bold/Close Square</title>
                            <g id="Iconly/Bold/Close-Square" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd">
                                <g id="Close-Square" transform="translate(1.999800, 1.999200)" fill="#000000" fill-rule="nonzero">
                                    <path d="M14.34,2.84217094e-14 C17.73,2.84217094e-14 20,2.38 20,5.92 L20,5.92 L20,14.091 C20,17.621 17.73,20 14.34,20 L14.34,20 L5.67,20 C2.28,20 0,17.621 0,14.091 L0,14.091 L0,5.92 C0,2.38 2.28,2.84217094e-14 5.67,2.84217094e-14 L5.67,2.84217094e-14 Z M13.01,6.971 C12.67,6.63 12.12,6.63 11.77,6.971 L11.77,6.971 L10,8.75 L8.22,6.971 C7.87,6.63 7.32,6.63 6.98,6.971 C6.64,7.311 6.64,7.871 6.98,8.21 L6.98,8.21 L8.76,9.991 L6.98,11.761 C6.64,12.111 6.64,12.661 6.98,13 C7.15,13.17 7.38,13.261 7.6,13.261 C7.83,13.261 8.05,13.17 8.22,13 L8.22,13 L10,11.231 L11.78,13 C11.95,13.181 12.17,13.261 12.39,13.261 C12.62,13.261 12.84,13.17 13.01,13 C13.35,12.661 13.35,12.111 13.01,11.771 L13.01,11.771 L11.23,9.991 L13.01,8.21 C13.35,7.871 13.35,7.311 13.01,6.971 Z"></path>
                                </g>
                            </g>
                        </svg>''',
                              color: customColors.primaryColor.withOpacity(.7),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: GestureDetector(
                                onTap: widget.showEmoji,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Card(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      child: Center(
                                          child: Icon(
                                        Icons.emoji_emotions_outlined,
                                        color: customColors.primaryColor,
                                      ))),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  enabled: !PostCommentsPageState.sending,
                                  // autofocus: true,
                                  maxLines: 5,
                                  onChanged: (value) => setState(() {}),
                                  onEditingComplete: widget
                                              .myController.text.length >
                                          150
                                      ? () => null
                                      : (widget.myController.text.isEmpty ||
                                              PostCommentsPageState.sending)
                                          ? () {
                                              null;
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                            }
                                          : widget.sendCallBack,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        context.localeString('add_a_comment'),
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
                                  controller: widget.myController,
                                  maxLength: widget.myController.text.isEmpty
                                      ? null
                                      : 150,

                                  maxLengthEnforcement:
                                      MaxLengthEnforcement.enforced,
                                ),
                              ),
                            ),
                            widget.myController.text.isEmpty
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: GestureDetector(
                                      onTap: () => setState(() {
                                        PostCommentsPageState.isFire =
                                            PostCommentsPageState.isFire
                                                ? false
                                                : true;
                                      }),
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: Card(
                                            color: PostCommentsPageState.isFire
                                                ? Colors.yellow
                                                : Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Center(
                                                child: Text(
                                              '🔥',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ))),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.myController.text.length > 150
                          ? () => null
                          : (widget.myController.text.isEmpty &&
                                  PostCommentsPageState.sending)
                              ? () {
                                  null;
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                }
                              : widget.sendCallBack,
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
                                    color: customColors.primaryColor
                                        .withOpacity(.9),
                                    textDirection:
                                        context.currentLocale!.languageCode ==
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
