import 'package:anime_mont_test/utils/home/components/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constes.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: SizedBox(
          height: widget.size.height / 15,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                height: widget.size.height / 15,
                decoration: BoxDecoration(
                    color: lightPurple,
                    borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24, right: 12),
                      child: Icon(Icons.search),
                    ),
                    Expanded(
                        child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: myController,
                      decoration: InputDecoration(
                        hintText: 'Search Anime & Movie',
                        hintStyle: TextStyle(color: textColor),
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
                      gradient:
                          const LinearGradient(colors: [lightPink, darkPink]),
                      borderRadius: BorderRadius.circular(14)),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String s = myController.text;

                        if (s.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(search: s)));
                        }
                        myController.clear();
                      });
                    },
                    child: Icon(Icons.search),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
