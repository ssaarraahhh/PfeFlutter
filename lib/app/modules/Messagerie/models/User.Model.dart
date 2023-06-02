class Users {
  int id;
  String name;
  String username;
  String password;

  Users({ this.id,  this.name,  this.username , this.password});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'] ,
      name: json['name'] ,
      username: json['username'] ,
      password: json['password']

    );
  }
}
