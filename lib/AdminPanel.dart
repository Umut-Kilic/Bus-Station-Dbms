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
    final width2 = MediaQuery.of(context).size.width;
    final width3 = MediaQuery.of(context).size.width;
    final width4 = MediaQuery.of(context).size.width;
    final height1 = MediaQuery.of(context).size.height * 0.45;
    final height2 = MediaQuery.of(context).size.height * 0.25;
    final height3 = MediaQuery.of(context).size.height * 0.12;
    final height4 = MediaQuery.of(context).size.height * 0.06;
    final height5 = MediaQuery.of(context).size.height * 0.35;

    CollectionReference userRef=_firestore.collection('Kisiler');
    guncelle() async{
      await userRef.doc(nameController.text).update({'Name':nameController.text});
      await userRef.doc(nameController.text).update({'Password':passwordController.text});
      await userRef.doc(nameController.text).update({'Email':emailController.text});
      nameController.text="";
      passwordController.text="";
      emailController.text="";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Paneli"),
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

                             return Flexible(
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
                                       /*trailing: IconButton(icon: Icon(Icons.delete),
                                       onPressed: () async{

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

                                       },
                                       ),*/
                                       trailing: Padding(
                                         padding: const EdgeInsets.all(0.0),
                                         child: PopupMenuButton(
                                           child: Icon(Icons.open_in_new),
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
                                                                   Padding(
                                                                     padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                                     child: TextFormField(

                                                                       controller: nameController,
                                                                       decoration: InputDecoration(
                                                                         filled: true,
                                                                         fillColor: Colors.orangeAccent,
                                                                         hintText: "Plaese enter your name",
                                                                         hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                                         focusedBorder: OutlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                         enabledBorder: UnderlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Padding(
                                                                     padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                                     child: TextFormField(
                                                                       controller: passwordController,
                                                                       decoration: InputDecoration(
                                                                         filled: true,
                                                                         fillColor: Colors.orangeAccent,
                                                                         hintText: "Plaese enter your password",
                                                                         hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                                         focusedBorder: OutlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                         enabledBorder: UnderlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                   Padding(
                                                                     padding: const EdgeInsets.only(top: 16.0),
                                                                     child: TextFormField(
                                                                       controller: emailController,
                                                                       decoration: InputDecoration(
                                                                         filled: true,
                                                                         fillColor: Colors.orangeAccent,
                                                                         hintText: "Plaese enter your email account",
                                                                         hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                                         focusedBorder: OutlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                         enabledBorder: UnderlineInputBorder(
                                                                           borderSide: new BorderSide(color: Colors.white),
                                                                           borderRadius: new BorderRadius.circular(25.7),
                                                                         ),
                                                                       ),
                                                                     ),
                                                                   ),
                                                                 ],
                                                               ),
                                                             ),
                                                             actions: [
                                                               Padding(
                                                                 padding: const EdgeInsets.all(0.0),
                                                                 child: FlatButton(
                                                                   child: Text("İptal",style: TextStyle(color: Colors.white),),

                                                                   onPressed: (){
                                                                     Navigator.pop(context);

                                                                   },

                                                                 ),
                                                               ),
                                                               FlatButton(
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
                SizedBox(height: height4,),
                SizedBox(
                  height: height2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,20.0),
                    child: Form(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "Plaese enter your name"
                              ),
                            ),
                            TextFormField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                  hintText: "Plaese enter your password"
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: "Plaese enter your email account"
                              ),
                            ),

                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: height3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: FloatingActionButton(
                          onPressed: (){

                            guncelle();
                            },
                          tooltip: 'Update',
                          child: const Icon(Icons.update),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: FloatingActionButton(
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
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                child: TextFormField(

                                                  controller: nameController,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.orangeAccent,
                                                      hintText: "Plaese enter your name",
                                                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                                child: TextFormField(
                                                  controller: passwordController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.orangeAccent,
                                                      hintText: "Plaese enter your password",
                                                      hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 16.0),
                                                child: TextFormField(
                                                  controller: emailController,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.orangeAccent,
                                                      hintText: "Plaese enter your email account",
                                                    hintStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide: new BorderSide(color: Colors.white),
                                                      borderRadius: new BorderRadius.circular(25.7),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: FlatButton(
                                              child: Text("İptal",style: TextStyle(color: Colors.white),),

                                              onPressed: (){
                                                Navigator.pop(context);

                                              },

                                            ),
                                          ),
                                          FlatButton(
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
                          tooltip: 'Add',
                          child: const Icon(Icons.add),
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
