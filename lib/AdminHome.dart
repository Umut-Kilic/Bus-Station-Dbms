import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminMap.dart';
import 'package:yazlab2_proje2/AdminPanelDurak.dart';
import 'package:yazlab2_proje2/database/Duraklardao.dart';

import 'AdminPanelUser.dart';
import 'database/DurakKisi.dart';
import 'database/DurakKisidao.dart';
import 'database/Kisilerdao.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Future<void> goster() async {
    var liste = await DurakKisidao().tumDurakKisi();
    var duraklar = await Duraklardao().tumDuraklar();
    var kisiler = await Kisilerdao().tumKisiler();

    print("Liste uzunlugu : ${liste.length}");
    print("kisiler uzunlugu : ${kisiler.length}");
    print("duraklar uzunlugu : ${duraklar.length}");

    for (DurakKisi dk in liste) {
      print(
          "Durak ad : ${dk.durak.durak_ad} duraktaki kişinin username : ${dk.kisi.userName}");
    }
  }

  Future<void> ekle() async {
    Kisilerdao().kisiEkle("sfsafsf", "safsfsaf", "asfsfsaf", "user");
  }

  @override
  void initState() {
    super.initState();
    goster();
  }

  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.60;

    final height1 = MediaQuery.of(context).size.height * 0.18;
    final height2 = MediaQuery.of(context).size.height * 0.20;
    final height3 = MediaQuery.of(context).size.height * 0.20;

    return WillPopScope(onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red,
          title: Padding(
            padding: EdgeInsets.only(left: 25),
            child:Text(
            "Admin Paneli",
            style: TextStyle(color: Colors.white,fontSize: 23),
          ),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Çıkış Yap",
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
              ),)

          ],
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => AdminPanel()));
                        },
                        child: Text("Kullanıcı İşlemleri"))
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminPanelDurak()));
                        },
                        child: Text("Durak İşlemleri")),
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
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminMap()));
                        }, child: Text("Otobüs İşlemleri")),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    ) ;

  }
}
