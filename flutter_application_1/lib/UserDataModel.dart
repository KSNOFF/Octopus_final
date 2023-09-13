// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  String username;
  String email;
  String avatar;
  String language;

  UserDataModel({
    required this.username,
    required this.email,
    required this.avatar,
    required this.language,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        username: json["Username"],
        email: json["Email"],
        avatar: json["Avatar"],
        language: json["Language"],
      );

  Map<String, dynamic> toJson() => {
        "Username": username,
        "Email": email,
        "Avatar": avatar,
        "Language": language,
      };
}
