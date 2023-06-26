import 'package:anime_mont_test/provider/custom_colors.dart';
import 'package:anime_mont_test/widgets/loaging_gif.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import '../Anime/anime_details_screen.dart';

class EpisodeDates extends StatefulWidget {
  final int myId;
  const EpisodeDates({
    super.key,
    required this.myId,
  });

  @override
  State<EpisodeDates> createState() => _EpisodeDatesState();
}

class _EpisodeDatesState extends State<EpisodeDates> {
  late List<EpisodeDate> episodeDate;
  bool loading = false;
  List<EpisodeDate> sunday = [];
  List<EpisodeDate> monday = [];
  List<EpisodeDate> tuesday = [];
  List<EpisodeDate> wednesday = [];
  List<EpisodeDate> thursday = [];
  List<EpisodeDate> friday = [];
  List<EpisodeDate> saturday = [];

  List days = [
    "sunday",
    "monday",
    "friday",
    "tuesday",
    "wednesday",
    "thursday",
    "saturday"
  ];
  whichDay(day) async {
    if (day == "sunday") {
      print('sunday');
      return sunday;
    }
    if (day == "monday") {
      print('monday');
      return monday;
    }
    if (day == "tuesday") {
      print('tuesday');
      return tuesday;
    }
    if (day == "wednesday") {
      print('wednesday');
      return wednesday;
    }
    if (day == "thursday") {
      print('thursday');
      return thursday;
    }
    if (day == "friday") {
      print('friday');
      return friday;
    }
    if (day == "saturday") {
      print('saturday');
      return saturday;
    }
  }

  @override
  getWebsiteData() async {
    for (var e in days) {
      String day = e;
      List<EpisodeDate> dayList = await whichDay(day);
      //print('hhhhhhhhhhhhhh${day}');
      final url = Uri.parse(
          'https://animetitans.net/%d9%85%d9%88%d8%a7%d8%b9%d9%8a%d8%af-%d8%a7%d9%84%d8%ad%d9%84%d9%82%d8%a7%d8%aa/');

      final response = await http.get(url);
      dom.Document html = dom.Document.html(response.body);

      final date = html
          .querySelectorAll(
              'div.bixbox.schedulepage.sch_$day > div.listupd > div > div > a > div.limit > div.bt > span.epx.cndwn')
          .map((e) => e.innerHtml.trim())
          .toList();

      final name = html
          .querySelectorAll(
              '  div.bixbox.schedulepage.sch_$day > div.listupd > div > div > a > div.tt')
          .map((e) => e.innerHtml.trim())
          .toList();
      final episodeNum = html
          .querySelectorAll(
              " div.bixbox.schedulepage.sch_$day > div.listupd > div > div > a > div.limit > div.bt > span.sb.Sub")
          .map((e) => e.innerHtml.trim())
          .toList();

      final urls = html
          .querySelectorAll(
              'div.bixbox.schedulepage.sch_$day > div.listupd > div > div > a')
          .map((e) => e.attributes['href']!)
          .toList();
      final poster = html
          .querySelectorAll(
              ' div.bixbox.schedulepage.sch_$day > div.listupd > div > div > a > div.limit > img')
          .map((e) => e.attributes['src']!)
          .toList();
      //print('///////////////////////////$name');

      episodeDate = List.generate(
          date.length,
          (index) => EpisodeDate(
                name[index].replaceAll("(", '').replaceAll(")", ''),
                urls[index].replaceAll("(", '').replaceAll(")", ''),
                date[index].replaceAll("(", '').replaceAll(")", ''),
                episodeNum[index].replaceAll("(", '').replaceAll(")", ''),
                urls[index].replaceAll("(", '').replaceAll(")", ''),
                poster[index].replaceAll("(", '').replaceAll(")", ''),
              ));
      dayList.addAll(episodeDate);
      episodeDate.clear();
      if (days.indexOf(e) == days.length - 1) {
        loading = false;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    setState(() {});
    //#content > div > div.postbody > div.bixbox.schedulepage.sch_tuesday > div.listupd > div:nth-child(1) > div > a > div.limit > div.bt

    getWebsiteData();
  }

  @override
  Widget build(BuildContext context) {
    CustomColors customColor = CustomColors(context);
    return Scaffold(
        appBar: AppBar(
          title: LocaleText(
            "episode_dates",
            style: TextStyle(
                color: customColor.primaryColor,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: customColor.primaryColor,
            ),
          ),
          backgroundColor: customColor.backgroundColor,
          elevation: 1,
        ),
        body: loading
            ? LoadingGif(logo: true,)
            : ListView(
                children: [
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: friday,
                    day: 'friday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: saturday,
                    day: 'saturday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: sunday,
                    day: 'sunday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: monday,
                    day: 'monday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: tuesday,
                    day: 'tuesday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: wednesday,
                    day: 'wednesday',
                  ),
                  EpisodeDateCard(
                    myId: widget.myId,
                    customColor: customColor,
                    episodeDate: thursday,
                    day: 'thursday',
                  ),
                ],
              )
        //Text(days[index]),
        //         Column(children: [
        //   Container(
        //     child: Text("Sunday"),
        //   ),
        //   Column(
        //       children:
        //           List.generate(sunday.length, (index) => Text(sunday[index].name)))
        // ])
        );
  }
}

class EpisodeDateCard extends StatelessWidget {
  const EpisodeDateCard({
    Key? key,
    required this.customColor,
    required this.episodeDate,
    required this.day,
    required this.myId,
  }) : super(key: key);
  final int myId;
  final CustomColors customColor;
  final List<EpisodeDate> episodeDate;
  final String day;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LocaleText(
            day,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontSize: 20,
                color: customColor.primaryColor,
                fontFamily: 'SFPro',
                fontWeight: FontWeight.bold),
          ),
        ),
        Column(
            children: List.generate(
                episodeDate.length,
                (index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimeDetailsScreen(
                                      myId: myId,
                                      url: episodeDate[index].url,
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: customColor.iconTheme,
                          ),
                          height: 60,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  //  color: customColors.iconTheme,

                                  //cacheManager: customCachManager(),
                                  height: 60,
                                  width: 60,
                                  key: UniqueKey(),
                                  imageUrl: episodeDate[index].postr,

                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 60,
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      SizedBox(
                                        width: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            episodeDate[index].name,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 18,
                                                fontFamily: 'SFPro',
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    customColor.primaryColor),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 20,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            color: customColor.backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Image.asset(
                                                'images/Light/Time Circle.png',
                                                height: 15,
                                                width: 15,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                episodeDate[index].date,
                                                style: TextStyle(
                                                    fontFamily: 'SFPro',
                                                    fontSize: 15,
                                                    color: customColor
                                                        .primaryColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: customColor.backgroundColor,
                                    ),
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 50,
                                    child: Text(
                                      episodeDate[index].number,
                                      style: TextStyle(
                                          fontFamily: 'SFPro',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: customColor.primaryColor),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))),
      ],
    );
  }
}

class EpisodeDate {
  final String name;
  final String url;
  final String date;
  final String number;
  final String episodeNum;
  final String postr;

  EpisodeDate(
      this.name, this.url, this.date, this.number, this.episodeNum, this.postr);
}
