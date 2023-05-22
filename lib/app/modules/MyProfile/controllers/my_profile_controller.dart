import 'package:dronalms/app/constants/constant.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../services/api_employe.dart';

class MyProfileController extends GetxController {
  Employe _employe;
  //Employe emp;
  String userImg = "";

  // final TextEditingController userImg = TextEditingController();
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

  void saveChanges() {
    _employe.adresse = locationController.text;
    _employe.email = emailController.text;
    // _employe.cin = userIdController.text;
    // _employe.dateNaissance = dateOfBirthController.text;
    _employe.nom = userNameController.text;
    _employe.prenom = userName2Controller.text;
    _employe.numTel = phoneNoController.text;

    // Call the API to save the changes
    ApiEmploye().updateEmploye(_employe);
  }

  getImage() async {}

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
