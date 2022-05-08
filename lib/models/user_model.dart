class UserModel {
  String? uid;
  String? firstName;
  String? lastName;
  String? email;

  UserModel({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      uid: json!["uid"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
    };
  }
}
