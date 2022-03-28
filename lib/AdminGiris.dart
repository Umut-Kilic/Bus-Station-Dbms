import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminHome.dart';
import 'package:yazlab2_proje2/AdminPanelUser.dart';

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
    final width4 = MediaQuery.of(context).size.width;

    final height1 = MediaQuery.of(context).size.height * 0.1;
    final height2 = MediaQuery.of(context).size.height * 0.25;
    final height3 = MediaQuery.of(context).size.height * 0.05;
    final height4 = MediaQuery.of(context).size.height * 0.07;

    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Giriş Sayfası"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:25.0),
                  child: SizedBox(
                    height: height2,
                    child: FittedBox(
                      child:Image.asset("resimler/admin1.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 40
                    ),
                child:Column(
                  children: [
                    ozelTextField(icon:Icons.supervised_user_circle,tftctr:nameController,hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı"),
                    ozelTextField(icon:Icons.password,tftctr:passwordController,hintText: "Şifre",label: "Şifre",obsureText: true),
                  ],
                )
                ),
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
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
        ));
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