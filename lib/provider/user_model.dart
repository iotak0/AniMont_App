import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String userName;
  final String name;
  final String bio;
  final String email;
  final String country;
  final String birthday;
  final String avatar;
  final String backGroung;
  final String id;
  final String followers;
  final String following;
  final bool admin;

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
    this.admin,
    //upload/image.png
  );

  static validInput(String text, String type, int min, int max) {
    if (text.isNotEmpty) {
      return "Please enter a valid $type";
      //'ادخل كلمة مرور لا تقل عن  4 حروف '
    }
    if (text.length < min) {
      "$type must be at least 6 characters";
    }
    if (text.length > max) {
      "$type must be at last 20 characters";
    } else {
      return "Please enter a valid $type";
    }
  }

  static UserModel fromJson(json) => UserModel(
        json['username'] ?? '',
        json['name'] ?? '',
        json['bio'] ?? '',
        json['avatar'] ?? '',
        json['email'] ?? '',
        json['country'] ?? '',
        json['birthday'] ?? '',
        json['background_image'] ?? '',
        json['id'].toString(),
        json['followers'].toString(),
        json['followings'].toString(),
        json['admin'] == 0 ? false : true,
      );

  static getAcount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString('userData');
    Map<String, dynamic> user = jsonDecode(userPref!) as Map<String, dynamic>;

    user.forEach((key, value) {
      print('get account ${key}   +  ${value}');
    });

    return user;
  }

  static setAcount(source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = source;
    prefs.setString('userData', jsonEncode(user));
    print('set account ${prefs.getString('userData')}');
    prefs.setBool('logIn', true);
  }

  static logOut(context) async {
    GoogleSignIn google = await GoogleSignIn();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    print('logeOut ${prefs.getString('userData')}');
    prefs.setBool('logIn', false);
    prefs.setInt('index', 0);
    Navigator.restorablePushReplacementNamed(context, '/LogIn');
    try {
      google.signOut();
    } catch (e) {}
    return prefs.getString('userData');
  }
}

class UserProfial {
  final String userName;
  final String name;
  final String bio;
  final String email;
  final String country;
  final String birthday;
  final String avatar;
  final String backGroung;
  final String id;
  final String followers;
  final String following;
  bool imfollowing = false;
  bool isfollowing = false;
  final bool admin;
  final List<Matual> matual;

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
        json['country'] ?? '',
        json['birthday'] ?? '',
        json['background_image'] ?? '',
        json['id'].toString(),
        json['followers'].toString() ?? '0',
        json['followings'].toString() ?? '0',
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
  final String name;
  final String username;
  final String avatar;
  final String id;

  Matual(this.name, this.username, this.avatar, this.id);
  static Matual fromJson(json) => Matual(
        json['name'],
        json['username'],
        json['avatar'],
        json['id'].toString(),
      );
}
