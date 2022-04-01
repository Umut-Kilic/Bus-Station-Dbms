
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/GirisSayfa.dart';
import 'package:yazlab2_proje2/UserDisplay.dart';
import 'package:yazlab2_proje2/kayitOl.dart';

import 'database/Kisiler.dart';
import 'database/Kisilerdao.dart';



class KullaniciGiris extends StatefulWidget {
  const KullaniciGiris({Key? key}) : super(key: key);

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {

  Future<void> kisileriGoster() async{
    var liste= await Kisilerdao().tumKisiler();

    for(Kisiler k in liste){
      print("Kisi id : ${k.kisi_id}\tKisi userName : ${k.userName}\tKisi email : ${k.email}\tKisi sifre : ${k.password}\tKisi rolu : ${k.role}");
    }
  }
/*
  Future<void> ekle() async{
    await Kisilerdao().kisiEkle("Sedat", 37);
  }
  Future<void> sil() async{
    await Kisilerdao().kisiSil( 3);
  }
  Future<void> guncelle() async{
    await Kisilerdao().kisiGuncelle(2,"Yeni Osman",99);
  }

  Future<void> kayitKontrol() async{
    int sonuc= await Kisilerdao().kayitKontrol("Ahmet");
    print("Veritabanında ahmet sayısı : $sonuc");
  }
  Future<void> kisiGetir() async{
    Kisiler kisi= await Kisilerdao().kisiGetir(1);
    print("Veritabanında gelen kişi bilgileri: ${kisi.kisi_id}  ${kisi.kisi_ad}  ${kisi.kisi_yas}");
  }

  Future<void> aranankisileriGoster() async{
    var liste= await Kisilerdao().kisiArama("t");

    for(Kisiler k in liste){
      print("Kisi id : ${k.kisi_id} \tKisi ad : ${k.kisi_ad} \tKisi yas : ${k.kisi_yas}");
    }
  }

  Future<void> rastgeleGetir() async{
    var liste= await Kisilerdao().rastgele2KisiGetir();

    for(Kisiler k in liste){
      print("Kisi id : ${k.kisi_id} \tKisi ad : ${k.kisi_ad} \tKisi yas : ${k.kisi_yas}");
    }
  }*/

  @override
  void initState() {
    super.initState();

    kisileriGoster();
    //ekle();
    //sil();
    //guncelle();
    //kayitKontrol();
    //kisiGetir();
    //aranankisileriGoster();
    //rastgeleGetir();
  }


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();



  Color mBackgroundColor = Color(0xFFFFFFFF);

  Color mPrimaryColor = Color(0xFFB98068);

  Color mPrimaryTextColor = Color(0xFF8C746A);

  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.7;
    final width2 = MediaQuery.of(context).size.width*0.5;
    final width3 = MediaQuery.of(context).size.width;
    final width4 = MediaQuery.of(context).size.width;
    final height1 = MediaQuery.of(context).size.height * 0.20;
    final height2 = MediaQuery.of(context).size.height * 0.15;
    final height3 = MediaQuery.of(context).size.height * 0.05;
    final height4 = MediaQuery.of(context).size.height * 0.07;


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
                MaterialPageRoute(builder: (context) => GirisSayfa()));
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
                  width: width2,
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

                   bool sonuc=await Kisilerdao().girisYap(nameController.text, passwordController.text);
                   print(sonuc);

                   if (sonuc) {
                     Navigator.push(context,
                         MaterialPageRoute(builder: (context) => UserDisplay()));
                     nameController.text = "";
                     passwordController.text = "";
                   }
                   else {
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
