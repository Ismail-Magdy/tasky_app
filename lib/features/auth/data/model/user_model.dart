class UserModel {
  static String collection = "User";
  UserModel({this.email, this.id, this.password, this.userName});
  String? email;
  String? userName;
  String? password;
  String? id;
  //
  UserModel.fromJson(Map<String, Object?> json)
    : this(
        email: json["email"]! as String,
        userName: json["user_name"]! as String,
        password: json["password"]! as String,
        id: json["id"]! as String,
      );

  //
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "user_name": userName,
      "password": password,
      "id": id,
    };
  }
}
