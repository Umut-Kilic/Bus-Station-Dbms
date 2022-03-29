import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Admin());
}

class Admin extends StatelessWidget {

  final Future<FirebaseApp> _initialization=Firebase.initializeApp();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
            return AdminPanel();
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      )

    );
  }
}

class AdminPanel extends StatefulWidget {

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  final _firestore=FirebaseFirestore.instance;

  TextEditingController nameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController emailController=TextEditingController();



  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.7;

    final height1 = MediaQuery.of(context).size.height * 0.75;
    final height2 = MediaQuery.of(context).size.height * 0.25;
    final height3 = MediaQuery.of(context).size.height * 0.12;
    final height4 = MediaQuery.of(context).size.height * 0.06;
    final height5 = MediaQuery.of(context).size.height * 0.36;

    CollectionReference userRef=_firestore.collection('Kisiler');

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Kullanıcı İşlemleri"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SizedBox(
                    height: height1,
                    child: StreamBuilder<QuerySnapshot>(
                        stream: userRef.snapshots(),


                        builder: (BuildContext context,AsyncSnapshot asyncSnapshot){

                         if(asyncSnapshot.hasError){
                           return Center(child: Text("Bir hata oluştu lütfen tekrar deneyiniz"),);
                         }
                         else{
                           if(asyncSnapshot.hasData){
                             List<DocumentSnapshot> listofDocumentSnapshot= asyncSnapshot.data.docs;

                             return Expanded(
                               child: Container(
                                 child: ListView.builder(
                                   itemCount: listofDocumentSnapshot.length,
                                   itemBuilder: (context,index){
                                     return Card(
                                       child: ListTile(
                                         title: Text("${(listofDocumentSnapshot[index].data() as Map)['Name']}",
                                           style:TextStyle(color: Colors.black, fontSize:24,)
                                           ),
                                         subtitle:  Text("${(listofDocumentSnapshot[index].data() as Map)['Email']}",
                                           style:TextStyle(color: Colors.white, fontSize:18,)
                                         ),


                                         trailing: Padding(
                                           padding: const EdgeInsets.all(0.0),
                                           child: PopupMenuButton(
                                             child: Icon(Icons.menu),
                                             itemBuilder: (context)=>[
                                               PopupMenuItem(
                                                 value: 1,
                                                 child: Text.rich(
                                                   TextSpan(
                                                     children: [
                                                       TextSpan(text: "Sil                      ",style: TextStyle(color:Colors.red)),
                                                       WidgetSpan(child: Icon(Icons.delete)),
                                                     ],
                                                   ),
                                                 )
                                               ),
                                               PopupMenuItem(
                                                 value: 2,
                                                 child: Text.rich(
                                                   TextSpan(
                                                     children: [
                                                       TextSpan(text:"Güncelle           ",style: TextStyle(color:Colors.indigoAccent)),
                                                       WidgetSpan(child: Icon(Icons.refresh)),
                                                     ],
                                                   ),
                                                 ),
                                                 onTap: () {
                                                   nameController.text=(listofDocumentSnapshot[index].data() as Map)['Name'];
                                                   emailController.text=(listofDocumentSnapshot[index].data() as Map)['Email'];
                                                   passwordController.text=(listofDocumentSnapshot[index].data() as Map)['Password'];


                                                   Future.delayed(
                                                       const Duration(seconds: 0),
                                                           () => showDialog(
                                                         context: context,
                                                         builder: (context) => SingleChildScrollView(
                                                           child: Container(
                                                             child: AlertDialog(
                                                               title: Text("Kullanıcı Güncelleme Ekranı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                               backgroundColor: Colors.indigoAccent,
                                                               content: SizedBox(
                                                                 height: height5,
                                                                 width: width1,
                                                                 child: Column(
                                                                   children: [
                                                                     Theme(
                                                                         data:Theme.of(context).copyWith(
                                                                           colorScheme: ThemeData().colorScheme.copyWith(
                                                                             primary:Colors.white,
                                                                           ),
                                                                         ),
                                                                         child: ozelTextField(color:Colors.yellow,icon:Icons.supervised_user_circle,tftctr:nameController,hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı")
                                                                     ),
                                                                     Theme(
                                                                         data:Theme.of(context).copyWith(
                                                                           colorScheme: ThemeData().colorScheme.copyWith(
                                                                             primary:Colors.white,
                                                                           ),
                                                                         ),
                                                                         child: ozelTextField(color:Colors.purpleAccent,icon:Icons.email,tftctr:emailController,hintText: "Email",label: "Email")
                                                                     ),
                                                                     Theme(
                                                                         data:Theme.of(context).copyWith(
                                                                           colorScheme: ThemeData().colorScheme.copyWith(
                                                                             primary:Colors.white,
                                                                           ),
                                                                         ),
                                                                         child: ozelTextField(color:Colors.redAccent,icon:Icons.password,tftctr:passwordController,hintText: "Şifre",label: "Şifre")
                                                                     )
                                                                   ],
                                                                 ),
                                                               ),
                                                               actions: [
                                                                 Padding(
                                                                   padding: const EdgeInsets.all(0.0),
                                                                   child: TextButton(
                                                                     child: Text("İptal",style: TextStyle(color: Colors.white),),

                                                                     onPressed: (){
                                                                       nameController.text="";
                                                                       emailController.text="";
                                                                       passwordController.text="";
                                                                       Navigator.pop(context);

                                                                     },

                                                                   ),
                                                                 ),
                                                                 TextButton(
                                                                   child: Text("Güncelle",style: TextStyle(color: Colors.white),),
                                                                   onPressed: () {
                                                                     CollectionReference userRef=_firestore.collection('Kisiler');
                                                                     setState(() async{
                                                                       await userRef.doc(nameController.text).update({'Name':nameController.text});
                                                                       await userRef.doc(nameController.text).update({'Password':passwordController.text});
                                                                       await userRef.doc(nameController.text).update({'Email':emailController.text});
                                                                       nameController.text="";
                                                                       passwordController.text="";
                                                                       emailController.text="";

                                                                       Navigator.pop(context);
                                                                     });

                                                                   },
                                                                 ),
                                                               ],
                                                             ),
                                                           ),
                                                         )
                                                       ));
                                                 },

                                               )
                                             ],
                                             onCanceled: (){
                                               print("Seçim yapılmadı");
                                             },
                                             onSelected: (menuItemValue){
                                               if(menuItemValue==1){
                                                 ScaffoldMessenger.of(context).showSnackBar(

                                                     SnackBar(
                                                       content: Text("Silmek istediğinizi emin misiniz ?",style: TextStyle(fontWeight: FontWeight.bold),),
                                                       backgroundColor: Colors.indigo,
                                                       duration: Duration(seconds: 4),
                                                       action: SnackBarAction(
                                                         label: "Evet",
                                                         textColor: Colors.white,
                                                         onPressed: () async{
                                                           await listofDocumentSnapshot[index].reference.delete();
                                                           ScaffoldMessenger.of(context).showSnackBar(
                                                             SnackBar(
                                                               content: Text("Veri başarıyla silindi",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                               duration: Duration(seconds: 3),
                                                               backgroundColor: Colors.green,
                                                             ),
                                                           );
                                                         },
                                                       ),)
                                                 );
                                               }

                                             },
                                           ),
                                         ),
                                       ),
                                       color: Colors.blueGrey,
                                     );
                                   },
                                 ),
                               ),
                             );
                           }
                           else{
                              return Center(child: CircularProgressIndicator(),);
                           }

                         }

                        }
                        ),
                  ),
                ),
                SizedBox(
                  height: height3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 3.0),
                        child: ElevatedButton(
                          onPressed: () async{


                            showDialog(
                                context:  context,
                                builder: (BuildContext context){
                                  return SingleChildScrollView(
                                    child: Container(
                                      child: AlertDialog(
                                        title: Text("Kullanıcı Ekleme Ekranı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        backgroundColor: Colors.indigoAccent,
                                        content: SizedBox(
                                          height: height5,
                                          width: width1,
                                          child: Column(
                                            children: [
                                              Theme(
                                                  data:Theme.of(context).copyWith(
                                                    colorScheme: ThemeData().colorScheme.copyWith(
                                                      primary:Colors.white,
                                                    ),
                                                  ),
                                                  child: ozelTextField(color:Colors.yellow,icon:Icons.supervised_user_circle,tftctr:nameController,hintText: "Kullanıcı Adınız",label: "Kullanıcı Adı")
                                              ),
                                              Theme(
                                                  data:Theme.of(context).copyWith(
                                                    colorScheme: ThemeData().colorScheme.copyWith(
                                                      primary:Colors.white,
                                                    ),
                                                  ),
                                                  child: ozelTextField(color:Colors.purpleAccent,icon:Icons.email,tftctr:emailController,hintText: "Email",label: "Email")
                                              ),
                                              Theme(
                                                  data:Theme.of(context).copyWith(
                                                    colorScheme: ThemeData().colorScheme.copyWith(
                                                      primary:Colors.white,
                                                    ),
                                                  ),
                                                  child: ozelTextField(color:Colors.redAccent,icon:Icons.password,tftctr:passwordController,hintText: "Şifre",label: "Şifre",obsureText: true)
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: TextButton(
                                              child: Text("İptal",style: TextStyle(color: Colors.white),),

                                              onPressed: (){
                                                Navigator.pop(context);

                                              },

                                            ),
                                          ),
                                          TextButton(
                                            child: Text("Kayıt et",style: TextStyle(color: Colors.white),),
                                            onPressed: () async{
                                              Map<String,dynamic> usersData={'Name':nameController.text,'Password':passwordController.text,'Email':emailController.text};
                                              await userRef.doc(nameController.text).set(usersData);
                                              nameController.text="";
                                              passwordController.text="";
                                              emailController.text="";

                                              Navigator.pop(context);


                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                            );

                          },
                        
                          child: Image.asset("resimler/adam_ekle.png"),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}



Widget ozelTextField({color,icon,tftctr,hintText,label,obsureText = false,}){
  
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
          filled: true,
          fillColor: color,
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
      SizedBox(height: 10,)

    ],
  );
}
