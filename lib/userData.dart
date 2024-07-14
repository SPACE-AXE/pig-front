import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserData extends ChangeNotifier {
  int? id;
  String? name;
  String? nickname;
  String? email;
  String? username;
  String? createdAt;
  String? deletedAt;

  UserData({
    this.id,
    this.name,
    this.nickname,
    this.email,
    this.username,
    this.createdAt,
    this.deletedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      email: json['email'],
      username: json['username'],
      createdAt: json['createdAt'],
      deletedAt: json['deletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'username': username,
      'createdAt': createdAt,
      'deletedAt': deletedAt,
    };
  }

  void updateUserData(UserData data) {
    id = data.id;
    name = data.name;
    nickname = data.nickname;
    email = data.email;
    username = data.username;
    createdAt = data.createdAt;
    deletedAt = data.deletedAt;
    notifyListeners();
    debugPrint(
        "$id, $name, $nickname, $email, $username, $createdAt, $deletedAt");
  }

  void deleteUserData() {
    id = null;
    name = null;
    nickname = null;
    email = null;
    username = null;
    createdAt = null;
    deletedAt = null;
    notifyListeners();
  }
}

final userDataProvider = ChangeNotifierProvider<UserData>((ref) {
  return UserData();
});
