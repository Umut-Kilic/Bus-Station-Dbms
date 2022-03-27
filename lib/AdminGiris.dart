import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminPanel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Ad());
}

class Ad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminGiris(),
    );
  }
}

class AdminGiris extends StatefulWidget {
  const AdminGiris({Key? key}) : super(key: key);

  @override
  State<AdminGiris> createState() => _AdminGirisState();
}

class _AdminGirisState extends State<AdminGiris> {
  final adminU = "Umut";
  final adminP = "Goksel";

  TextEditingController nameController = TextEditingController();
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
                          if(nameController.text==adminU && passwordController.text==adminP){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Admin()));
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
