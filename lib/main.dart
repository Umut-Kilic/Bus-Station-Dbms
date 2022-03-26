import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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

    CollectionReference userRef=_firestore.collection('Kisiler');
    var gokselRef=userRef.doc('ZWjfnoUgscUIlngIBb5v');
    guncelle() async{
      await userRef.doc(nameController.text).update({'Name':nameController.text});
      await userRef.doc(nameController.text).update({'Password':passwordController.text});
      await userRef.doc(nameController.text).update({'Email':emailController.text});
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Paneli"),
      ),
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Text('${gokselRef.id}',style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(
                  onPressed: () async{
                   var response= await gokselRef.get();
                   dynamic map=response.data();
                   print(map['Name']);
                  }
                  , child: Text("Gokseli getir (DocumentSnapshot)")
              ),
              ElevatedButton(
                  onPressed: () async{
                    var response= await userRef.get();
                    var list=response.docs;
                    print(list.first.data());
                  }
                  , child: Text("Gokseli getir (QuerySnapshot)")
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: gokselRef.snapshots(),
                builder: (context,AsyncSnapshot asyncSnapshot){
                  return Text("${asyncSnapshot.data.data()}",style: TextStyle(color: Colors.red),);
                },
              ),*/
              StreamBuilder<QuerySnapshot>(
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
                                 trailing: IconButton(icon: Icon(Icons.delete),
                                 onPressed: () async{
                                   await listofDocumentSnapshot[index].reference.delete();
                                 },
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 100),
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
              FloatingActionButton(
                onPressed: (){

                  guncelle();
                  },
                tooltip: 'Update',
                child: const Icon(Icons.update),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Map<String,dynamic> usersData={'Name':nameController.text,'Password':passwordController.text,'Email':emailController.text};
          await userRef.doc(nameController.text).set(usersData);

          },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),

    );
  }
}
