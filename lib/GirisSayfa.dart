import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:yazlab2_proje2/AdminGiris.dart';
import 'package:yazlab2_proje2/KullaniciGiris.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Giris());
}


class Giris extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GirisSayfa(),

    );
  }
}


class GirisSayfa extends StatefulWidget {
  const GirisSayfa({Key? key}) : super(key: key);

  @override
  State<GirisSayfa> createState() => _GirisSayfaState();
}

class _GirisSayfaState extends State<GirisSayfa> {


  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.45;

    final height1 = MediaQuery.of(context).size.height * 0.25;
    final height2 = MediaQuery.of(context).size.height * 0.10;

    return Scaffold(
      appBar: AppBar(
          title: Text("Hoş Geldiniz",style: TextStyle(fontSize: 27),),
        centerTitle: true,
      ),
      body: Column(

        children: [
          Padding(
            padding: const EdgeInsets.only(top:70.0),
            child: SizedBox(
              height: height1,
              width: width1,
              child: FittedBox(

                child:Image.asset("resimler/kocaeli.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:35.0),
            child: Text("E-KOUBÜS",style: TextStyle(
              color: Colors.green,
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),),
          ),
          SizedBox(
            height: height2,
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminGiris()));
                    },
                    child: Text("Admin Giriş",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary:Colors.red,

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KullaniciGiris()));
                    },
                    child: Text("Kullanıcı Giriş",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24
                      ),
                    ),
                    style:ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ) ,
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
