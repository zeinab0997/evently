import 'dart:convert';

import 'location_model.dart';

class UserModel {
  String id;
  String email;
  String name;
  int createdAt;
  LocationModel userLocation;
  List<String> favEvents;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.userLocation,
    required this.favEvents,
  });

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        createdAt: json['createdAt'] ?? '',
        userLocation:
            json['userLocation'] != null
                ? LocationModel.fromJson(json["userLocation"])
                : LocationModel.defaultLocation(),
        favEvents:
            (json['favEvents'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "createdAt": createdAt,
      "userLocation": userLocation.toJson(),
      "favEvents": favEvents,
    };
  }
}
