import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';

showMore(CustomColors customColor, BuildContext context, Widget child) {
  showModalBottomSheet<dynamic>(
      // backgroundColor: widget.color[1],
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(15),
      )),
      context: context,
      builder: (context) {
        return child;
      });
}
