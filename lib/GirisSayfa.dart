import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminGiris.dart';
import 'package:yazlab2_proje2/KullaniciGiris.dart';
import 'package:yazlab2_proje2/AdminPanel.dart';

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
        home: GirisSayfasi(),

    );
  }
}


class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({Key? key}) : super(key: key);

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Hoş Geldiniz")
      ),
      body: Center(
        child:Row(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Kg()));
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
        )
      ),
    );
  }
}
