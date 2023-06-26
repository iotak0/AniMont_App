import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:flutter/material.dart';

class MoreItems extends StatelessWidget {
  const MoreItems({
    Key? key,
    required this.children,
  }) : super(key: key);
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return Container(
        decoration: BoxDecoration(
            color: customColor.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        child: DraggableScrollableSheet(
            expand: false,
            maxChildSize: .2,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            builder: (context, scrollController) => Center(
                  child: SingleChildScrollView(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: children),
                  ),
                )));
  }
}
