import 'package:chat/models/group_model.dart';
import 'package:chat/models/user_model.dart';

class MenuSettings {
  static const String createGroup = 'สร้างกลุ่ม';
  static const List<String> groupList = [createGroup];

  static const String invite = 'เชิญ';
  static const String member = 'สมาชิกทั้งหมด';
  static const String settingGroup = 'ตั้งค่ากลุ่ม';
  static const String post = 'โพสต์ข่าว';
  static const List<String> menuList = [invite, member];
  static const List<String> menuList2 = [invite, member, settingGroup, post];

  static const String muted = 'ปิดการแจ้งเตือน';
  static const String medied = 'รูปภาพ/วีดิโอ';
  static const String shared = 'แชร์';
  static const String deleted = 'ลบ';
  static const List<String> privateList = [muted, medied, deleted];
  static const List<String> publicList = [muted, medied, shared, deleted];
}

class AppString {
  static String uidRoomChat;
  static String uidAdmin;
  static String keyChatRooms;
  static String nameGroup;
}

class AppModel {
  static UserModel user;
  static GroupModel group;
}

class AppList {
  static List<String> lastTextList = List<String>();
  static List<String> lastTimeList = List<String>();
  static List<String> lastGroupTextList = List<String>();
  static List<String> lastGroupTimeList = List<String>();
  static List<UserModel> userList = [];
  static List<UserModel> allAdminList = [];
  static List<UserModel> allUserList = [];
  static List<String> allUidList = [];
  static List<UserModel> adminList = [];
  static List<String> uidList = [];
  static List<String> adminUidList = [];
  static List<GroupModel> myGroupList = [];
  static List<GroupModel> groupList = [];
  static List<GroupModel> groupAllList = [];
  static List<String> groupKey = [];
  static List<int> indexList = List<int>();

  static List<UserModel> user = [];
  static List<UserModel> admin = [];
  static List<UserModel> superAdmin = [];
}
