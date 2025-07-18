class Office {
  final String name;
  final String? contactPerson;
  final List<String>? phones;
  final List<String>? emails;
  final String openingHours;
  final String? roomNumber;

  Office({
    required this.name,
    this.contactPerson,
    this.phones,
    this.emails,
    required this.openingHours,
    this.roomNumber,
  });
}
