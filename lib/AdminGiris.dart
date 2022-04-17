import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/AdminHome.dart';
import 'package:yazlab2_proje2/database/Kisilerdao.dart';

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

  final GlobalKey<FormState> _formKey= GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.7;
    final width2 = MediaQuery.of(context).size.width*0.5;

    final height1 = MediaQuery.of(context).size.height * 0.1;
    final height2 = MediaQuery.of(context).size.height * 0.25;
    final height3 = MediaQuery.of(context).size.height * 0.05;
    final height4 = MediaQuery.of(context).size.height * 0.07;

    return Scaffold(
        appBar: AppBar(
          title: Text("Admin Giriş Sayfası"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom:25.0),
                  child: SizedBox(
                    height: height2,
                    width: width2,
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
                child:Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ozelFormTextField(icon:Icons.supervised_user_circle,tftctr:nameController,degisken:"Kullanıcı Adını",hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı"),
                      ozelFormTextField(icon:Icons.password,tftctr:passwordController,degisken:"Şifre",hintText: "Şifre",label: "Şifre",obsureText: true)
                    ],
                  ),
                )
                ),
                SizedBox(
                  width: width1,
                  height: height4,
                  child: ElevatedButton(
                    onPressed: () async{
                      if(_formKey.currentState!.validate()){

                        bool sonuc= await Kisilerdao().admingiris(nameController.text, passwordController.text);

                        if(sonuc){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
                          nameController.text="";
                          passwordController.text="";
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(backgroundColor: Colors.white,content: Text("Girdiğiniz bilgiler yanlıştır !",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),))
                          );
                          nameController.text="";
                          passwordController.text="";
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


Widget ozelFormTextField({icon,tftctr,degisken,hintText,label,obsureText = false,}){
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
