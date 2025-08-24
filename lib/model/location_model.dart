class LocationModel {
  double latitude;
  double longitude;
  String country;
  String city;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.country,
    required this.city,
  });

  LocationModel.fromJson(Map<String, dynamic> json)
    : this(
        latitude: json["latitude"],
        longitude: json["longitude"],
        city: json["city"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "country": country,
    };
  }

  static LocationModel defaultLocation() {
    return LocationModel(
      latitude: 0.0,
      longitude: 0.0,
      country: "country",
      city: "city",
    );
  }
}
