import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  /*@protected
  @mustCallSuper
  void initState() {
    super.initState();

  }*/

 // GirisSayfasi(),


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Splash Screen',style: TextStyle(
            fontSize: 24,fontWeight: FontWeight.bold
          ),),
        ),
      ),
    );
  }
}
