class Login {
  String email;
  String password;

  Login({this.email,  this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
  @override
  String toString() => toJson().toString();
}
