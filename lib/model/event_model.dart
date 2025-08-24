import 'package:evently/model/location_model.dart';

class EventModel {
  String id;
  String title;
  String description;
  int catIndex;
  bool isDone;
  int date;
  int time;
  LocationModel location;
  String userId;

  EventModel({
    this.id = "",
    required this.title,
    required this.description,
    required this.isDone,
    required this.date,
    required this.time,
    required this.location,
    required this.catIndex,
    required this.userId
  });

  EventModel.fromJson(Map<String, dynamic> json)
      :this(
    id: json["id"],
    date: json["date"],
    title: json["title"],
    description: json["description"],
    location: LocationModel.fromJson(json["location"]),
    isDone: json["isDone"],
    time: json["time"],
    catIndex: json["catIndex"],
    userId: json["userId"]
  );

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "date": date,
      "title": title,
      "description": description,
      "location": location.toJson(),
      "isDone": isDone,
      "time": time,
      "catIndex": catIndex,
      "userId": userId
    };
  }
}
