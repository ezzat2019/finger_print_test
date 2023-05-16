import 'package:finger_print_test/login_sc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeSc extends StatefulWidget {
  final String email;
  final String pass;
  final String type;
  const HomeSc({required this.email,required this.pass,required this.type,Key? key}) : super(key: key);

  @override
  State<HomeSc> createState() => _LoginScState();
}

class _LoginScState extends State<HomeSc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"),),
      body: Padding(
        padding: const EdgeInsets.all(100),
        child: Column(

          children: [
          Text("Login type",style: TextStyle(
            fontSize: 20
          ),),
          Text(widget.type,style: TextStyle(
              fontSize: 25
          ),),
          SizedBox(height: 25,),
          Text("email",style: TextStyle(
              fontSize: 18
          ),),
          Text(widget.email,style: TextStyle(
              fontSize: 22,),),
        SizedBox(height: 25,),
        Text("password",style: TextStyle(
            fontSize: 18
        ),),
        Text(widget.pass,style: TextStyle(
          fontSize: 22,),)


        ],),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        fingerPrintManager.logout(context);
      },child: Text("Logout"),),
    );
  }
}
