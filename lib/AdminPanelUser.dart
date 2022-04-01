import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/database/Kisilerdao.dart';

import 'database/Kisiler.dart';

class AdminPanel extends StatefulWidget {
  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<List<Kisiler>> tumKullanicilar() async {
    return await Kisilerdao().tumKullanicilar();
  }

  Future<void> guncelle(int id, String username, String email, String password) async {
    await Kisilerdao().kisiGuncelle(id, username, email, password, "user");
  }

  Future<void> sil(int id) async {
    await Kisilerdao().kisiSil(id);
  }

  Future<void> ekle(String username, String email, String password) async {
    await Kisilerdao().kisiEkle(username, email, password, "user");
  }

  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.7;

    final height1 = MediaQuery.of(context).size.height * 0.75;
    final height2 = MediaQuery.of(context).size.height * 0.25;
    final height3 = MediaQuery.of(context).size.height * 0.12;
    final height4 = MediaQuery.of(context).size.height * 0.06;
    final height5 = MediaQuery.of(context).size.height * 0.36;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Kullanıcı İşlemleri"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Kisiler>>(
        future: tumKullanicilar(),
        builder: (context, snapshot) {

          if(snapshot.hasData){
          var kisilerListesi = snapshot.data;

          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: SizedBox(
                        height: height1,
                        child: Container(
                          child: ListView.builder(
                            itemCount: kisilerListesi!.length,
                            itemBuilder: (context, index) {
                              var kisi = kisilerListesi[index];
                              print("Kisi username: ${kisi.userName}");

                              return Card(
                                child: ListTile(
                                  title: Text("${kisi.userName}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                      )),
                                  subtitle: Text("${kisi.email}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      )),
                                  trailing: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: PopupMenuButton(
                                      child: Icon(Icons.menu),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          "Sil                      ",
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                  WidgetSpan(
                                                      child:
                                                          Icon(Icons.delete)),
                                                ],
                                              ),
                                            )),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: "Güncelle           ",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .indigoAccent)),
                                                WidgetSpan(
                                                    child: Icon(Icons.refresh)),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            nameController.text = kisi.userName;
                                            emailController.text = kisi.email;
                                            passwordController.text =
                                                kisi.password;

                                            Future.delayed(
                                                const Duration(seconds: 0),
                                                () => showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        SingleChildScrollView(
                                                          child: Container(
                                                            child: AlertDialog(
                                                              title: Text(
                                                                "Kullanıcı Güncelleme Ekranı",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              backgroundColor:
                                                                  Colors
                                                                      .indigoAccent,
                                                              content: SizedBox(
                                                                height: height5,
                                                                width: width1,
                                                                child: Column(
                                                                  children: [
                                                                    Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: Colors.white,
                                                                              ),
                                                                        ),
                                                                        child: ozelTextField(
                                                                            color: Colors
                                                                                .yellow,
                                                                            icon: Icons
                                                                                .supervised_user_circle,
                                                                            tftctr:
                                                                                nameController,
                                                                            hintText:
                                                                                "Kullanıcı Adınız",
                                                                            label:
                                                                                "Kullanıcı Adı")),
                                                                    Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: Colors.white,
                                                                              ),
                                                                        ),
                                                                        child: ozelTextField(
                                                                            color: Colors
                                                                                .purpleAccent,
                                                                            icon: Icons
                                                                                .email,
                                                                            tftctr:
                                                                                emailController,
                                                                            hintText:
                                                                                "Email",
                                                                            label:
                                                                                "Email")),
                                                                    Theme(
                                                                        data: Theme.of(context)
                                                                            .copyWith(
                                                                          colorScheme: ThemeData()
                                                                              .colorScheme
                                                                              .copyWith(
                                                                                primary: Colors.white,
                                                                              ),
                                                                        ),
                                                                        child: ozelTextField(
                                                                            color: Colors
                                                                                .redAccent,
                                                                            icon: Icons
                                                                                .password,
                                                                            tftctr:
                                                                                passwordController,
                                                                            hintText:
                                                                                "Şifre",
                                                                            label:
                                                                                "Şifre"))
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets.all(0.0),
                                                                  child:
                                                                      TextButton(
                                                                    child: Text("İptal", style: TextStyle(color: Colors.white),),
                                                                    onPressed: () {
                                                                      nameController.text = "";
                                                                      emailController.text = "";
                                                                      passwordController.text = "";
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  child: Text(
                                                                    "Güncelle",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed: () async{
                                                                    await guncelle(kisi.kisi_id, nameController.text, emailController.text, passwordController.text);
                                                                    setState(() {
                                                                      nameController.text = "";
                                                                      passwordController.text = "";
                                                                      emailController.text = "";

                                                                      Navigator.pop(context);
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )));
                                          },
                                        )
                                      ],
                                      onCanceled: () {
                                        print("Seçim yapılmadı");
                                      },
                                      onSelected: (menuItemValue) {
                                        if (menuItemValue == 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "Silmek istediğinizi emin misiniz ?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            backgroundColor: Colors.indigo,
                                            duration: Duration(seconds: 4),
                                            action: SnackBarAction(
                                              label: "Evet",
                                              textColor: Colors.white,
                                              onPressed: () async {

                                                await sil(kisi.kisi_id);
                                                setState(() {
                                                  kisilerListesi.removeAt(index);
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Veri başarıyla silindi",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              },
                                            ),
                                          ));


                                        }
                                      },
                                    ),
                                  ),
                                ),
                                color: Colors.blueGrey,
                              );
                            },
                          ),
                        )),
                  ),
                  SizedBox(
                    height: height3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 3.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          child: AlertDialog(
                                            title: Text(
                                              "Kullanıcı Ekleme Ekranı",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            backgroundColor:
                                                Colors.indigoAccent,
                                            content: SizedBox(
                                              height: height5,
                                              width: width1,
                                              child: Column(
                                                children: [
                                                  Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme: ThemeData()
                                                            .colorScheme
                                                            .copyWith(
                                                              primary:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      child: ozelTextField(
                                                          color: Colors.yellow,
                                                          icon: Icons
                                                              .supervised_user_circle,
                                                          tftctr:
                                                              nameController,
                                                          hintText:
                                                              "Kullanıcı Adınız",
                                                          label:
                                                              "Kullanıcı Adı")),
                                                  Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme: ThemeData()
                                                            .colorScheme
                                                            .copyWith(
                                                              primary:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      child: ozelTextField(
                                                          color: Colors
                                                              .purpleAccent,
                                                          icon: Icons.email,
                                                          tftctr:
                                                              emailController,
                                                          hintText: "Email",
                                                          label: "Email")),
                                                  Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme: ThemeData()
                                                            .colorScheme
                                                            .copyWith(
                                                              primary:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                      child: ozelTextField(
                                                          color:
                                                              Colors.redAccent,
                                                          icon: Icons.password,
                                                          tftctr:
                                                              passwordController,
                                                          hintText: "Şifre",
                                                          label: "Şifre",
                                                          obsureText: true))
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: TextButton(
                                                  child: Text(
                                                    "İptal",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "Kayıt et",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                onPressed: () async {
                                                  await ekle(
                                                      nameController.text,
                                                      emailController.text,
                                                      passwordController.text);
                                                  nameController.text = "";
                                                  passwordController.text = "";
                                                  emailController.text = "";

                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Image.asset("resimler/adam_ekle.png"),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(20),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
          else{
            return CircularProgressIndicator();
          }
  }
      ),
    );


  }
}

Widget ozelTextField({
  color,
  icon,
  tftctr,
  hintText,
  label,
  obsureText = false,
}) {
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
      TextField(
        controller: tftctr,
        obscureText: obsureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: color,
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
        height: 10,
      )
    ],
  );
}
