// comments from json
import 'package:anime_mont_test/provider/user_model.dart';

class AnimeComments {
  var commentAnime;
  var commentId;
  var fair;
  var fullText;
  var isEdited;
  var isLiked;
  var replyOf;
  var likes;
  var commentCont;
  var replyPage = 1;
  var replyHasMore = true;
  var replyErorr = false;
  var replyLoading = false;
  var replyComplet = false;
  var showReplies = true;
  var editing = false;
  var replyEdting = false;
  var hasDeleted = false;
  var done = false;
  var repliesCount;
  var repliesCountFinal;
  UserModel account;

  final String commentTime;
  List<AnimeComments> replies = [];
  final String timeNow;

  AnimeComments(
    this.commentAnime,
    this.commentId,
    this.fair,
    this.fullText,
    this.isEdited,
    this.isLiked,
    this.replyOf,
    this.likes,
    this.commentCont,
    this.account,
    this.commentTime,
    this.repliesCount,
    this.repliesCountFinal,
    this.timeNow,
  );

  static PostsComments fromJson(json) => PostsComments(
        json['comment_anime'].toString(),
        int.parse(json['comment_id']),
        json['fair'] == '0' ? false : true,
        json['fair'] == '0' ? false : true,
        json['is_edited'] == '0' ? false : true,
        json['is_like'],
        json['reply_of'] == '0' ? 0 : int.parse(json['reply_of']),
        json['likes'],
        json['comment_cont'],
        UserModel.fromJson(json['account']),
        json['comment_time'],
        json['replies'],
        json['replies'],
        json['time_now'],
      );
}

// comments from json
class PostsComments {
  var postId;
  var commentId;
  var fair;
  var fullText;
  var isEdited;
  var isLiked;
  var replyOf;
  var likes;
  var commentCont;
  var replyPage = 1;
  var replyHasMore = true;
  var replyErorr = false;
  var replyLoading = false;
  var replyComplet = false;
  var showReplies = true;
  var editing = false;
  var replyEdting = false;
  var hasDeleted = false;
  var done = false;
  var repliesCount;
  var repliesCountFinal;
  UserModel account;

  final String commentTime;
  List<PostsComments> replies = [];
  final String timeNow;

  PostsComments(
    this.postId,
    this.commentId,
    this.fair,
    this.fullText,
    this.isEdited,
    this.isLiked,
    this.replyOf,
    this.likes,
    this.commentCont,
    this.account,
    this.commentTime,
    this.repliesCount,
    this.repliesCountFinal,
    this.timeNow,
  );

  static PostsComments fromJson(json) => PostsComments(
        json['post_id'].toString(),
        int.parse(json['comment_id']),
        json['fair'] == '0' ? false : true,
        json['fair'] == '0' ? false : true,
        json['is_edited'] == '0' ? false : true,
        json['is_like'],
        json['reply_of'] == '0' ? 0 : int.parse(json['reply_of']),
        json['likes'],
        json['comment_cont'],
        UserModel.fromJson(json['account']),
        json['comment_time'],
        json['replies'],
        json['replies'],
        json['time_now'],
      );
}
