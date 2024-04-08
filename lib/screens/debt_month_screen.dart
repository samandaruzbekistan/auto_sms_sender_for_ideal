import 'package:auto_sms_sender_for_ideal/screens/send_by_debt_month.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:auto_sms_sender_for_ideal/screens/home_screen.dart';
import 'package:background_sms/background_sms.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DebtMonthScreen extends StatefulWidget {
  const DebtMonthScreen({Key? key}) : super(key: key);

  @override
  State<DebtMonthScreen> createState() => _DebtMonthScreenState();
}

class _DebtMonthScreenState extends State<DebtMonthScreen> {
  bool sendDirect = false;
  bool _isLoading = true;
  int sended2 = 0;
  int notSend2 = 0;
  bool _permissionStatus = false;
  TextEditingController _controllerApi = TextEditingController();
  TextEditingController _controllerMessage = TextEditingController();
  List month = [];

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
    getData();
  }

  List<Map<String, dynamic>> ordersData = [];

  getData() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if(connectivityResult != ConnectivityResult.none){
      var request = http.Request('GET', Uri.parse('${dotenv.env['DEBT_MONTH_URL']}'));
      http.StreamedResponse response = await request.send();
      if(response.statusCode == 200){
        var jsonString = await response.stream.bytesToString();
        final data = json.decode(jsonString);
        setState(() {
          month = data;
          _isLoading = false;
        });
        print(month[0]);
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
          'Qarzdorlik oyini tanlang:',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF7624),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()) :  SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 15,),
              _isLoading ? Container() : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: month.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  var monthString = "${month[index]['month']}".split("-");
                  // return Text(month[index]['month']);
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF7624),
                          padding: EdgeInsets.symmetric(vertical: width*0.02),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SmsToByMonthScreen(month: "${month[index]['month']}")),
                          );
                        },
                        child: Text(
                          formatDate(monthString[0], monthString[1]),
                          style: TextStyle(color: Colors.white, fontSize: width*0.05),
                        )),
                  );
                }
              ),
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