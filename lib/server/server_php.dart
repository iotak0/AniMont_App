import 'dart:io';
import 'package:anime_mont_test/server/urls_php.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:path/path.dart';

class Server {
  static getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return true;
      } else {
        print("Connecation Error ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error Catch $e");
      return true;
    }
  }

  static postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        return responseBody;
      } else {
        print("Connecation Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }

  static Future<bool> deletePost(id) async {
    bool b = false;
    final Response response =
        await http.get(Uri.parse("$delete_post?post_id=${id}")).catchError((e) {
      b = false;

      return Response('body', 400);
    }).then((value) {
      print(value.body);
      // var json = jsonDecode(response.body);
      if (value.statusCode != 200) {
        b = false;
      } else {
        b = true;
      }
      return Response('body', 400);
    });

    return b;
  }

  static Future postRequestWithFiles(String url, Map data, File file) async {
    try {
      var request = await http.MultipartRequest("POST", Uri.parse(url));

      var length = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multipartFile = http.MultipartFile("image", stream, length,
          filename: basename(file.path));
      request.files.add(multipartFile);
      data.forEach((key, value) {
        request.fields[key] = value;
      });
      var myrequest = await request.send().catchError((error) {
        print("Connecation Error");
        return StreamedResponse(stream, 400);
      });
      if (myrequest.statusCode == 200) {
        var response =
            await http.Response.fromStream(myrequest).catchError((error) {
          print("Connecation Error");
          return Response("stream", 400);
        });
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else {
          print("Connecation Error ${response.statusCode}");
          return false;
        }
      } else {
        print("Connecation Error");
        return false;
      }
    } catch (e) {
      print("Error Catch $e");
      return false;
    }
  }
}
