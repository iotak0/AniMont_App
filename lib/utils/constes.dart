import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

// Colors
const Color darkPurple = Color.fromRGBO(24, 12, 69, 0.8);
const Color lightPurple = Color.fromRGBO(62, 17, 120, 0.8);
const Color darkPurple2 = Color.fromARGB(188, 24, 12, 69);
const Color lightPurple2 = Color.fromARGB(17, 62, 17, 120);
const Color lightGreen = Color.fromRGBO(89, 227, 67, 0.8);
const Color lightPink = Color.fromRGBO(255, 9, 234, 0.8);
const Color darkPink = Color.fromRGBO(191, 15, 238, 0.8);
const Color textColor = Color.fromRGBO(187, 170, 204, 0.8);
const Color textColor2 = Color.fromARGB(204, 203, 191, 214);
const Color textColor3 = Color.fromARGB(204, 241, 239, 243);
// category

class Categories {
  final String category;
  Categories(this.category);
}

class Anime {
  final String name;
  final double? score;
  final int number;
  final String poster;
  final String backgroundImage;
  final List episode;
  final int episodeNumber;

  const Anime(
    this.name,
    this.score,
    this.number,
    this.poster,
    this.backgroundImage,
    this.episode,
    this.episodeNumber,
  );

  map(Builder Function(dynamic e) param0) {}
}

const terendsData = [
  Anime(
      'SPY×FAMILY Part 2',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
  Anime(
      'BLEACH: Thousand-Year Blood War',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/9/90/90828058fb44667cd042525dbf01a33d.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      ],
      11),
  Anime(
      'The Eminence in Shadow',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/5/59/595c9af8497cc449f5628408cc483a82.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      10),
  Anime(
      'ONE PIECE',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/5/58/5806a16f2892768b4930c39ebf6ce756.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      30),
  Anime(
      'Chainsaw Man',
      8.98,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/a1/a10036bba13c5e9fd1f4f4c9473f7cd1.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      10),
  Anime(
      'Mob Psycho 100 III',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/9/91/917de45e25c2674052ccb665ae9cbc33.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
  Anime(
      'Boku no Hero Academia 6',
      8.33,
      201,
      'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
      'https://static.bunnycdn.ru/i/cache/images/9/90/904ab6ffdcdbbaa95ed2ab749bee5104.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      24),
];
const recentlyUpdata = [
  Anime(
      'Aru Asa Dummy Head Mic ni Natteita Ore-kun no Jinsei',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/8/8a/8a366d90dcf16e656e33279696a425a2.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
  Anime(
      'Lucifer and the Biscuit Hammer',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/a/a7/a73397a729651ee0625fb86e461d6519.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
  Anime(
      'Legend of Mana -The Teardrop Crystal',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/8/80/800f547d602f31c358a34f2960666f47.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
  Anime(
      'Ya Boy Kongming!',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/4/4c/4ce41fc56e1c6ea80c4c4c564f24d4b5.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      24),
  Anime(
      'My Master Has No Tail',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/7/7f/7f84542bcb2a0a27d066e0ecf10780e2.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      24),
  Anime(
      'Ani ni Tsukeru Kusuri wa Nai! 5',
      8.33,
      201,
      'https://static.bunnycdn.ru/i/cache/images/d/d1/d1097150d053f84e8f97a260e7b147e5.jpg',
      'https://static.bunnycdn.ru/i/cache/images/a/ad/ad8f6f17a1806d36ceea5eb9983cb068.jpg',
      [
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
        'https://cdn.myanimelist.net/images/anime/1806/126216.jpg'
      ],
      12),
];

class DataInfo {
  final String backgroundImage;
  final String name;
  final String info;
  final String category;
  final List ep;

  DataInfo(this.backgroundImage, this.name, this.info, this.category, this.ep);
  map(Builder Function(dynamic e) param0) {}
}

class DataInfo2 {
  final String backgroundImage;
  final String poster;
  final String name;
  final String description;
  final List<String> info;
  final List<String> category;
  final List<String> epLink;
  final List<String> epNum;

  DataInfo2(this.backgroundImage, this.poster, this.name, this.description,
      this.info, this.category, this.epLink, this.epNum);

  map(Builder Function(dynamic e) param0) {}
}

class Player {
  final String url;
  final String next;
  final String back;
  final List<String> ep;

  Player(this.url, this.next, this.back, this.ep);
}

class Article {
  final String name;
  final String score;
  final String url;
  final String poster;

  Article(this.name, this.score, this.url, this.poster);
  map(Builder Function(dynamic e) param0) {}
}
