class GroupModel {
  List<dynamic> memberUIDList;
  List<dynamic> adminList;
  String nameGroup;
  String avatarGroup;
  String statusGroup;
  String coverUrl;
  String id;
  String idCustom;
  String groupID;

  GroupModel(
      {this.memberUIDList,
      this.adminList,
      this.nameGroup,
      this.avatarGroup,
      this.statusGroup,
      this.coverUrl,
      this.id,
      this.idCustom,
      this.groupID});

  GroupModel.fromJson(Map<String, dynamic> json)
      : memberUIDList = json['memberUIDList'],
        adminList = json['adminList'],
        nameGroup = json['nameGroup'],
        avatarGroup = json['avatarGroup'],
        statusGroup = json['statusGroup'],
        coverUrl = json['coverUrl'],
        id = json['id'],
        idCustom = json['idCustom'],
        groupID = json['groupID'];

  toJson() {
    return {
      "memberUIDList": memberUIDList,
      "adminList": adminList,
      "nameGroup": nameGroup,
      "avatarGroup": avatarGroup,
      "statusGroup": statusGroup,
      "coverUrl": coverUrl,
      "id": id,
      "idCustom": idCustom,
      "groupID": groupID,
    };
  }
}
