import 'package:finger_print_test/fingerprint_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
FingerPrintManager fingerPrintManager=FingerPrintManager();
class LoginSc extends StatefulWidget {
  const LoginSc({Key? key}) : super(key: key);

  @override
  State<LoginSc> createState() => _LoginScState();
}

class _LoginScState extends State<LoginSc> {
  bool canUseFingerPrint=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async{
    canUseFingerPrint=await fingerPrintManager.canUseFingerPrint();
    setState(() {
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen"),),
      body: ListView(children: [
        SizedBox(
          height: 70,
        ),
        buildFieldEmail(context),
        SizedBox(
          height: 20,
        ),
        buildFeildPassword(context),
        SizedBox(
          height: 80,
        ),
        buildLoginBtn(),
        SizedBox(
          height: 50,
        ),
        if(canUseFingerPrint)
        IconButton(onPressed: () {
fingerPrintManager.login(context, emailController.text.trim(), password.text, false);
        }, icon: Icon(Icons.fingerprint,color: Colors.blue,size: 50,))

      ],),
    );
  }

  Center buildLoginBtn() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: 240,
          height: 40,
          child: ElevatedButton(
              child: Text("login",
                style: TextStyle(
                    color: Colors.white
                ),),
              onPressed: () {
                fingerPrintManager.login(context, emailController.text.trim(), password.text, true);
              }),
        ),
      ),
    );
  }
  
  Padding buildFieldEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle( fontSize: 20),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            hintText: "email"),
      ),
    );
  }

  Center buildLoginText(BuildContext context) {
    return Center(
      child: Text(
        "login",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding buildFeildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: password,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        style: TextStyle( fontSize: 20),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          hintText: "password",

        ),
      ),
    );
  }
}
