import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool isEmpty = true;
  final TextEditingController _myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: widget.size.height / 15,
        child: Row(
          children: [
            Expanded(
                child: Container(
              height: widget.size.height / 15,
              decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [Colors.black, Colors.grey]),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 12),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                      child: TextField(
                    textInputAction: TextInputAction.search,
                    controller: _myController,
                    decoration: InputDecoration(
                      hintText: 'Search Anime & Movie',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ))
                ],
              ),
            )),
            Container(
                margin: const EdgeInsets.only(left: 16),
                width: widget.size.height / 15,
                height: widget.size.height / 15,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.black, Colors.grey]),
                    borderRadius: BorderRadius.circular(14)),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_myController.text.isEmpty) {
                        isEmpty == false;
                      } else {
                        isEmpty == true;
                      }
                    });
                  },
                  child: isEmpty == true
                      ? Icon(
                          Icons.mic,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                ))
          ],
        ),
      ),
    );
  }
}
