import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Image.asset('assets/logo.png'), width: MediaQuery.of(context).size.width*0.8),
            SizedBox(height: 30,),
            Text("SMS yuborish dasturi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFFF7624),),),
            SizedBox(height: 30,),
            Container(width: MediaQuery.of(context).size.width*0.8, child: TextFormField(
              controller: loginController,
              decoration: InputDecoration(
                labelText: "Login",
                suffixIcon: Icon(Icons.person),
              ),
            ),),
            SizedBox(height: 30,),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Parol",
                  suffixIcon: Icon(Icons.lock),
                ),
              ),),
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
                  if(loginController.text == "nargiza" && passwordController.text == "4086"){
                    print("gee");
                  }
                },
                child: Text(
                  "KIRISH",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
