
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  late BitmapDescriptor konumIcon;

  Completer<GoogleMapController> haritaKontrol = Completer();

  var baslangicKonum = CameraPosition(target: LatLng(38.7412482,26.1844276),zoom: 4,);

  List<Marker> isaretler = <Marker>[];

  iconOlustur(context){
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, "resimler/konum_resim.png").then((icon) {
      setState(() {
        konumIcon = icon;
      });
    });
  }

  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;

    var gidilecekIsaret = Marker(
      markerId: MarkerId("Id"),
      position: LatLng(41.0039643,28.4517462),
      infoWindow: InfoWindow(title: "İstanbul",snippet: "Evim"),
      icon: konumIcon,
    );

    setState(() {
      isaretler.add(gidilecekIsaret);
    });

    var gidilecekKonum = CameraPosition(target: LatLng(41.0039643,28.4517462),zoom: 8,);

    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));

  }

  @override
  Widget build(BuildContext context) {
    iconOlustur(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ekranı"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 400,
              height: 300,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: baslangicKonum,
                markers: Set<Marker>.of(isaretler),
                onMapCreated: (GoogleMapController controller){
                  haritaKontrol.complete(controller);
                },
              ),
            ),
            RaisedButton(
              child: Text("Konuma Git"),
              onPressed: (){
                konumaGit();
              },
            ),
          ],
        ),
      ),

    );
  }
}
