import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminDurakIslemleri extends StatefulWidget {
  const AdminDurakIslemleri({Key? key}) : super(key: key);

  @override
  State<AdminDurakIslemleri> createState() => _AdminDurakIslemleriState();
}

class _AdminDurakIslemleriState extends State<AdminDurakIslemleri> {

  List listLat = [];
  List listLng = [];

  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();
  TextEditingController person_count_Controller=TextEditingController();

  final _firestore=FirebaseFirestore.instance;

  Completer<GoogleMapController> haritaKontrol = Completer();

  var baslangicKonum = CameraPosition(
    target: LatLng(40.766666, 29.916668),
    zoom: 8,
  );

  List<Marker> isaretler = <Marker>[];



  Future getBusStation(stationRef) async {

    QuerySnapshot querySnapshot = await stationRef.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    List liste = [];
    for (int i = 0; i < _docData.length; i++) {
      liste.add(_docData[i]);
    }



     listLat=[];
     listLng=[];
    for(int i=0;i<liste.length;i++){
      //print("İsim: ${liste[i]['Isim']}   Lat : ${liste[i]['lat']}  Lng: ${liste[i]['lng']} Kişi sayısı : ${liste[i]['KisiSayisi']}");
      listLat.add(liste[i]['lat']);
      listLng.add(liste[i]['lng']);

    }
    return liste;
  }

  List<Marker> _createMarker (){
    var array= <Marker>[];

    for( var i = 0 ; i <= listLat.length-1; i++ ) {

      var x=Marker(
          markerId: MarkerId("asdsa"),
          position: LatLng( double.parse(listLat[i]), double.parse(listLng[i]))
      );
      array.add(x);
    }

    return array;
  }

  Future<void> durakGuncelle(durakRef) async {
    await durakRef.doc(stationController.text).update({'Isim':stationController.text});
    await durakRef.doc(stationController.text).update({'lat':latController.text});
    await durakRef.doc(stationController.text).update({'lng':lngController.text});
    await durakRef.doc(stationController.text).update({'KisiSayisi':person_count_Controller.text});
  }



  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.37;

    final height1 = MediaQuery.of(context).size.height * 0.50;
    final height2 = MediaQuery.of(context).size.height * 0.40;
    final height3 = MediaQuery.of(context).size.height * 0.4742;

    CollectionReference durakRef=_firestore.collection('Duraklar');

    return FutureBuilder(
        future: getBusStation(durakRef),
    builder: (context, snapshot) {
      if(snapshot.hasError){
        return Center(child: Text("Beklenmeyen bir hata ortaya çıktı"));
      }
      else if(snapshot.hasData){
        return Scaffold(
          appBar: AppBar(
            title: Text("Duraklar",style: TextStyle(color:Colors.white),),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      height: height2,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: baslangicKonum,
                        markers: Set<Marker>.of(_createMarker()),
                        onMapCreated: (GoogleMapController controller){
                          haritaKontrol.complete(controller);
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: SizedBox(
                        height: height1,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: durakRef.snapshots(),


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
                                          var durak_isim=(listofDocumentSnapshot[index].data() as Map)['Isim'];
                                          var lat = (listofDocumentSnapshot[index].data() as Map)['lat'];
                                          var lng = (listofDocumentSnapshot[index].data() as Map)['lng'];
                                          var kisiSayisi = (listofDocumentSnapshot[index].data() as Map)['KisiSayisi'];

                                          return Card(
                                            child: ListTile(

                                              title: Text("Durak Adı: $durak_isim",
                                                style:TextStyle(color: Colors.black, fontSize:24,), textAlign: TextAlign.center,

                                              ),
                                              subtitle:  Text("Lat: $lat  lng: $lng \nKişi sayısı: $kisiSayisi",
                                                style:TextStyle(color: Colors.white, fontSize:18,),textAlign: TextAlign.center,
                                              ),

                                              trailing: Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: PopupMenuButton(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.menu),
                                                    ],
                                                  ),
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
                                                        stationController.text=(listofDocumentSnapshot[index].data() as Map)['Isim'];
                                                        latController.text=(listofDocumentSnapshot[index].data() as Map)['lat'];
                                                        lngController.text=(listofDocumentSnapshot[index].data() as Map)['lng'];
                                                        person_count_Controller.text=(listofDocumentSnapshot[index].data() as Map)['KisiSayisi'];


                                                        Future.delayed(
                                                            const Duration(seconds: 0),
                                                                () => showDialog(
                                                                context: context,
                                                                builder: (context) => SingleChildScrollView(
                                                                  child: Expanded(
                                                                    child: Container(
                                                                      child: AlertDialog(
                                                                        title: Text("Durak Güncelleme Ekranı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                                        backgroundColor: Colors.indigoAccent,
                                                                        content: SizedBox(
                                                                          height: height3,
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
                                                                                    child: ozelTextField(color:Colors.yellow,icon:Icons.bus_alert,tftctr:stationController,hintText: "Durak adı",label: "Durak Adı")
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Theme(
                                                                                    data:Theme.of(context).copyWith(
                                                                                      colorScheme: ThemeData().colorScheme.copyWith(
                                                                                        primary:Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    child: ozelTextField(color:Colors.purpleAccent,icon:Icons.gps_fixed,tftctr:latController,hintText: "Lat",label: "Lat")
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Theme(
                                                                                    data:Theme.of(context).copyWith(
                                                                                      colorScheme: ThemeData().colorScheme.copyWith(
                                                                                        primary:Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    child: ozelTextField(color:Colors.redAccent,icon:Icons.gps_fixed,tftctr:lngController,hintText: "Lng",label: "Lng")
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Theme(
                                                                                    data:Theme.of(context).copyWith(
                                                                                      colorScheme: ThemeData().colorScheme.copyWith(
                                                                                        primary:Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                    child: ozelTextField(color:Colors.orangeAccent,icon:Icons.person,tftctr:lngController,hintText: "Kişi Sayısı",label: "Kişi Sayısı")
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
                                                                            child: Text("Güncelle",style: TextStyle(color: Colors.white),),
                                                                            onPressed: () {
                                                                              CollectionReference stationRef=_firestore.collection('Duraklar');
                                                                              setState(() async{
                                                                                await stationRef.doc(stationController.text).update({'Isim':stationController.text});
                                                                                await stationRef.doc(stationController.text).update({'lat':latController.text});
                                                                                await stationRef.doc(stationController.text).update({'lng':lngController.text});
                                                                                await stationRef.doc(stationController.text).update({'KisiSayi':person_count_Controller.text});
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

                  ],
                ),
              ),
            ),
          ),

        );
      }
      else{
        return Center(child: CircularProgressIndicator());
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

