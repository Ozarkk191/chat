import 'package:flutter/material.dart';

class UserModel {
  String firstName;
  String lastName;
  String notiToken;
  String phoneNumber;
  String email;
  String displayName;
  String gender;
  String birthDate;
  bool isActive;
  String roles;
  String createdAt;
  String updatedAt;
  String avatarUrl;
  List<dynamic> groupKey;
  String uid;
  String coverUrl;
  String lastTimeUpdate;

  UserModel({
    @required this.firstName,
    @required this.lastName,
    @required this.notiToken,
    @required this.phoneNumber,
    @required this.email,
    @required this.displayName,
    @required this.gender,
    @required this.birthDate,
    @required this.isActive,
    @required this.roles,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.avatarUrl,
    @required this.groupKey,
    @required this.coverUrl,
    @required this.uid,
    @required this.lastTimeUpdate,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        notiToken = json['notiToken'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        displayName = json['displayName'],
        gender = json['gender'],
        birthDate = json['birthDate'],
        isActive = json['isActive'],
        roles = json['roles'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'],
        avatarUrl = json['avatarUrl'],
        groupKey = json['groupKey'],
        coverUrl = json['coverUrl'],
        lastTimeUpdate = json['lastTimeUpdate'],
        uid = json['uid'];

  toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "notiToken": notiToken,
      "phoneNumber": phoneNumber,
      "email": email,
      "displayName": displayName,
      "gender": gender,
      "birthDate": birthDate,
      "isActive": isActive,
      "roles": roles,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "avatarUrl": avatarUrl,
      "groupKey": groupKey,
      "coverUrl": coverUrl,
      "lastTimeUpdate": lastTimeUpdate,
      "uid": uid,
    };
  }
}
