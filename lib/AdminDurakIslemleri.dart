import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yazlab2_proje2/database/DurakKisidao.dart';
import 'dart:ui' as ui;

import 'database/Duraklar.dart';
import 'database/Duraklardao.dart';

class AdminDurakIslemleri extends StatefulWidget {
  const AdminDurakIslemleri({Key? key}) : super(key: key);

  @override
  State<AdminDurakIslemleri> createState() => _AdminDurakIslemleriState();
}


class _AdminDurakIslemleriState extends State<AdminDurakIslemleri> {

  var baslangicKonum = CameraPosition(
    target: LatLng(40.766666, 29.916668),
    zoom: 8,
  );

  List<Duraklar> duraklar=[];
  List listLat = [];
  List listLng = [];

  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();
  TextEditingController person_count_Controller=TextEditingController();

  Completer<GoogleMapController> haritaKontrol = Completer();


  List<Marker> isaretler = <Marker>[];



  Future<List<Duraklar>> getBusStation() async {
    duraklar=[];
    listLat = [];
    listLng = [];

    duraklar=await Duraklardao().tumDuraklar();

    for(int i=0;i<duraklar.length;i++){
      listLat.add(duraklar[i].lat);
      listLng.add(duraklar[i].lng);
    }


    return duraklar;
  }



  Future<void> durakGuncelle(int durak_id,String stationName,String  lat,String lng,int kisi_sayisi) async {
    await Duraklardao().durakGuncelle(durak_id, stationName, lat, lng, kisi_sayisi);
  }

