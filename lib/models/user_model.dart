class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;

  UserModel({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      uid: json!["uid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "gender": gender,
    };
  }
}
