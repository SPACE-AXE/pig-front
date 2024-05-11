import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  int? id = null;
  String? name = null;
  String? nickname = null;
  String? email = null;
  String? username = null;
  String? password = null;
  String? birth = null;
  String? createdAt = null;
  String? deletedAt = null;
  String? emailToken = null;
  String? card = null;

  UserData({
    this.id,
    this.name,
    this.nickname,
    this.email,
    this.username,
    this.password,
    this.birth,
    this.createdAt,
    this.deletedAt,
    this.emailToken,
    this.card,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      birth: json['birth'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
      emailToken: json['emailToken'],
      card: json['card'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'username': username,
      'password': password,
      'birth': birth,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
      'emailToken': emailToken,
      'card': card,
    };
  }

  void updateUserData(UserData data) {
    id = data.id;
    name = data.name;
    nickname = data.nickname;
    email = data.email;
    username = data.username;
    password = data.password;
    birth = data.birth;
    createdAt = data.createdAt;
    deletedAt = data.deletedAt;
    emailToken = data.emailToken;
    card = data.card;
    debugPrint(
        "$id, $name, $nickname, $email, $username, $password, $birth, $createdAt, $deletedAt, $emailToken, $card");
  }
}
