import 'office.dart';

class Building {
  final String name;
  final String address;
  final String description;
  final List<String>? phones;
  final List<String>? emails;
  final List<String>? accessibility;
  final List<Office>? offices;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  Building({
    required this.name,
    required this.address,
    required this.description,
    this.phones,
    this.emails,
    this.accessibility,
    this.offices,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });
}
