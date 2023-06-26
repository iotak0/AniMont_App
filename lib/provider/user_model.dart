import 'dart:convert';
import 'package:anime_mont_test/Screens/Anime/all_anime.dart';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String userName;
  String name;
  String bio;
  String email;
  String country;
  String birthday;
  String avatar;
  String backGroung;
  String id;
  String followers;
  String following;
  bool imfollowing = false;
  bool isfollowing = false;
  bool admin;
  List<Matual> matual;

  UserModel(
      this.userName,
      this.name,
      this.bio,
      this.avatar,
      this.email,
      this.country,
      this.birthday,
      this.backGroung,
      this.id,
      this.followers,
      this.following,
      this.imfollowing,
      this.isfollowing,
      this.admin,
      this.matual

      //upload/image.png
      );

  static UserModel fromJson(json) => UserModel(
        json['username'] ?? '',
        json['name'] ?? '',
        json['bio'] ?? '',
        json['avatar'] ?? '',
        json['email'] ?? '',
        json['city'] ?? '',
        json['birthday'] ?? '',
        json['background_image'] ?? '',
        json['id'].toString(),
        json['followers'] ?? "0",
        json['followings'] ?? "0",
        json['imfollowing'] == 0 ? false : true,
        json['isfolowing'] == 0 ? false : true,
        json['admin'] == '0' ? false : true,
        json['mutual'] == null
            ? []
            : json['mutual'].map<Matual>(Matual.fromJson).toList(),
      );

  static getAcount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    Map<String, dynamic> user = jsonDecode(userPref!) as Map<String, dynamic>;

    // user.forEach((key, value) {
    //   print('get account ${key}   +  ${value}');
    // });

    return user;
  }

  static setAcount(source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = source;
    prefs.setString('userData', jsonEncode(user));
    print('set account ${prefs.getString('userData')}');
    prefs.setBool('logIn', true);
  }

  static Future beforeLogOut(context) async {
    GoogleSignIn google = await GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserModel user = await getAcount();
      await FirebaseMessaging.instance.unsubscribeFromTopic('${user.id}');
      prefs.remove('userData');
      prefs.setBool('logIn', false);
      prefs.setInt('index', 0);
      prefs.clear();

      google.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future logOut(context) async {
    GoogleSignIn google = await GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool error = false;
    try {
      String? userPref = prefs.getString('userData');
      final body = json.decode(userPref!);
      UserProfial account = UserProfial.fromJson(body);
      await http.get(Uri.parse("https://animont.net")).catchError((e) {
        error = true;
        return Response("fff0", 404);
      }).then((value) async {
        if (value.statusCode == 200) {
          await FirebaseMessaging.instance
              .unsubscribeFromTopic('${account.id}');
          prefs.remove('userData');
          prefs.setBool('logIn', false);
          prefs.setInt('index', 0);
          // prefs.clear();
          await google.signOut().catchError((onError) {});
        } else
          error = true;
      });

      return !error;
    } catch (e) {
      return false;
    }

    //Restart.restartApp();
    //return prefs.getStr
    //ing('userData');
  }

  static Future unFollow(myId, userId) async {
    var response = await http.post(Uri.parse(un_follow), body: {
      "my_id": myId.toString(),
      "f_id": userId.toString()
    }).onError((error, stackTrace) {
      return Response('body', 200);
    });
    final body = json.decode(response.body);
    print("unFollow" + response.body);

    if (body['status'] == 'success') {
      return true;
    } else {
      return false;
    }
    print("Body $body");
  }

  static goTo(String headLine, String url, myId, context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AllAnime(
                  myId: myId,
                  headLine: headLine,
                  genre: url,
                )));
  }

  static Future follow(myId, userId) async {
    var response = await http.post(Uri.parse(follow_url), body: {
      "my_id": myId.toString(),
      "f_id": userId.toString()
    }).onError((error, stackTrace) {
      return Response('body', 200);
    });
    final body = json.decode(response.body);
    print("unFollow" + response.body);
    if (body['status'] == 'success') {
      return true;
    } else {
      return false;
    }
  }
}

class Users {
  final String name;
  final String username;
  final String avatar;
  final int id;
  final bool admin;

  Users(this.name, this.username, this.avatar, this.id, this.admin);
  static Users fromJson(json) => Users(json['id'], json['name'].toString(),
      json['username'], json['avatar'], json['admin'] == '0' ? false : true);
}

class UserProfial {
  String userName;
  String name;
  String bio;
  String email;
  String country;
  String birthday;
  String avatar;
  String backGroung;
  String id;
  int followers;
  int following;
  bool imfollowing = false;
  bool isfollowing = false;
  bool admin;
  List<Matual> matual;

  UserProfial(
      this.userName,
      this.name,
      this.bio,
      this.avatar,
      this.email,
      this.country,
      this.birthday,
      this.backGroung,
      this.id,
      this.followers,
      this.following,
      this.imfollowing,
      this.isfollowing,
      this.admin,
      this.matual

      //upload/image.png
      );

  static UserProfial fromJson(json) => UserProfial(
        json['username'] ?? '',
        json['name'] ?? '',
        json['bio'] ?? '',
        json['avatar'] ?? '',
        json['email'] ?? '',
        json['city'] ?? '',
        json['birthday'] ?? '',
        json['background_image'] ?? '',
        json['id'].toString(),
        json['followers'] ?? 0,
        json['followings'] ?? 0,
        json['imfollowing'] == 0 ? false : true,
        json['isfolowing'] == 0 ? false : true,
        json['admin'] == '0' ? false : true,
        json['mutual'] == null
            ? []
            : json['mutual'].map<Matual>(Matual.fromJson).toList(),
      );

  // static getAcount() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userPref = prefs.getString('userData');
  //   Map<String, dynamic> user = jsonDecode(userPref!) as Map<String, dynamic>;

  //   user.forEach((key, value) {
  //     print('get account ${value}');
  //   });

  //   return user;
  // }

  // static setAcount(source) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   Map<String, dynamic> user = source;
  //   prefs.setString('userData', jsonEncode(user));
  //   print('set account ${prefs.getString('userData')}');
  //   prefs.setBool('logIn', true);
  // }
}

class Matual {
  String name;
  String username;
  String avatar;
  String id;

  Matual(this.name, this.username, this.avatar, this.id);
  static Matual fromJson(json) => Matual(
        json['name'],
        json['username'],
        json['avatar'],
        json['id'].toString(),
      );
}

class NextEP {
  final String link;
  final bool none;

  NextEP(this.link, this.none);
}

class PrefEP {
  final String link;
  final bool none;

  PrefEP(this.link, this.none);
}
