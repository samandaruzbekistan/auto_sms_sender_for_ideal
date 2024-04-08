import 'dart:convert';

import 'package:auto_sms_sender_for_ideal/screens/home_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class SmsToAllScreen extends StatefulWidget {
  const SmsToAllScreen({Key? key}) : super(key: key);

  @override
  State<SmsToAllScreen> createState() => _SmsToAllScreenState();
}

class _SmsToAllScreenState extends State<SmsToAllScreen> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.none){
      var request = http.Request('GET', Uri.parse('${dotenv.env['GET_ALL_ACTIVE_USERS']}'));
      http.StreamedResponse response = await request.send();
      if(response.statusCode == 200){
        var jsonString = await response.stream.bytesToString();
        final data = json.decode(jsonString);
        print(data);
      }
      else{
        _apiError(context);
      }
    }
    else{
      _internetError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


_internetError(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Xatolik!",
    desc: "Internetga ulanmagansiz",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () =>Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

_apiError(context) {
  Alert(
    context: context,
    type: AlertType.warning,
    title: "Xatolik!",
    desc: "API da nosozlik",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () =>Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}