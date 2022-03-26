
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(User());
}


class User extends StatelessWidget {

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
                return UserDisplay();
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        )

    );
  }
}

class UserDisplay extends StatefulWidget {
  const UserDisplay({Key? key}) : super(key: key);

  @override
  State<UserDisplay> createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ekranı"),
      ),
      body: Center(
        child: Expanded(
          child: Container(
            child: Column(
              children: [
                Text("Kullanıcı Ekranı",style: TextStyle(color: Colors.purpleAccent),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
