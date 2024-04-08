import 'package:auto_sms_sender_for_ideal/screens/sms_to_all_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: Image.asset('assets/logo.png'), width: MediaQuery.of(context).size.width*0.8),
              SizedBox(height: 30,),
              Text("Tanlang:", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFFFF7624),),),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    // elevation: 20,
                    backgroundColor: Color(0xFFFF7624),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SmsToAllScreen()),
                    );
                  },
                  child: Text(
                    "BARCHAGA SMS YUBORISH",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width*0.8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    // elevation: 20,
                    backgroundColor: Color(0xFFFF7624),
                    minimumSize: const Size.fromHeight(60),
                  ),
                  onPressed: () {

                  },
                  child: Text(
                    "QARZDORLARGA SMS YUBORISH",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
