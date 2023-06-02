import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/modules/Messagerie/models/Conversation.dart';
import 'package:dronalms/app/modules/Messagerie/service/ControllerHub.dart';
import 'package:dronalms/app/modules/Messagerie/service/ConversationController.dart';
import 'package:dronalms/app/modules/Messagerie/views/chatPage.dart';
import 'package:dronalms/app/modules/Messagerie/views/messageriePrin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/hub_connection.dart';

class homePage extends StatefulWidget {
  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final conversationController = Get.put(ConversationController());

  final controllerHub = Get.put(ControllerHub());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ControllerHub().getOnlineUsersLis();
    if (MyHomePage.hubConnection.state == HubConnectionState.Connected) {
      ControllerHub().getOnlineUsersInv();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<Employe>> _calculation = Future<List<Employe>>.delayed(
      const Duration(seconds: 3),
      () => ControllerHub().getOnlineUsersLis(),
    );
    final Future<List<ConvHist>> _calculation1 = Future<List<ConvHist>>.delayed(
      const Duration(seconds: 3),
      () => ConversationController().getHistorique(),
    );
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 7,
        title: Text(
          "Discussions",
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
                    final prefs = await SharedPreferences.getInstance();
                    final token = prefs.getString('personId');
                    print(token);
                  },
                  icon: Icon(
                    Icons.mode_edit_rounded,
                    color: Colors.black,
                  )),
            ),
          )
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
            decoration: const BoxDecoration(
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
                    )),
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

                return FutureBuilder<List<Employe>>(
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
                                final token = prefs.getString('personId');

                                //await prefs.setString('ConnId', user.connId);

                                ConversationController().messages = [].obs;

                                int intFrom = int.parse(token);
                                print(user.id);
                                print(user.nom);
                              //  print("print this conn id ${user.connId}");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(user.nom, user.id, intFrom)));
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
                                        child: Stack(children: [
                                          ClipOval(
                                            child: Image.asset(
                                              'assets/images/user.jpg',
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: (ControllerHub
                                                          .onlineUsers[index]
                                                          .nom)
                                                      .contains(user.nom)
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      user.nom,
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
              }),
          GetBuilder<ConversationController>(
              init: ConversationController(),
              builder: (value) {
                return FutureBuilder<List<ConvHist>>(
                  future: _calculation1,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('');
                    } else if (snapshot.hasData) {
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
                                  final token = prefs.getString('personId');
                                  int intFrom = int.parse(token);
                                  ConversationController().messages = [].obs;

                                  print(conv[index].idTo);
                                  print(conv[index].idFrom);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                          conv[index].user.name,
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
                                            child: Image.asset(
                                              'assets/images/user.jpg',
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              radius: 6,
                                              backgroundColor: (ControllerHub
                                                          .nameOL)
                                                      .contains(
                                                          conv[index].user.name)
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    conv[index].user.name,
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
