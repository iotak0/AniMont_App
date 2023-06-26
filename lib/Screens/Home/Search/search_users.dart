import 'dart:convert';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key, required this.myId});
  final int myId;
  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  static TextEditingController search = TextEditingController();
  List<Users> user = [];
  List<Users> users = [];
  int page = 1;
  //final listController = ScrollController();

  // Future getWebsiteData(searchKey) async {
  getUsers(key) async {
    users.clear();
    final response =
        await http.post(Uri.parse(search_Users), body: {'key': key});
    final body = json.decode(response.body);
    // user = List.generate(
    //     10,
    //     (i) => Users(body[i]['name'].toString(), body[i]['username'],
    //         body[i]['avatar']));

    setState(() {
      users = body.map<Users>(Users.fromJson).toList();
    });
    //loadAnime();
  }

  @override
  void initState() {
    search.addListener(() {
      if (search.text.length > 2) {
        setState(() {
          users.clear();

          print('kkkk${search.text} page $page');
          getUsers(search.text);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ArrowBackButton(size: size),
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: size.height / 15,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(22)),
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
                                  controller: search,
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
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(22)),
                              margin: const EdgeInsets.only(left: 10),
                              width: 50,
                              height: 50,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    search.clear();
                                  });
                                },
                                child: Icon(Icons.search),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        users.isNotEmpty
            ? Expanded(
                child: AllUsers(
                myId: widget.myId,
                users: users,
              ))
            : Center(child: CircularProgressIndicator())
      ]),
    );
  }
}

///////////////  conestens  ////////////////
class AllUsers extends StatelessWidget {
  const AllUsers({
    Key? key,
    required this.users,
    required this.myId,
  }) : super(key: key);
  final int myId;
  final List<Users> users;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        // controller: controller,
        child: SizedBox(
            width: double.infinity,
            child: Wrap(
                spacing: 8,
                alignment: WrapAlignment.center,
                children: users.map((e) {
                  int idx = users.indexOf(e);
                  return Builder(builder: (context) {
                    return 1 == 1
                        // idx != anime.length - 1
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfialPage(
                                            myId: myId,
                                            id: e.id,
                                            isMyProfile: false,
                                          )));
                            },
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Stack(children: [
                                  Container(
                                      width: 110,
                                      height: 210,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 1.5, left: 8),
                                            child: Text(
                                              e.name,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                      width: 110,
                                      height: 190,
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 24),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  // image2 +
                                                  e.avatar))))
                                ])))
                        : Container();
                  });
                }).toList())));
  }
}

Padding buildTitle(String context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(context,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
