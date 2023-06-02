import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/modules/Messagerie/service/ContactController.dart';
import 'package:dronalms/app/modules/Messagerie/service/ControllerHub.dart';
import 'package:dronalms/app/modules/Messagerie/service/ConversationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authetification.dart';
import 'HomeScreen.dart';
import 'chatPage.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
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
          actions: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Color(0xFFEEEEEE),
                child: IconButton(
                    onPressed: () async {
                      await ControllerHub().logOut().then((value) =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Authentification())));
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.black,
                    )),
              ),
            )
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: GetBuilder<ContactController>(
          init: ContactController(),
          builder: (controller) => FutureBuilder<List<Employe>>(
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
                        final token = prefs.getString('personId');
                        int intFrom = int.parse(token);
                        print(users[index].id);
                        print(users[index].nom);
                        conversationController.messages= [].obs ;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(
                                users[index].nom, users[index].id, intFrom)));
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
                                      child: Image.asset(
                                        'assets/images/user.jpg',
                                      ),
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
                              users[index].nom,
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
