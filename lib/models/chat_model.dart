import 'package:chat/models/user_model.dart';

class ChatModel {
  final UserModel user;
  final String lastText;
  final String lastTime;
  final int checkTime;

  ChatModel({
    this.user,
    this.lastText,
    this.lastTime,
    this.checkTime,
  });
}
