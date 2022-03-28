import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminPanelDurak.dart';

import 'AdminPanelUser.dart';


class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.60;


    final height1 = MediaQuery.of(context).size.height * 0.18;
    final height2 = MediaQuery.of(context).size.height * 0.20;
    final height3 = MediaQuery.of(context).size.height * 0.20;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          "Admin Paneli",
          style: TextStyle(color: Colors.red),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(

            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: width1,
                      height: height1,
                      child: FittedBox(
                        child: Image.asset("resimler/user.gif"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin()));

                      }, child: Text("Kullanıcı İşlemleri"))
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: width1,
                      height: height1,
                      child: FittedBox(
                        child: Image.asset("resimler/buss.gif"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPanelDurak()));
                      }, child: Text("Durak İşlemleri")
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      width: width1,
                      height: height1,
                      child: FittedBox(
                        child: Image.asset("resimler/bus.gif"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {}, child: Text("Otobüs İşlemleri")
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
