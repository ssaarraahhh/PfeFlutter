// import 'package:alert/alert.dart';
// import 'package:chat_bubbles/bubbles/bubble_normal.dart';

// import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:dronalms/app/modules/Messagerie/models/Chat.dart';
import 'package:dronalms/app/modules/Messagerie/service/ChatController.dart';
import 'package:dronalms/app/modules/Messagerie/service/ConversationController.dart';
import 'package:dronalms/app/modules/Messagerie/views/buuble.dart';
import 'package:dronalms/app/modules/Messagerie/views/messagebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:test01/Controller/ChatController.dart';
// import 'package:test01/Controller/ConversationController.dart';
// import 'package:test01/Model/NotificationModel.dart';
// import 'package:test01/main.dart';

// import '../Controller/Notif.dart';
import 'HomeScreen.dart';

class ChatPage extends StatefulWidget {

  String name;

  int id;
  int indx = 0;

  int intFrom;


  ChatPage(this.name, this.id, this.intFrom );

  @override
  State<ChatPage> createState() => _ChatPageState();

}

class _ChatPageState extends State<ChatPage> {
  // final conversationController = Get.put(ConversationController());
  final ScrollController _scrollController = ScrollController();





  @override
  void initState() {
    super.initState();
    // MyHomePage.hubConnection.on("sendMsgResponse", conversationController.onReceiveMessage);
  print(    "initial liste =${ConversationController().messages.toString()}");
  }

  Future<void> sendMessage(String Message) async {
    print("this ddddd");
    final prefs =
    await SharedPreferences.getInstance();
    final connId= prefs.getString('ConnId');
    print ("hatha houwa il id ${connId}");

    // await MyHomePage.hubConnection.invoke("sendMsg",
        // args: <Object>[connId, Message]).catchError((err) {
      // print(err);
    // });
    print("this message is : ${Message} send to ${widget.id.toString()}");
  }

  @override
  Widget build(BuildContext context) {

    final now = new DateTime.now();
    // final chatController = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.deepPurple,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              child: SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/user.jpg',
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 2,
                ),
                const Text('EnLigne',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 16,
                        fontWeight: FontWeight.w400))
              ],
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                // Alert(
                //     message:
                //         "Votre conversation avec ${widget.name} est Supprimer");
                // await ConversationController()
                //     .deleteConversation(widget.id, widget.intFrom);
                // setState(() {
                // });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.purple,
              )),
          IconButton(
              onPressed: () async{
                print('aya 3ad');
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn);
                });
              },
              icon: Icon(
              Icons.call,
                color: Colors.purple,
              ))
        ],
      ),
      body: Stack(
        children: [
          GetBuilder<ChatController>(
            init: ChatController(),
            builder: (controller) => StreamBuilder<List<ChatModel>>(
              stream: controller.getAllNotification(widget.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text(""));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Unknown error');
                }
                final messages = snapshot.data;
                return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(


                            padding: EdgeInsets.all(10),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),

                            itemCount: messages.length,
                            itemBuilder: (context,  index)
                            { widget.indx=index;
                              return Stack(

                                children: [
                                  BubbleNormal(
                                    text: messages[index].msg,
                                    isSender:
                                    (widget.intFrom == messages[index].idTo)
                                        ? false
                                        : true,
                                    color:
                                    (widget.intFrom == messages[index].idTo)
                                        ? Colors.grey.shade200
                                        : Color(0xFF1B97F3),
                                    tail: true,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color:
                                      (widget.intFrom == messages[index].idTo)
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }
                          ),
                          // tyuiop

                          // rtyuio
                          ( ConversationController().messages ==null) ? Text("") :

                          GetBuilder<ConversationController>(
                              init: ConversationController(),
                              builder: (value) {
                                return  Obx(() =>
                                    ListView.builder(

                                        padding: EdgeInsets.all(10),
                                        shrinkWrap: true,
                                        controller: _scrollController ,
                                        physics: const ScrollPhysics(),
                                        itemCount: ConversationController().messages.length,
                                        itemBuilder: (context,  index)
                                        { widget.indx=index;
                                        return Stack(

                                          children: [
                                            BubbleNormal(
                                              text: ConversationController().messages[index],
                                              isSender:false,
                                              color:Colors.grey.shade200,

                                              tail: true,
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                                color:Colors.black
                                                    ,
                                              ),
                                            ),
                                          ],
                                        );
                                        }
                                    ),);

                              }),

                          SizedBox(
                            height: 60,
                          )
                        ],
                      ),
                    ));
              },
            ),
          ),
          MessageBar(
            onSend: (mes) async {
              ChatModel data;

              data = ChatModel(
                idFrom: widget.intFrom,
                idTo: widget.id,
                msg: mes,
                timeStamp: now,
              );
              await sendMessage(mes);
              await ChatController().createChat(data);

              setState(() {
                ConversationController().messages=[].obs ;

              });
            },

          ),
        ],
      ),
    );
  }
}
