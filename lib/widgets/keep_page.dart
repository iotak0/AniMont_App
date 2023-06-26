import 'package:flutter/material.dart';

class KeepPage extends StatefulWidget {
  const KeepPage({super.key, required this.child});
  final Widget child;
  @override
  State<KeepPage> createState() => _KeepPageState();
}

class _KeepPageState extends State<KeepPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.widget.child;
    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
