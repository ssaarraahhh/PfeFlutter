import 'package:dronalms/app/models/EmployeInfo.dart';
import 'package:dronalms/app/models/employe.dart';
import 'package:dronalms/app/modules/Messagerie/views/messageriePrin.dart';
import 'package:dronalms/main.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:http/http.dart' as http;




class ControllerHub extends GetxController{
  List<Employe>  x=[];
  static List<Employe>  userData=[];
  static List<Object>  usersOn=[];
  String msg ;

  bool isAuthenticated = false;
  static List<String> nameOL = [] ;
  void setX()async{


    x = onlineUsers;

    if (MyHomePage.hubConnection.state == HubConnectionState.Connected) {
      ControllerHub().getOnlineUsersInv();
    }    getOnlineUsersLis();


    update();

  }
  static List<Employe>  onlineUsers = []  ;


 Future<void> authMe(EmployeInfo emp) async {
  try {
    await MyHomePage.hubConnection.invoke('authMe', args: [emp.toMap()]);
    print('Connection established');
  } catch (err) {
    print(err);
  }
}



  Future<String> getUserId(String userName, String password) async {
    final url = Uri.parse("https://10.0.2.2:7062/User/id?userName=$userName&password=$password");
    final response = await http.get(url);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personId', response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to get user ID.');
    }
  }


  void getOnlineUsersInv() async{
   await MyHomePage.hubConnection.invoke('getOnlineUsers').catchError((err) => print(err));
  }

  Future<List<Employe>> getOnlineUsersLis() async {
      MyHomePage.hubConnection.on('getOnlineUsersResponse', (arguments) {
       onlineUsers = List<Map<String, dynamic>>.from(arguments[0])
          .map((json) => Employe.fromJson(json))
          .toList();
       nameOL.clear();
       onlineUsers.forEach((e) {nameOL.add(e.nom);});
       print(nameOL);

    });

 return onlineUsers ;
 update();
  }


  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('personId');
    final List<Object> PersonId= [token.replaceAll('"', '')] ;
    await MyHomePage.hubConnection.invoke("logOut",args:PersonId )
        .catchError((err) => print(err));
  }




}



