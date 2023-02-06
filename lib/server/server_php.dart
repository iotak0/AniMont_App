import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class Server {
  getRequest(String url) async {
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

  postRequest(String url, Map data) async {
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

  postRequestWithFiles(String url, Map data, File file) async {
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
      var myrequest = await request.send();
      var response = await http.Response.fromStream(myrequest);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Connecation Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error Catch $e");
    }
  }
}
