
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Kayit());
}


class Kayit extends StatelessWidget {

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
                return KayitOl();
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        )

    );
  }
}

class KayitOl extends StatefulWidget {
  const KayitOl({Key? key}) : super(key: key);

  @override
  State<KayitOl> createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {

  final _firestore=FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
          title: Text("Kullanıcı Kayıt Sayfası"),
        ),
        body: Center(
          child: Flexible(
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
                      controller: emailController,
                      keyboardType:TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blueGrey,
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                        hintText: "Please enter your Email adress",
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
                      onPressed: () async{
                        if(nameController.text==""){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.white,content: Text("Lütfen isim alanını doldurunuz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                          );
                        }
                        else if(emailController.text==""){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.white,content: Text("Lütfen email alanını doldurunuz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                          );
                        }
                        else if(!emailController.text.contains('@')){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.white,content: Text("Lütfen geçerli email adresi giriniz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                          );
                        }
                        else if(passwordController.text==""){
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.white,content: Text("Lütfen şifre alanını doldurunuz !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                          );
                        }
                        else{
                          Map<String,dynamic> usersData={'Name':nameController.text,'Password':passwordController.text,'Email':emailController.text};
                          await userRef.doc(nameController.text).set(usersData);
                          Navigator.pop(context);
                          nameController.text="";
                          passwordController.text="";
                          emailController.text="";
                        }
                        
                      },
                      child: Text("Kayıt ol",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
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
        ));
  }
}
