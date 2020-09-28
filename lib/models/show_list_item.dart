import 'package:chat/models/group_model.dart';

class ShowListItem {
  final GroupModel group;
  final String lastText;
  final String lastTime;
  final int checkTime;

  ShowListItem({
    this.group,
    this.lastText,
    this.lastTime,
    this.checkTime,
  });
}
