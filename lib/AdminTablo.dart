import 'package:flutter/material.dart';

class AdminTablo extends StatefulWidget {

  @override
  State<AdminTablo> createState() => _AdminTabloState();
}

class _AdminTabloState extends State<AdminTablo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Tablo İşlemleri",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green,

      ),
      body: Center(

      ),
    );
  }
}
