import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/modules/MyProfile/views/my_profile_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../services/api_employe.dart';

class MyProfileController extends GetxController {
  Employe _employe;
  //Employe emp;
  String userImg = "";

  String userImage;

  void setUserImage(String imagePath) {
    userImage = imagePath;
  }

  // final TextEditingController userImg = TextEditingController();
  final TextEditingController useraccpasswordController =
      TextEditingController();
  final TextEditingController usernewpasswordController =
      TextEditingController();
  final TextEditingController userconfirmnewpasswordController =
      TextEditingController();

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userName2Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController functionController = TextEditingController();

  final RxBool isReadOnly = true.obs;
  String Url = "$URL/Files/getImage";
  String img;

  @override
  void onInit() {
    super.onInit();
    ApiEmploye().fetchEmployeById().then((employe) {
      _employe = employe;
      getInitialValue();
    });
  }

  Future<void> saveChanges(BuildContext context) async {
    if (useraccpasswordController.text == '' ||
        usernewpasswordController.text == '' ||
        userconfirmnewpasswordController.text == '') {
      _employe.adresse = locationController.text;
      _employe.email = emailController.text;

      _employe.nom = userNameController.text;
      _employe.prenom = userName2Controller.text;
      _employe.numTel = phoneNoController.text;
      if (userImage != null) {
        _employe.image = userImage;
      }
      ApiEmploye().updateEmploye(_employe);
    }
    if (useraccpasswordController.text != '' &&
        usernewpasswordController.text != '' &&
        userconfirmnewpasswordController.text != '') {
      bool isPasswordCorrect = await ApiEmploye().testPassword(
        _employe.id,
        useraccpasswordController.text,
      );
      if (!isPasswordCorrect) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(''),
              content: Text('Le mot de passe actuelle est incorrect.'),
              actions: <Widget>[
                TextButton(
                  child: Text("d'acord"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        if (usernewpasswordController.text ==
            userconfirmnewpasswordController.text) {
          _employe.adresse = locationController.text;
          _employe.email = emailController.text;

          _employe.nom = userNameController.text;
          _employe.prenom = userName2Controller.text;
          _employe.numTel = phoneNoController.text;
          _employe.password = usernewpasswordController.text;
          if (userImage != null) {
            _employe.image = userImage;
          }
          ApiEmploye().putEmploye( _employe, true);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(''),
                content: Text('veuillez ecrire le mot de passe correctement'),
                actions: <Widget>[
                  TextButton(
                    child: Text("d'acord"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future<String> getInitialValue() async {
    userImg = await "$Url/${_employe.image}";
    print("hahahah $userImg");
    userIdController.text = _employe.cin;
    userNameController.text = _employe.nom;
    userName2Controller.text = _employe.prenom;

    emailController.text = _employe.email;
    phoneNoController.text = _employe.numTel;
    dateOfBirthController.text = _employe.dateNaissance;
    locationController.text = _employe.adresse;
    functionController.text = _employe.fonction;

    return userImg;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
