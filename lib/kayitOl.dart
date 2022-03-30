
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
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

  final FirebaseAuth _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _message="";

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
            child: Form(
              key: _formKey,
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
                            ozelTextField(icon:Icons.supervised_user_circle,tftctr:nameController,degisken:"Kullanıcı Adını",hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı"),
                            ozelTextField(icon:Icons.email,tftctr:emailController,degisken:"Email",hintText: "Email",label: "Email"),
                            ozelTextField(icon:Icons.password,tftctr:passwordController,degisken:"Şifre",hintText: "Şifre",label: "Şifre",obsureText: true)
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
                              if(_formKey.currentState!.validate()){
                                String icerik=await _register();
                                if(icerik=="true"){
                                  icerik="Aramıza Hoşgeldin : "+nameController.text;
                                  Map<String,dynamic> usersData={'Name':nameController.text,'Password':passwordController.text,'Email':emailController.text};
                                  await userRef.doc(nameController.text).set(usersData);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(duration:Duration(seconds: 1),backgroundColor: Colors.white,content: Text(icerik.toString(),style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                                  );
                                  Navigator.pop(context);
                                  nameController.text="";
                                  passwordController.text="";
                                  emailController.text="";
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(backgroundColor: Colors.white,content: Text(icerik.toString(),style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                                  );
                                }


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
      ),
    );
  }

  Future<String> _register() async{
    try{
      final UserCredential userCredential=await _auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      final User? user=userCredential.user;


      if(user!=null){

        return "true";

      }
      else{
        setState(() {
          _message="Hata meydana geldi";
        });
        return _message;
      }
    } on FirebaseAuthException catch(er){
      _message=er.message!;
      return _message;

    }
    catch(e){
      _message=e.toString();
      return _message;
    }

  }
}


Widget ozelTextField({icon,tftctr,degisken,hintText,label,obsureText = false,}){
  String text1=tftctr.text;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style:TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: Colors.black87
      ),),
      SizedBox(height: 5,),
      TextFormField(
        controller: tftctr,
        obscureText: obsureText,
        validator: (text1){
          if(text1!.isEmpty){
            return "Lütfen bir $degisken yazın";
          }
          return null;
        },
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


