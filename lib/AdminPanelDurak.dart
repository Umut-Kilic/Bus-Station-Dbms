import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AdminDurak());
}

class AdminDurak extends StatelessWidget {

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
                return Center(child: Text("Beklenmeyen bir hata ortaya çıktı"));
              }
              else if(snapshot.hasData){
                return AdminPanelDurak();
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
        )

    );
  }
}

class AdminPanelDurak extends StatefulWidget {
  const AdminPanelDurak({Key? key}) : super(key: key);

  @override
  State<AdminPanelDurak> createState() => _AdminPanelDurakState();
}

class _AdminPanelDurakState extends State<AdminPanelDurak> {

  final Future<FirebaseApp> _initialization=Firebase.initializeApp();
  final _firestore=FirebaseFirestore.instance;


  late BitmapDescriptor konumIcon;

  Completer<GoogleMapController> haritaKontrol = Completer();

  var baslangicKonum = CameraPosition(target: LatLng(38.7412482,26.1844276),zoom: 4,);

  List<Marker> isaretler = <Marker>[];

  var gidilecekKonum = CameraPosition(target: LatLng(41.0039643,28.4517462),zoom: 8,);

  /*iconOlustur(context){
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(configuration, "resimler/bus.png").then((icon) {
      setState(() {
        konumIcon = icon;
      });
    });
  }*/

  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;

    var gidilecekIsaret = Marker(
      markerId: MarkerId("Id"),
      position: LatLng(41.0039643,28.4517462),
      infoWindow: InfoWindow(title: "İstanbul",snippet: "Evim"),
      //icon: konumIcon,
    );

    setState(() {
      isaretler.add(gidilecekIsaret);
    });



    controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));

  }

  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();
  TextEditingController person_count_Controller=TextEditingController();

  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.37;

    final height1 = MediaQuery.of(context).size.height * 0.50;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Durak İşlemleri"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
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
              ElevatedButton(
                child: Text("Konuma Git"),
                onPressed: (){
                  konumaGit();
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    Future.delayed(
                        const Duration(seconds: 0),
                            () => showDialog(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: Expanded(
                                child: Container(
                                  child: AlertDialog(
                                    title: Text("Durak Ekleme Alanı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                    backgroundColor: Colors.orangeAccent,
                                    content: SizedBox(
                                      height: height1,
                                      width: width1,
                                      child: Column(
                                        children: [
                                          Expanded(

                                            child: Theme(
                                                data:Theme.of(context).copyWith(
                                                  colorScheme: ThemeData().colorScheme.copyWith(
                                                    primary:Colors.white,
                                                  ),
                                                ),
                                                child: ozelTextField(color:Colors.indigo,icon:Icons.bus_alert,tftctr:stationController,hintText: "Durak ismini giriniz",label: "Durak ismi")
                                            ),
                                          ),

                                          Expanded(

                                            child: Theme(
                                                data:Theme.of(context).copyWith(
                                                  colorScheme: ThemeData().colorScheme.copyWith(
                                                    primary:Colors.white,
                                                  ),
                                                ),
                                                child: ozelTextField(color:Colors.tealAccent,icon:Icons.gps_not_fixed,tftctr:latController,hintText: "Lat",label: "Lat:")
                                            ),
                                          ),
                                          Expanded(

                                            child: Theme(
                                                data:Theme.of(context).copyWith(
                                                  colorScheme: ThemeData().colorScheme.copyWith(
                                                    primary:Colors.white,
                                                  ),
                                                ),
                                                child: ozelTextField(color:Colors.redAccent,icon:Icons.gps_not_fixed,tftctr:lngController,hintText: "Lng",label: "Lng:")
                                            ),
                                          ),
                                          Expanded(
                                            child: Theme(
                                                data:Theme.of(context).copyWith(
                                                  colorScheme: ThemeData().colorScheme.copyWith(
                                                    primary:Colors.white,
                                                  ),
                                                ),
                                                child: ozelTextField(color:Colors.green,icon:Icons.person,tftctr:person_count_Controller,hintText: "Duraktaki kişi sayısı",label: "Kişi sayısı:")
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: FlatButton(
                                          child: Text("İptal",style: TextStyle(color: Colors.white),),

                                          onPressed: (){
                                            stationController.text="";
                                            latController.text="";
                                            lngController.text="";
                                            person_count_Controller.text="";
                                            Navigator.pop(context);

                                          },

                                        ),
                                      ),
                                      FlatButton(
                                        child: Text("Güncelle",style: TextStyle(color: Colors.white),),
                                        onPressed: () {
                                          CollectionReference durakRef=_firestore.collection('Duraklar');
                                          setState(() async{
                                            await durakRef.doc(stationController.text).update({'Isım':stationController.text});
                                            await durakRef.doc(stationController.text).update({'lat':latController.text});
                                            await durakRef.doc(stationController.text).update({'lng':lngController.text});
                                            await durakRef.doc(stationController.text).update({'Kisi Sayısı':person_count_Controller.text});

                                            stationController.text="";
                                            latController.text="";
                                            lngController.text="";
                                            person_count_Controller.text="";

                                            Navigator.pop(context);
                                          });

                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ));
                  },
                  child: SizedBox(
                    width: width1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bus_alert,
                              color:Colors.white
                        ),
                        SizedBox(width: 10,),
                        Text("Durak Ekle"),
                      ],
                    ),
                  ),
                style: ElevatedButton.styleFrom(

                ),
              ),
            ],
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
