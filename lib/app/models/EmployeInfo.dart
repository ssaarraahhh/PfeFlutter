class EmployeInfo {
  String email;
  String password;

 EmployeInfo({this.email,  this.password});

  factory EmployeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeInfo(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

      
       Map<String, dynamic> toMap() {
    return {
      'userName': email,
      'password': password,
      // Include other properties of EmployeInfo as needed
    };
  }
  @override
  String toString() => toJson().toString();
}
