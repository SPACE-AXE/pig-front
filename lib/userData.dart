import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserData extends ChangeNotifier {
  int? id;
  String? name;
  String? nickname;
  String? email;
  String? username;
  String? password;
  String? birth;
  String? createdAt;
  String? deletedAt;
  String? emailToken;
  String? card;
  String? accessToken;
  String? refreshToken;

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
    this.accessToken,
    this.refreshToken,
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
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
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
      'accessToken': accessToken,
      'refreshToken': refreshToken,
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
    accessToken = data.accessToken;
    refreshToken = data.refreshToken;
    notifyListeners();
    debugPrint(
        "$id, $name, $nickname, $email, $username, $password, $birth, $createdAt, $deletedAt, $emailToken, $card, $accessToken, $refreshToken");
  }
}

final userDataProvider = ChangeNotifierProvider<UserData>((ref) {
  return UserData();
});
