import 'package:anime_mont_test/Screens/Posts/post_class.dart';
import 'package:anime_mont_test/server/Chat-Server-master/lib/Model/MessageModel.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_controller.dart';

class ChatGetX extends GetxController {
  var connectedUser = 0.obs;
  var typingUsers = 0.obs;
  var messageList = <MessageModel>[].obs;
  var controller = CountdownController(autoStart: true).obs;
  var countdown = 60.obs;
   static var noitificationCount = 0.obs;
  static var posts = <Post>[].obs;
}
