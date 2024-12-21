// File: lib/location_model.dart

class Location {
  final String locationName;
  final String address;
  final String city;
  final String state;
  final String country;
  final bool isIncludedInGeoFence;
  final int? distance;
  final double? latitude;
  final double? longitude;

  Location({
    required this.locationName,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.isIncludedInGeoFence = false,
    this.distance,
    this.latitude,
    this.longitude,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'locationName': locationName,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'isIncludedInGeoFence': isIncludedInGeoFence,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
