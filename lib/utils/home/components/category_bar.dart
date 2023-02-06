import 'package:anime_mont_test/pages/all_genres.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

import '../../../pages/genres_page.dart';
import '../../constes.dart';

//
class CategoryBar extends StatefulWidget {
  const CategoryBar({
    Key? key,
    required this.size,
  }) : super(key: key);
  final Size size;

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  List<Categories> categories = [];
  @override
  void initState() {
    super.initState();
    getWebsiteData();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://animetitans.com');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final cats = html
        .querySelectorAll('body > div.home-genres > span.genre-listx > a')
        .map((e) => e.innerHtml.trim())
        .toList();
    setState(() {
      categories = List.generate(
          cats.length,
          (index) =>
              Categories(cats[index].replaceAll('(', '').replaceAll(')', '')));
    });
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size.height / 15,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: ((context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllGenres(
                                  genre: categories[index].category,
                                )));
                  });
                },
                child: Container(
                  width: widget.size.width / 4,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: selectedIndex == index
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [darkPink, lightPink],
                          ),
                        )
                      : const BoxDecoration(color: Colors.transparent),
                  child: Text(
                    categories[index].category,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[300]),
                  ),
                ),
              );
            })));
  }
}


// return SizedBox(
//         height: widget.size.height / 15,
//         child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Column(
//                 children: categories
//                     .map((e) => Builder(builder: (context) {
//                           e.category.keys;
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedIndex = e.category();
//                               });
//                             },
//                             child: Container(
//                               width: widget.size.width / 4,
//                               alignment: Alignment.center,
//                               margin: const EdgeInsets.only(left: 12),
//                               decoration: selectedIndex == index
//                                   ? BoxDecoration(
//                                       borderRadius: BorderRadius.circular(12),
//                                       gradient: const LinearGradient(
//                                         colors: [darkPink, lightPink],
//                                       ),
//                                     )
//                                   : const BoxDecoration(
//                                       color: Colors.transparent),
//                               child: Text(
//                                 "",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                     color: Colors.grey[300]),
//                               ),
//                             ),
//                           );
//                         }))
//                     .toList())));
//   }
// }