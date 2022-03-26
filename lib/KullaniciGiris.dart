
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Kg());
}


class Kg extends StatelessWidget {

  final Future<FirebaseApp> _initialization=Firebase.initializeApp();


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context,snapshot){
              if(snapshot.hasError){
                return Center(child: Text("Beklenmeyen bir haa ortaya çıktı"));
              }
              else if(snapshot.hasData){
                return KullaniciGiris();
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        )

    );
  }
}
class KullaniciGiris extends StatefulWidget {
  const KullaniciGiris({Key? key}) : super(key: key);

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {

  final _firestore=FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    CollectionReference userRef=_firestore.collection('Kisiler');

    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Giriş Sayfası"),
        ),
        body: Center(
          child: Flexible(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: width1, height: height2),
                  SizedBox(
                    height: height2,
                    width: width1,
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey,
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                        hintText: "Please enter your admin username",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          new BorderSide(color: Colors.green, width: 3.0),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height2,
                    width: width1,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey,
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                        hintText: "Please enter your admin password",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          new BorderSide(color: Colors.green, width: 3.0),
                          borderRadius: new BorderRadius.circular(25.7),
                        ),
                      ),
                    ),

                  ),
                  SizedBox(width: width1, height: height3),
                  SizedBox(
                    width: width1,
                    height: height4,
                    child: ElevatedButton(
                      onPressed: (){
                        if(nameController.text==adminU && passwordController.text==adminP){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));

                        }
                        else{

                        }
                      },
                      child: Text("Giriş Yap"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          )
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
