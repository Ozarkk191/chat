import 'package:chat/models/user_model.dart';

class MenuSettings {
  static const String createGroup = 'สร้างกลุ่ม';
  static const List<String> groupList = [createGroup];

  static const String invite = 'เชิญ';
  static const String member = 'สมาชิกทั้งหมด';
  static const String settingGroup = 'ตั้งค่ากลุ่ม';
  static const List<String> menuList = [invite, member, settingGroup];

  static const String muted = 'ปิดการแจ้งเตือน';
  static const String medied = 'รูปภาพ/วีดิโอ';
  static const String shared = 'แชร์';
  static const String deleted = 'ลบ';
  static const List<String> privateList = [muted, medied, deleted];
  static const List<String> publicList = [muted, medied, shared, deleted];
}

class AppString {
  static String firstname = "";
  static String lastname = "";
  static String notiToken = "";
  static String phoneNumber = "";
  static String email = "";
  static String displayName = "";
  static String gender = "";
  static String birthDate = "";
  static String dateTime = "";
  static String photoUrl = "";
  static String uid = "";
  static String roles;
  static bool isActive;

  static String uidRoomChat;
  static String keyChatRooms;
}

class AppList {
  static List<UserModel> userList = [];
  static List<UserModel> avatarList = [];
  static List<String> uidList = [];
}
