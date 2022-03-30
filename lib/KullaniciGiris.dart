import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/GirisSayfa.dart';
import 'package:yazlab2_proje2/UserDisplay.dart';
import 'package:yazlab2_proje2/kayitOl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Kg());
}

class Kg extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Beklenmeyen bir haa ortaya çıktı"));
              } else if (snapshot.hasData) {
                return KullaniciGiris();
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class KullaniciGiris extends StatefulWidget {
  const KullaniciGiris({Key? key}) : super(key: key);

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {
  final _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  getDocumentData(ad, sifre) async {
    CollectionReference userRef = _firestore.collection('Kisiler');
    QuerySnapshot querySnapshot = await userRef.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List liste = [];
    for (int i = 0; i < _docData.length; i++) {
      liste.add(_docData[i]);
    }
    bool usernameBool = false;
    bool passwordBool = false;

    for (int i = 0; i < liste.length; i++) {
      print(liste[i]['Name'] + "    " + liste[i]['Password']);
      if (liste[i]['Name'] == ad) {
        usernameBool = true;
      }
      if (liste[i]['Password'] == sifre) {
        passwordBool = true;
      }
    }
    if (usernameBool && passwordBool) {
      return true;
    } else {
      return false;
    }
  }

  Color mBackgroundColor = Color(0xFFFFFFFF);

  Color mPrimaryColor = Color(0xFFB98068);

  Color mPrimaryTextColor = Color(0xFF8C746A);

  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.7;
    final width2 = MediaQuery.of(context).size.width;
    final width3 = MediaQuery.of(context).size.width;
    final width4 = MediaQuery.of(context).size.width;
    final height1 = MediaQuery.of(context).size.height * 0.20;
    final height2 = MediaQuery.of(context).size.height * 0.15;
    final height3 = MediaQuery.of(context).size.height * 0.05;
    final height4 = MediaQuery.of(context).size.height * 0.07;

    CollectionReference userRef = _firestore.collection('Kisiler');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mBackgroundColor,
        title: Text(
          "Kullanıcı Giriş Sayfası",
          style: TextStyle(color: mPrimaryTextColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: mPrimaryTextColor,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AdminUserSayfasi()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                  height: height1,
                  child: FittedBox(
                    child: Image.asset("resimler/login.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 20, right: 20),
              child: Text(
                'Tekrardan Hoş Geldin!',
                style: TextStyle(
                  color: mPrimaryTextColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ozelTextFormField(
                        icon: Icons.supervised_user_circle,
                        tftctr: nameController,
                        degisken: "Kullanıcı Adını",
                        hintText: "Kullanıcı Adınız",
                        label: "Kullanıcı Adı"),
                    SizedBox(
                      height: 16,
                    ),
                    ozelTextFormField(
                        icon: Icons.password,
                        tftctr: passwordController,
                        degisken: "Şifre",
                        hintText: "Şifre",
                        label: "Şifre",
                        obsureText: true)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerRight,
              child: Text(
                'Şifreni mi unuttun?',
                style: TextStyle(color: mPrimaryColor),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
                color: mPrimaryColor,
                onPressed: () async {
                 if(_formKey.currentState!.validate()){
                   bool sonuc = await getDocumentData(nameController.text, passwordController.text);
                   if (sonuc) {
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) => UserDisplay()));
                     nameController.text = "";
                     passwordController.text = "";
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         backgroundColor: Colors.white,
                         content: Text(
                           "Girdiğiniz bilgiler yanlıştır !",
                           style: TextStyle(
                               fontSize: 20,
                               color: Colors.red,
                               fontWeight: FontWeight.bold),
                         )));
                     nameController.text = "";
                     passwordController.text = "";
                   }
                 }

                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    'Giriş Yap',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 16,
              ),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(style: TextStyle(color: Colors.grey), children: [
                  TextSpan(text: 'Hesabın Yok mu? '),
                  TextSpan(
                    text: 'Kayıt Ol',
                    style: TextStyle(
                      color: mPrimaryColor,
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => KayitOl()));
                        nameController.text = "";
                        passwordController.text = "";
                      },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ozelTextFormField({icon, tftctr, degisken, hintText, label, obsureText = false,}) {
    String text1 = degisken;
    return TextFormField(
      controller: tftctr,
      cursorColor: Colors.grey,
      obscureText: obsureText,
      validator: (text1) {
        if (text1!.isEmpty) {
          return "Lütfen bir $degisken yazın";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mPrimaryColor,
          width: 2,
        )),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: mPrimaryColor,
          width: 2,
        )),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        )),
      ),
    );
  }
}
