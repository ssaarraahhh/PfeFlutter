import 'dart:convert';

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/models/employe.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Message.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/User.Model.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ContactController.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ControllerHub.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ConversationController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'chatPage.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  String Url = "$URL/Files/getImage";

  @override
  void initState() {
    super.initState();
    ControllerHub().getOnlineUsersLis();
    ControllerHub().getOnlineUsersInv();
  }

  final conversationController = Get.put(ConversationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back_sharp,
                color: Colors.black, size: 25),
          ),
          title: const Text(
            "Contacts",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
                letterSpacing: 0.5),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: GetBuilder<ContactController>(
          init: ContactController(),
          builder: (controller) => FutureBuilder<List<Users>>(
            future: controller.getAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('Unknown error');
              }

              final users = snapshot.data;

              return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final token = prefs.getString('token');
                        print(token);

                        final Map<String, dynamic> decodedToken = json.decode(
                            ascii.decode(base64.decode(
                                base64.normalize(token.split(".")[1]))));

                        print(decodedToken);
                        final String sid = decodedToken[
                            'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
                        print(sid);
                        int intFrom = int.parse(sid);
                        print(users[index].id);
                        print(users[index].nom);
                        conversationController.messages = [].obs;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                users[index].nom,
                                users[index].prenom,
                                users[index].image,
                                users[index].id,
                                intFrom)));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            height: 65,
                          ),
                          Flexible(
                            child: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.transparent,
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: Stack(
                                  children: [
                                    ClipOval(
                                      child: Image.network(
                                          "$Url/${users[index].image}"),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: CircleAvatar(
                                        radius: 6,
                                        backgroundColor: (ControllerHub.nameOL)
                                                .contains(users[index].nom)
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              "${users[index].nom} ${users[index].prenom}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            },
          ),
        ));
  }
}
