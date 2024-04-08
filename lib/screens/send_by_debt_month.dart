import 'dart:convert';

import 'package:auto_sms_sender_for_ideal/screens/home_screen.dart';
import 'package:background_sms/background_sms.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SmsToByMonthScreen extends StatefulWidget {
  const SmsToByMonthScreen({Key? key, required this.month}) : super(key: key);

  final String month;

  @override
  State<SmsToByMonthScreen> createState() => _SmsToByMonthScreenState();
}

class _SmsToByMonthScreenState extends State<SmsToByMonthScreen> {
  bool sendDirect = false;
  bool _isLoading = false;
  int sended2 = 0;
  int notSend2 = 0;
  bool _permissionStatus = false;
  TextEditingController _controllerApi = TextEditingController();
  TextEditingController _controllerMessage = TextEditingController();
  List mont_data = [];

  Future<void> _requestPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      setState(() {
        _permissionStatus = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    mont_data = widget.month.split('-');
    // getData();
  }

  List<Map<String, dynamic>> ordersData = [];

  Future<void> fetchData(String url, String message) async {
    var status = await Permission.sms.status;
    setState(() {
      _isLoading = true;
    });
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.none){
      var request = http.Request('GET', Uri.parse('${dotenv.env['GET_USERS_BY_MONTH']}/${widget.month}'));
      http.StreamedResponse response = await request.send();
      if(response.statusCode == 200){
        var jsonString = await response.stream.bytesToString();
        final data = json.decode(jsonString);
        if(data.length == 0){
          setState(() {
            _isLoading = false;
          });
          _numbersError2(context);
          return;
        }else{
          int sendedCount = 0;
          int notSendCount = 0;
          // print(data[0]['student']['phone']);

          for (int i = 0; i < data.length; i++) {
            var result = await BackgroundSms.sendMessage(
              phoneNumber: "+${data[i]['student']['phone']}",
              message: message,
            );

            if (result == SmsStatus.sent) {
              sendedCount++;
            } else {
              notSendCount++;
            }

            if ((i + 1) % 20 == 0) {
              // If 20 SMS sent, wait for 10 seconds
              await Future.delayed(Duration(seconds: 10));
            }
          }

          setState(() {
            _isLoading = false;
          });

          _sendedAlert(context, sendedCount, notSendCount);
        }
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Auto SMS sender by Samandar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF7624),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.05,
              ),
              Image.asset("assets/sms.jpg", width: width*0.5,),
              SizedBox(
                height: height * 0.02,
              ),
              Text('${formatDate(mont_data[0], mont_data[1])}dan qarzdorlarga SMS yuborish', style: TextStyle(fontSize: 15, color: Colors.red),),
              SizedBox(
                height: height * 0.02
              ),
              TextField(
                controller: _controllerMessage,
                decoration: const InputDecoration(
                  labelText: "SMS matni",
                  suffixIcon: Icon(Icons.chat_bubble_outline),
                  border: OutlineInputBorder(),
                  helperMaxLines: 3,
                ),
                maxLines: 3,
                maxLength: 140,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              _permissionStatus
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: ElevatedButton(
                  onPressed: () async {
                    fetchData(
                        _controllerApi.text, _controllerMessage.text);
                  },
                  style: ElevatedButton.styleFrom(
                    // elevation: 20,
                    backgroundColor: Color(0xFFFF7624),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : Text(
                    "Yuborish",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.05),
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "SMS yuborish uchun\nqurilmada ruxsat berilmagan",
                    style: TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        await _requestPermission();
                      },
                      child: Text(
                        "Ruxsat berish",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              SizedBox(
                height: height * 0.2,
              ),
              Text("Dasturchi: Samandar Sariboyev", textAlign: TextAlign.center,),
              Text("Websayt: goldapps.uz", textAlign: TextAlign.center,),
              Text("Telegram: @Samandar_developer", textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(String year, String month){
  switch (month){
    case "01":
      return "${year} - yil Yanvar oyi";
    case "02":
      return "${year} - yil Fevral oyi";
    case "03":
      return "${year} - yil Mart oyi";
    case "04":
      return "${year} - yil Aprel oyi";
    case "05":
      return "${year} - yil May oyi";
    case "06":
      return "${year} - yil Iyun oyi";
    case "07":
      return "${year} - yil Iyul oyi";
    case "08":
      return "${year} - yil Avgust oyi";
    case "09":
      return "${year} - yil Sentabr oyi";
    case "10":
      return "${year} - yil Oktabr oyi";
    case "11":
      return "${year} - yil Noyabr oyi";
    case "12":
      return "${year} - yil Dekabr oyi";
  }

  return "";
}

_numbersError2(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "Raqamlar soni 0 ta",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

_permissionError2(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "SMS yuborish uchun qurilmada ruxsat berilmagan",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

_apiError2(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "API da nosozlik",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

_sendedAlert(context, int sended, int notSend) {
  Alert(
    context: context,
    type: AlertType.success,
    title: "Xabar yuborildi!",
    desc: "Yuborildi: ${sended}\nYuborilmadi: ${notSend}",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.black,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
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

_internetError2(context) {
  Alert(
    context: context,
    type: AlertType.error,
    title: "Xatolik!",
    desc: "Internetga ulanmagansiz",
    buttons: [
      DialogButton(
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        onPressed: () => Navigator.pop(context),
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