import 'dart:convert';
import 'dart:io';
import 'package:dronalms/app/constants/constant.dart';
import 'package:http/http.dart' as http;

class ApiFile {
  String apiUrl = '$URL/Files';

Future<String> addFile(String f) async {
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  request.files.add(await http.MultipartFile.fromPath('image', f));
  var response = await request.send();

  if (response.statusCode == 200) {
    print(response.statusCode);
    String responseString = await response.stream.bytesToString();
    Map<String, dynamic> jsonResponse = json.decode(responseString);
    String fileName = jsonResponse['file']; // Assuming the response contains a key 'fileName' with the file name
    print(fileName);
    return fileName;
  } else {
    throw Exception('Failed');
  }
}

}
