class Address {
  final int id;
  final String name;
  final String address;
  final String city;
  final String postcode;
  final String state;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.postcode,
    required this.state,
    required this.isDefault,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'postcode': postcode,
      'state': state,
      'isDefault': isDefault,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      city: json['city'],
      postcode: json['postcode'],
      state: json['state'],
      isDefault: json['isDefault'],
    );
  }
}
