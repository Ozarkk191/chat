import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';

class ChatModel {
  final UserModel user;
  final String lastText;
  final String lastTime;
  final int checkTime;
  final GroupModel group;

  ChatModel({
    this.user,
    this.lastText,
    this.lastTime,
    this.checkTime,
    this.group,
  });
}
