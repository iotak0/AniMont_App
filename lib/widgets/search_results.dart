import 'package:anime_mont_test/Screens/Home/Search/search_page.dart';
import 'package:anime_mont_test/Screens/Profile/profial_screen.dart';
import 'package:anime_mont_test/Screens/Anime/anime_details_screen.dart';
import 'package:anime_mont_test/provider/user_model.dart';
import 'package:anime_mont_test/server/banner_ad.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_svg/svg.dart';

class SearchResults extends StatefulWidget {
  final List<Result> list;
  final bool isAnime;
  final int myId;
  final ScrollController listController;
  const SearchResults({
    Key? key,
    required this.list,
    required this.isAnime,
    required this.listController,
    required this.myId,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  final List<Users> list = [];
  @override
  Widget build(BuildContext context) {
    return widget.isAnime
        ? AnimeResults(
            myId: widget.myId,
            list: widget.list,
            listController: widget.listController,
          )
        : UsersResults(
            users: list,
            myId: widget.myId,
          );
  }
}

class AnimeResults extends StatelessWidget {
  const AnimeResults({
    Key? key,
    required this.list,
    required this.listController,
    required this.myId,
  }) : super(key: key);
  final List<Result> list;
  final int myId;
  final ScrollController listController;
  @override
  Widget build(BuildContext context) {
    int length = list.length;

    return ListView(
        controller: listController,
        children: List.generate(length, (idx) {
          var image = list[idx].image.contains('animetitans')
              ? list[idx].image
              : list[idx].image.contains('http')
                  ? list[idx].image
                  : image2 + list[idx].image;
          //  users[index].username
          if (idx == 0) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: const MyBannerAd(),
                ),
                GoTo(list: list, myId: myId, idx: idx, image: image),
              ],
            );
          } else {
            return GoTo(list: list, idx: idx, myId: myId, image: image);
          }
        }));
  }
}

class GoTo extends StatelessWidget {
  const GoTo({
    Key? key,
    required this.list,
    required this.idx,
    required this.image,
    required this.myId,
  }) : super(key: key);

  final List<Result> list;
  final int idx;
  final String image;
  final int myId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            if (list[idx].image.contains('animetitans')) {
              return AnimeDetailsScreen(
                url: list[idx].link,
                myId: myId,
              );
            } else {
              return ProfialPage(
                myId: myId,
                id: int.parse(list[idx].link),
                isMyProfile: false,
              );
            }
          },
        ));
      },
      child: Container(
          child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CachedNetworkImage(
            imageUrl: image,
            errorWidget: (context, url, error) => SizedBox(),
            height: 50,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: Text(
                list[idx].name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            !list[idx].admin
                ? SizedBox()
                : SvgPicture.string(
                    height: 20,
                    color: Color.fromARGB(255, 218, 197, 12),
                    '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>''')
          ],
        ),
        subtitle: SizedBox(
          width: MediaQuery.of(context).size.width - 120,
          child: Text(
            list[idx].sub,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      )
          // trailing: Container(
          //     height: 25,
          //     width: 70,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: Color.fromARGB(255, 57, 56, 56),
          //     ),
          //     child: Center(child: const LocaleText('follow')))),
          ),
    );
  }
}

class UsersResults extends StatelessWidget {
  const UsersResults({
    Key? key,
    required this.users,
    required this.myId,
  }) : super(key: key);

  final List<Users> users;
  final int myId;
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List.generate(
            users.length,
            (index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfialPage(
                            myId: myId,
                            id: users[index].id,
                            isMyProfile: false),
                      )),
                  child: Container(
                    child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            errorWidget: (context, url, error) => SizedBox(),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              users[index].username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            !users[index].admin
                                ? SizedBox()
                                : SvgPicture.string(
                                    height: 20,
                                    color: Color.fromARGB(255, 218, 197, 12),
                                    '''<svg width="24px" height="24px" viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <title>Iconly/Light/Star</title>
    <g id="Iconly/Light/Star" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" stroke-linecap="round" stroke-linejoin="round">
        <g id="Star" transform="translate(3.000000, 3.500000)" stroke="#000000" stroke-width="1.5">
            <path d="M10.1042564,0.67700614 L11.9316681,4.32775597 C12.1107648,4.68615589 12.4564632,4.93467388 12.8573484,4.99218218 L16.9453359,5.58061527 C17.9553583,5.72643988 18.3572847,6.95054503 17.6263201,7.65194084 L14.6701824,10.4924399 C14.3796708,10.7717659 14.2474307,11.173297 14.3161539,11.5676396 L15.0137982,15.5778163 C15.1856062,16.5698344 14.1297683,17.3266846 13.2269958,16.8573759 L9.57321374,14.9626829 C9.21502023,14.7768079 8.78602103,14.7768079 8.42678626,14.9626829 L4.77300425,16.8573759 C3.87023166,17.3266846 2.81439382,16.5698344 2.98724301,15.5778163 L3.68384608,11.5676396 C3.75256926,11.173297 3.62032921,10.7717659 3.32981762,10.4924399 L0.373679928,7.65194084 C-0.357284727,6.95054503 0.0446417073,5.72643988 1.05466409,5.58061527 L5.14265161,4.99218218 C5.54353679,4.93467388 5.89027643,4.68615589 6.06937319,4.32775597 L7.89574356,0.67700614 C8.34765049,-0.225668713 9.65234951,-0.225668713 10.1042564,0.67700614 Z" id="Stroke-1"></path>
        </g>
    </g>
</svg>''')
                          ],
                        ),
                        subtitle: Text(
                          users[index].name,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 57, 56, 56),
                            ),
                            child: Center(child: const LocaleText('follow')))),
                  ),
                )));
  }
}
