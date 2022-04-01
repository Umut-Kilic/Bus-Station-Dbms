
import 'package:flutter/material.dart';

import 'database/Kisilerdao.dart';



class KayitOl extends StatefulWidget {
  const KayitOl({Key? key}) : super(key: key);

  @override
  State<KayitOl> createState() => _KayitOlState();
}

class _KayitOlState extends State<KayitOl> {
  Future<void> ekle(String userName, String email, String password, String role) async {
    Kisilerdao().kisiEkle(userName, email, password, role);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
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
                          Text(
                            "Hoş Geldin",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Buradan sisteme Kayıt olabilirsin",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            ozelTextField(
                                icon: Icons.supervised_user_circle,
                                tftctr: nameController,
                                degisken: "Kullanıcı Adını",
                                hintText: "Kullanıcı Adınız",
                                label: "Kullanıcı Adı"),
                            ozelEmailTextField(
                                icon: Icons.email,
                                tftctr: emailController,
                                degisken: "Email",
                                hintText: "Email",
                                label: "Email"),
                            ozelTextField(
                                icon: Icons.password,
                                tftctr: passwordController,
                                degisken: "Şifre",
                                hintText: "Şifre",
                                label: "Şifre",
                                obsureText: true)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                            ),
                            color: Colors.redAccent,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool b = await Kisilerdao()
                                    .emailCheck(emailController.text) as bool;
                                String icerik = "";
                                if (passwordController.text.length < 6) {
                                  String yazi =
                                      "Lütfen daha güçlü şifre giriniz";
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 1),
                                          backgroundColor: Colors.white,
                                          content: Text(
                                            yazi,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )));
                                } else {
                                  if (b) {
                                    icerik = "Aramıza Hoşgeldin : " +
                                        nameController.text;
                                    await Kisilerdao().kisiEkle(
                                        nameController.text,
                                        emailController.text,
                                        passwordController.text,
                                        "user");
                                    await Kisilerdao().tumKisiler();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 1),
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              icerik.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )));
                                    Navigator.pop(context);
                                    nameController.text = "";
                                    passwordController.text = "";
                                    emailController.text = "";
                                  } else {
                                    icerik =
                                        "Böyle bir email adresi sistemde bulunmaktadır";
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                            backgroundColor: Colors.white,
                                            content: Text(
                                              icerik.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            )));
                                  }
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
}

Widget ozelTextField({
  icon,
  tftctr,
  degisken,
  hintText,
  label,
  obsureText = false,
}) {
  String text1 = tftctr.text;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        controller: tftctr,
        obscureText: obsureText,
        validator: (text1) {
          if (text1!.isEmpty) {
            return "Lütfen bir $degisken yazın";
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      SizedBox(
        height: 30,
      )
    ],
  );
}

bool validateEmail(String? email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email!);
}

Widget ozelEmailTextField({
  icon,
  tftctr,
  degisken,
  hintText,
  label,
  obsureText = false,
}) {
  String text1 = tftctr.text;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        controller: tftctr,
        obscureText: obsureText,
        validator: (text1) {
          if(text1!.isEmpty || text1==null){
            return 'Lütfen email adresini doğru giriniz';
          }
          else{
            if( !validateEmail(text1)){
              return 'Lütfen geçerli bir email adresi giriniz';
            }
          }

        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      SizedBox(
        height: 30,
      )
    ],
  );
}
