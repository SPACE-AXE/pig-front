import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  FlutterSecureStorage? storage;

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
    this.storage,
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
      storage: json['storage'],
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
    storage = data.storage;
    notifyListeners();
    debugPrint(
        "$id, $name, $nickname, $email, $username, $password, $birth, $createdAt, $deletedAt, $emailToken, $card, $storage");
  }

  void deleteUserData() {
    storage!.delete(key: "login");
    id = null;
    name = null;
    nickname = null;
    email = null;
    username = null;
    password = null;
    birth = null;
    createdAt = null;
    deletedAt = null;
    emailToken = null;
    card = null;
    storage = null;
    notifyListeners();
  }
}

final userDataProvider = ChangeNotifierProvider<UserData>((ref) {
  return UserData();
});
