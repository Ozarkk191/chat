class GroupModel {
  List<dynamic> memberUIDList;
  String nameGroup;
  String avatarGroup;
  String statusGroup;

  GroupModel({
    this.memberUIDList,
    this.nameGroup,
    this.avatarGroup,
    this.statusGroup,
  });

  GroupModel.fromJson(Map<String, dynamic> json)
      : memberUIDList = json['memberUIDList'],
        nameGroup = json['nameGroup'],
        avatarGroup = json['avatarGroup'],
        statusGroup = json['statusGroup'];

  toJson() {
    return {
      "memberUIDList": memberUIDList,
      "nameGroup": nameGroup,
      "avatarGroup": avatarGroup,
      "statusGroup": statusGroup,
    };
  }
}
