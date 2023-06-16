import 'dart:convert';

import 'package:StaffFlow/app/modules/Messagerie/models/User.Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart' as signalr;

import 'package:StaffFlow/app/constants/constant.dart';
import 'package:StaffFlow/app/modules/Messagerie/models/Conversation.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ConversationController.dart';
import 'package:StaffFlow/app/modules/Messagerie/views/chatPage.dart';
import 'package:StaffFlow/app/modules/Messagerie/service/ControllerHub.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final conversationController = Get.put(ConversationController());
  final Future<List<ConvHist>> _calculation1 = Future<List<ConvHist>>.delayed(
    const Duration(seconds: 0),
    () => ConversationController().getHistorique(),
  );
  final controllerHub = Get.put(ControllerHub());
  String url = "$URL/Files/getImage";
  final Future<List<Users>> _calculation = Future<List<Users>>.delayed(
    const Duration(seconds: 0),
    () => ControllerHub().getOnlineUsersLis(),
  );
  @override
  void initState() {
    super.initState();

    // if (signalr.HubConnectionState.Connected ==
    //     signalr.HubConnectionState.Connected) {
    //   controllerHub.getOnlineUsersInv();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 7,
        title: Text(
          "Discussions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Color(0xFFEEEEEE),
              child: IconButton(
                onPressed: () async {
                  // final prefs = await SharedPreferences.getInstance();
                  // final token = prefs.getString('personId');
                  // print(token);
                },
                icon: Icon(
                  Icons.mode_edit_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 3),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.69,
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Rechercher",
                    ),
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<ControllerHub>(
            init: ControllerHub(),
            builder: (value) {
              value.setX();

              return FutureBuilder<List<Users>>(
                future: _calculation,
                builder: (context, snapshot) {
                  if (ControllerHub.onlineUsers.length == 0) {
                    print(ControllerHub.onlineUsers.length);
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                      height: 120,
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: ControllerHub.onlineUsers.length,
                        itemBuilder: (context, index) {
                          final user = ControllerHub.onlineUsers[index];
                          return GestureDetector(
                            onTap: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final token = prefs.getString('token');
                              print(token);

                              final Map<String, dynamic> decodedToken =
                                  json.decode(
                                ascii.decode(
                                  base64.decode(
                                    base64.normalize(token.split(".")[1]),
                                  ),
                                ),
                              );

                              print(decodedToken);
                              final String sid = decodedToken[
                                  'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
                              print(sid);
                              int intFrom = int.parse(sid);

                              ConversationController().messages = [].obs;

                              print(user.id);
                              print(user.nom);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    user.nom,
                                    user.prenom,
                                    user.image,
                                    user.id,
                                    intFrom,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: CircleAvatar(
                                    radius: 35.0,
                                    backgroundColor: Colors.transparent,
                                    child: SizedBox(
                                      width: 60,
                                      height: 80,
                                      child: Stack(
                                        children: [
                                          ClipOval(
                                            child: Image.network(
                                                "$url/${user.image}"),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor:
                                                  (ControllerHub.nameOL)
                                                          .contains(user.nom)
                                                      ? Colors.green
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "${user.nom} ",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              );
            },
          ),
          GetBuilder<ConversationController>(
              init: ConversationController(),
              builder: (value) {
                return FutureBuilder<List<ConvHist>>(
                  future: _calculation1,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('');
                    } else if (snapshot.hasData) {
                      print(snapshot.data);

                      final conv = snapshot.data;
                      return Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: conv.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final token = prefs.getString('token');
                                  print(token);

                                  final Map<String, dynamic> decodedToken = json
                                      .decode(ascii.decode(base64.decode(base64
                                          .normalize(token.split(".")[1]))));

                                  print(decodedToken);
                                  final String sid = decodedToken[
                                      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid'];
                                  print(sid);
                                  int intFrom = int.parse(sid);
                                  ConversationController().messages = [].obs;
                                  print(conv[index].user);
                                  print(conv[index].idTo);
                                  print(conv[index].idFrom);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          conv[index].user.nom,
                                          conv[index].user.prenom,
                                          conv[index].user.image,
                                          (intFrom == conv[index].idTo)
                                              ? conv[index].idFrom
                                              : conv[index].idTo,
                                          intFrom)));
                                },
                                child: ListTile(
                                  leading: Flexible(
                                    child: CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.transparent,
                                      child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Stack(children: [
                                          ClipOval(
                                            child: Image.network(
                                                "$url/${conv[index].user.image}"),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: (ControllerHub
                                                          .nameOL)
                                                      .contains(
                                                          conv[index].user.nom)
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "${conv[index].user.nom} ${conv[index].user.prenom}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(conv[index].msg),
                                  trailing: Text(
                                    '${DateTime.now().difference(conv[index].timeStamp).inDays}j${(DateTime.now().difference(conv[index].timeStamp).inHours) % 24}h',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                ));
                          },
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
              }),
        ],
      ),
    );
  }
}
