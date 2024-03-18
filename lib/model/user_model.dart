class User {
  int? userid;
  String? name;
  String? email;
  String? password;
  String? gender;
  String? image;

  User({
    this.userid,
    this.name,
    this.email,
    this.password,
    this.gender,
    this.image,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        userid: json['userid'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        gender: json['gender'],
        image: json['image'],
      );

  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'name': name,
      'email': email,
      'password': password,
      'gender': gender,
      'image': image,
    };
  }
}
