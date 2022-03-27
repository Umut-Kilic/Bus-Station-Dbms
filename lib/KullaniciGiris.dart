
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/UserDisplay.dart';
import 'package:yazlab2_proje2/kayitOl.dart';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /*Future<void> getData() async {
    QuerySnapshot querySnapshot = await _firestore.collection("collection").getDocuments();
    var list = querySnapshot.documents;
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(a.documentID);
    }
  }*/

  getDocumentData(ad,sifre) async{
    CollectionReference userRef=_firestore.collection('Kisiler');
    QuerySnapshot querySnapshot = await userRef.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List liste=[];
    for(int i=0;i<_docData.length;i++){
      liste.add(_docData[i]);
    }
    bool usernameBool =false;
    bool passwordBool =false;

    for(int i=0;i<liste.length;i++){
      print(liste[i]['Name']+"    "+liste[i]['Password']);
      if(liste[i]['Name']==ad){
        usernameBool=true;
      }
      if(liste[i]['Password']==sifre){
        passwordBool=true;
      }
    }
    if(usernameBool && passwordBool){
      return true;
    }
    else{
      return false;
    }

  }

  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.7;
    final width2 = MediaQuery.of(context).size.width;
    final width3 = MediaQuery.of(context).size.width;
    final width4 = MediaQuery.of(context).size.width;
    final height1 = MediaQuery.of(context).size.height * 0.1;
    final height2 = MediaQuery.of(context).size.height * 0.15;
    final height3 = MediaQuery.of(context).size.height * 0.05;
    final height4 = MediaQuery.of(context).size.height * 0.07;

    CollectionReference userRef=_firestore.collection('Kisiler');

    return Scaffold(
        appBar: AppBar(
          title: Text("Kullanıcı Giriş Sayfası"),
        ),
        body: Center(
          child: Flexible(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: width1, height: height1),
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
                        obscureText: true,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => KayitOl()));
                          nameController.text="";
                          passwordController.text="";
                        },
                        child: Text("Kayıt ol"),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: width1, height: height3),
                    SizedBox(
                      width: width1,
                      height: height4,
                      child: ElevatedButton(
                        onPressed: () async{

                          if(nameController.text==""){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(backgroundColor: Colors.white,content: Text("Lütfen isim alanını doldurunuz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                            );
                          }
                          else if(passwordController.text==""){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(backgroundColor: Colors.white,content: Text("Lütfen şifre alanını doldurunuz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                            );
                          }
                          else{
                            bool sonuc=await getDocumentData(nameController.text, passwordController.text);
                            if( sonuc){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UserDisplay()));
                              nameController.text="";
                              passwordController.text="";
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(backgroundColor: Colors.white,content: Text("Girdiğiniz bilgiler yanlıştır !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                              );

                            }
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
