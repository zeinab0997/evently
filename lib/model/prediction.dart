class Prediction {
  final String? description;
  final String? placeId;
  final String? reference;
  final StructuredFormatting? structuredFormatting;
  final double? lat;
  final double? lng;

  Prediction({
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.lat,
    this.lng,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
      lat: json['lat'], // Only populated if lat/lng is fetched separately
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
      'reference': reference,
      'structured_formatting': structuredFormatting?.toJson(),
      'lat': lat,
      'lng': lng,
    };
  }
}

class StructuredFormatting {
  final String? mainText;
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      secondaryText: json['secondary_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'main_text': mainText,
      'secondary_text': secondaryText,
    };
  }
}
