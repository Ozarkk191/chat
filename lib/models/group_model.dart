class GroupModel {
  List<dynamic> memberUIDList;
  String nameGroup;
  String avatarGroup;
  String statusGroup;
  String coverUrl;

  GroupModel(
      {this.memberUIDList,
      this.nameGroup,
      this.avatarGroup,
      this.statusGroup,
      this.coverUrl});

  GroupModel.fromJson(Map<String, dynamic> json)
      : memberUIDList = json['memberUIDList'],
        nameGroup = json['nameGroup'],
        avatarGroup = json['avatarGroup'],
        statusGroup = json['statusGroup'],
        coverUrl = json['coverUrl'];

  toJson() {
    return {
      "memberUIDList": memberUIDList,
      "nameGroup": nameGroup,
      "avatarGroup": avatarGroup,
      "statusGroup": statusGroup,
      "coverUrl": coverUrl,
    };
  }
}
