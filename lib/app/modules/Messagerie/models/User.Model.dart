class Users {
  int id;
  String nom;
  String prenom;
  String image;
  String username;
  String password;

  Users(
      {this.id,
      this.nom,
      this.prenom,
      this.image,
      this.username,
      this.password});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        image: json['image'],
        username: json['username'],
        password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'image': image,
      'username': username,
      'password': password,
    };
  }
}
