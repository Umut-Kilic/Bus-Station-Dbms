import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'AdminDurakIslemleri.dart';

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


var  array= <Marker>[];


class _AdminPanelDurakState extends State<AdminPanelDurak> {
  final Future<FirebaseApp> _initialization=Firebase.initializeApp();


  late BitmapDescriptor konumIcon;

  Completer<GoogleMapController> haritaKontrol = Completer();

  var baslangicKonum = CameraPosition(target: LatLng(40.766666,29.916668),zoom: 8,);

  List<Marker> isaretler = <Marker>[];

  var gidilecekKonum = CameraPosition(target: LatLng(41.0039643,28.4517462),zoom: 10,);


  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;


  }
  List listLat = [];
  List listLng = [];


  getBusStation(stationRef) async {

    QuerySnapshot querySnapshot = await stationRef.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List liste = [];
    for (int i = 0; i < _docData.length; i++) {
      liste.add(_docData[i]);
    }

    for(int i=0;i<liste.length;i++){
      listLat.add(liste[i]['lat']);
      listLng.add(liste[i]['lng']);


    }

    for( var i = 0 ; i <= listLat.length-1; i++ ) {

      var x=Marker(
          markerId: MarkerId(liste[i]['Isim']),
          position: LatLng( double.parse(listLat[i]), double.parse(listLng[i]))
      );
      array.add(x);
    }
  }


  List createMarker (){

    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    print(listLat[2]);

    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");

    for( var i = 0 ; i <= listLat.length-1; i++ ) {

        var x=Marker(
        markerId: MarkerId("asdsa"),
        position: LatLng( double.parse(listLat[i]), double.parse(listLng[i]))
      );
      array.add(x);
    }

    return array;
  }

  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();
  TextEditingController person_count_Controller=TextEditingController();


  Future<void> durakEkle(durakRef) async {
    Map<String,dynamic> stationData={'Isim':stationController.text,'lat':latController.text,'lng':lngController.text,'KisiSayisi':person_count_Controller.text};
    await durakRef.doc(stationController.text).set(stationData);

  }

  Future<void> durakGuncelle(durakRef) async {
    await durakRef.doc(stationController.text).update({'Isim':stationController.text});
    await durakRef.doc(stationController.text).update({'lat':latController.text});
    await durakRef.doc(stationController.text).update({'lng':lngController.text});
    await durakRef.doc(stationController.text).update({'KisiSayisi':person_count_Controller.text});
  }

  @override
  Widget build(BuildContext context) {
    final _firestore=FirebaseFirestore.instance;
    CollectionReference durakRef=_firestore.collection('Duraklar');

    final width1 = MediaQuery.of(context).size.width * 0.37;

    final height1 = MediaQuery.of(context).size.height * 0.50;
    final height2 = MediaQuery.of(context).size.height * 0.60;

    return FutureBuilder(
      future: getBusStation(durakRef),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text("Beklenmeyen bir hata ortaya çıktı "));
          }
          else {
            return Scaffold(
              appBar: AppBar(
                title: Text("Admin Durak İşlemleri"),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      googleMap(height2, baslangicKonum, createMarker, haritaKontrol),
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
                                              child: TextButton(
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
                                            TextButton(
                                              child: Text("Durak Ekle",style: TextStyle(color: Colors.white),),
                                              onPressed: () async {

                                                setState(() async{

                                                  durakEkle(durakRef);

                                                  getBusStation(durakRef);

                                                  googleMap(height2, baslangicKonum, createMarker, haritaKontrol);



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
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDurakIslemleri()));



                        },
                        child: Text("Durak Listele",style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

            );
          }

        }
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

Widget googleMap(height,konum,createMarker,haritaKontrol){
  List arrayMarker=createMarker();
  return SizedBox(
    width: 400,
    height: height,
    child: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: konum,
      markers:  Set<Marker>.of( array),


      onMapCreated: (GoogleMapController controller){
        haritaKontrol.complete(controller);
      },
    ),
  );
}
