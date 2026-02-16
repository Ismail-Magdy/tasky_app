class UserModel {
  static String collection = "Users";
  String? id;
  String? email;
  String? userName;
  String? password;

  UserModel({this.email, this.password, this.userName, this.id});

  UserModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        userName: json['user_name'],
      );

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'user_name': userName,
      'password': password,
      'id': id,
    };
  }
}