  Future<void> durakSil(int durak_id) async {
    await Duraklardao().durakSil(durak_id);
    await DurakKisidao().durakKisiSil(durak_id);
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<List<Marker>> _createMarker  ()async{
    var array= <Marker>[];
    final Uint8List markerIcon = await getBytesFromAsset('resimler/station.png', 100);

    for( var i = 0 ; i <= listLat.length-1; i++ ) {

      var x=Marker(
          markerId: MarkerId("asdsa"),
          position: LatLng( double.parse(listLat[i]), double.parse(listLng[i])),
          icon: BitmapDescriptor.fromBytes(markerIcon) , //Icon for Marker

          onTap: () {
            baslangicKonum = CameraPosition(
              target: LatLng(40.766666, 29.916668),
              zoom: 8,
            );

            print(listLat[i]);
          }

      );

      array.add(x);
    }

    return array;
  }



  @override
  Widget build(BuildContext context) {
    final width1 = MediaQuery.of(context).size.width * 0.37;
    

    final height1 = MediaQuery.of(context).size.height * 0.50;
    final height2 = MediaQuery.of(context).size.height * 0.40;
    final height3 = MediaQuery.of(context).size.height * 0.4742;


        return Scaffold(
          appBar: AppBar(
            title: Text("Duraklar",style: TextStyle(color:Colors.white),),
            centerTitle: true,
            backgroundColor: Colors.red,
          ),
          body: FutureBuilder<List<Duraklar>>(
            future: getBusStation(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                var duraklarListesi = snapshot.data;

                return SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 400,
                        height: height2,
                        child: FutureBuilder<List<Marker>>(
                          future: _createMarker(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              List<Marker>? marker=snapshot.data;
                              return GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: baslangicKonum,
                                markers: Set<Marker>.of(marker!),
                                onMapCreated: (GoogleMapController controller) {
                                  haritaKontrol.complete(controller);
                                },
                              );
                            }
                            else{
                              return CircularProgressIndicator();
                            }
                          }
                          ),

                        ),

                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: SizedBox(
                          height: height1,
                          child: Column(
                                  children: [
                                     Expanded(
                                       child: ListView.builder(
                                          itemCount: duraklarListesi!.length,
                                          itemBuilder: (context, index) {
                                            var durak=duraklarListesi[index];
                                            print("Durak adı: ${durak.durak_ad}");


                                            return Card(
                                              child: ListTile(

                                                title: Text(
                                                  "Durak Adı: ${durak.durak_ad}",
                                                  style: TextStyle(color: Colors
                                                      .black, fontSize: 24,),
                                                  textAlign: TextAlign.center,

                                                ),
                                                subtitle: Text(
                                                  "Lat: ${durak.lat}  lng: ${durak.lng} \nKişi sayısı: ${durak.kisi_sayisi}",
                                                  style: TextStyle(color: Colors
                                                      .white, fontSize: 18,),
                                                  textAlign: TextAlign.center,
                                                ),

                                                trailing: Padding(
                                                  padding: const EdgeInsets.all(
                                                      0.0),
                                                  child: PopupMenuButton(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        Icon(Icons.menu),
                                                      ],
                                                    ),
                                                    itemBuilder: (context) =>
                                                    [
                                                      PopupMenuItem(
                                                          value: 1,
                                                          child: Text.rich(
                                                            TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text: "Sil                      ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                                WidgetSpan(
                                                                    child: Icon(
                                                                        Icons
                                                                            .delete)),
                                                              ],
                                                            ),
                                                          )
                                                      ),
                                                      PopupMenuItem(
                                                        value: 2,
                                                        child: Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                  text: "Güncelle           ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .indigoAccent)),
                                                              WidgetSpan(
                                                                  child: Icon(
                                                                      Icons
                                                                          .refresh)),
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          stationController.text=durak.durak_ad;
                                                      latController.text=durak.lat;
                                                      lngController.text=durak.lng;
                                                      person_count_Controller.text=(durak.kisi_sayisi).toString();


                                                          Future.delayed(
                                                              const Duration(
                                                                  seconds: 0),
                                                                  () =>
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (
                                                                          context) =>
                                                                          SingleChildScrollView(
                                                                            child: Container(
                                                                              child: AlertDialog(
                                                                                title: Text(
                                                                                  "Durak Güncelleme Ekranı",
                                                                                  style: TextStyle(
                                                                                      color: Colors
                                                                                          .white,
                                                                                      fontWeight: FontWeight
                                                                                          .bold),),
                                                                                backgroundColor: Colors
                                                                                    .indigoAccent,
                                                                                content: SizedBox(
                                                                                  height: height3,
                                                                                  width: width1,
                                                                                  child: Column(
                                                                                    children: [
                                                                                      Theme(
                                                                                          data: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .copyWith(
                                                                                            colorScheme: ThemeData()
                                                                                                .colorScheme
                                                                                                .copyWith(
                                                                                              primary: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                          ),
                                                                                          child: ozelTextField(
                                                                                              color: Colors
                                                                                                  .yellow,
                                                                                              icon: Icons
                                                                                                  .bus_alert,
                                                                                              tftctr: stationController,
                                                                                              hintText: "Durak adı",
                                                                                              label: "Durak Adı")
                                                                                      ),
                                                                                      Theme(
                                                                                          data: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .copyWith(
                                                                                            colorScheme: ThemeData()
                                                                                                .colorScheme
                                                                                                .copyWith(
                                                                                              primary: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                          ),
                                                                                          child: ozelTextField(
                                                                                              color: Colors
                                                                                                  .purpleAccent,
                                                                                              icon: Icons
                                                                                                  .gps_fixed,
                                                                                              tftctr: latController,
                                                                                              hintText: "Lat",
                                                                                              label: "Lat")
                                                                                      ),

                                                                                      Theme(
                                                                                          data: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .copyWith(
                                                                                            colorScheme: ThemeData()
                                                                                                .colorScheme
                                                                                                .copyWith(
                                                                                              primary: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                          ),
                                                                                          child: ozelTextField(
                                                                                              color: Colors
                                                                                                  .redAccent,
                                                                                              icon: Icons
                                                                                                  .gps_fixed,
                                                                                              tftctr: lngController,
                                                                                              hintText: "Lng",
                                                                                              label: "Lng")
                                                                                      ),

                                                                                      Theme(
                                                                                          data: Theme
                                                                                              .of(
                                                                                              context)
                                                                                              .copyWith(
                                                                                            colorScheme: ThemeData()
                                                                                                .colorScheme
                                                                                                .copyWith(
                                                                                              primary: Colors
                                                                                                  .white,
                                                                                            ),
                                                                                          ),
                                                                                          child: ozelTextField(
                                                                                              color: Colors
                                                                                                  .orangeAccent,
                                                                                              icon: Icons
                                                                                                  .person,
                                                                                              tftctr: person_count_Controller,
                                                                                              hintText: "Kişi Sayısı",
                                                                                              label: "Kişi Sayısı")
                                                                                      ),

                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                actions: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets
                                                                                        .all(
                                                                                        0.0),
                                                                                    child: TextButton(
                                                                                      child: Text(
                                                                                        "İptal",
                                                                                        style: TextStyle(
                                                                                            color: Colors
                                                                                                .white),),

                                                                                      onPressed: () {

                                                                                        stationController.text = "";
                                                                                        latController.text = "";
                                                                                        lngController.text = "";
                                                                                        person_count_Controller.text = "";
                                                                                        Navigator.pop(context);
                                                                                      },

                                                                                    ),
                                                                                  ),
                                                                                  TextButton(
                                                                                    child: Text("Güncelle", style: TextStyle(color: Colors.white),),
                                                                                    onPressed: () async {

                                                                                       await durakGuncelle(durak.durak_id, stationController.text, latController.text, lngController.text,int.parse(person_count_Controller.text));

                                                                                      setState(() async {
                                                                                        stationController.text = "";
                                                                                        latController.text = "";
                                                                                        lngController.text = "";
                                                                                        person_count_Controller.text = "";

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
                                                    onCanceled: () {
                                                      print("Seçim yapılmadı");
                                                    },
                                                    onSelected: (
                                                        menuItemValue) {
                                                      if (menuItemValue == 1) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(

                                                            SnackBar(
                                                              content: Text(
                                                                "Silmek istediğinizi emin misiniz ?",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight
                                                                        .bold),),
                                                              backgroundColor: Colors
                                                                  .indigo,
                                                              duration: Duration(
                                                                  seconds: 4),
                                                              action: SnackBarAction(
                                                                label: "Evet",
                                                                textColor: Colors
                                                                    .white,
                                                                onPressed: () async {

                                                                  await durakSil(durak.durak_id);

                                                                  setState(() {
                                                                    duraklarListesi.removeAt(index);
                                                                  });

                                                                  ScaffoldMessenger.of(context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                        "Veri başarıyla silindi",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontWeight: FontWeight
                                                                                .bold),),
                                                                      duration: Duration(
                                                                          seconds: 3),
                                                                      backgroundColor: Colors
                                                                          .green,
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

                                  ],
                                )

                        ),
                      ),

                    ],
                  ),

                ),

        );
      }

          else{
            return CircularProgressIndicator();
           }
    }
  )
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

