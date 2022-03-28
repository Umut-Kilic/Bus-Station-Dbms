
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

    CollectionReference userRef=_firestore.collection('Kisiler');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading:
        IconButton( onPressed: (){
          Navigator.pop(context);
        },icon:Icon(Icons.arrow_back_ios,size: 20,color: Colors.black,)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text ("Hoş Geldin", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 20,),
                        Text("Buradan sisteme Kayıt olabilirsin",style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                        ),),
                        SizedBox(height: 30,)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40
                      ),
                      child: Column(
                        children: [
                          ozelTextField(icon:Icons.supervised_user_circle,tftctr:nameController,hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı"),
                          ozelTextField(icon:Icons.email,tftctr:emailController,hintText: "Email",label: "Email"),
                          ozelTextField(icon:Icons.password,tftctr:passwordController,hintText: "Şifre",label: "Şifre",obsureText: true)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3,left: 3),

                        child:  FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                          ),
                          color: Colors.redAccent,
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
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              'Kayıt Ol',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget ozelTextField({icon,tftctr,hintText,label,obsureText = false,}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style:TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
      ),),
      SizedBox(height: 5,),
      TextField(
        controller: tftctr,
        obscureText: obsureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey)
          ),
        ),
      ),
      SizedBox(height: 30,)

    ],
  );
}


