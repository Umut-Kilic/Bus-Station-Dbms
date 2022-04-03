
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'database/Duraklardao.dart';
import 'database/DurakKisidao.dart';
import 'database/Kisiler.dart';
import 'database/Kisilerdao.dart';

class UserDisplay extends StatefulWidget {

  String username="adasd";
  UserDisplay({Key? key, required this.username}) : super(key: key);
  @override
  State<UserDisplay> createState() => _UserDisplayState();
}


class _UserDisplayState extends State<UserDisplay> {
  GoogleMapController? mapController;

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


  List<String> durakAdlar=[];
  Future<void> durakAdGetir() async{

    durakAdlar=await Duraklardao().durakAdGetir();

  }

  @override
  void initState() {
    super.initState();
    durakAdGetir();
  }

  String? secilenDurak;



  @override
  Widget build(BuildContext context) {

    final width1 = MediaQuery.of(context).size.width * 0.37;
    final width2 = MediaQuery.of(context).size.width * 0.95;

    final height1 = MediaQuery.of(context).size.height * 0.13;
    final height2 = MediaQuery.of(context).size.height * 0.60;

    iconOlustur(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("Kullanıcı Ekranı",style: TextStyle(fontSize: 24),),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Çıkış Yap",
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: BorderSide(color: Colors.white)))),
              ),)

          ],
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

                      setState(() {
                        mapController=controller;
                      });

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
                                child: Container(
                                  child: StatefulBuilder(
                                    builder: (context,setState){
                                      return  AlertDialog(
                                        title: Text("Durak Seçme Alanı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        backgroundColor: Colors.red,
                                        content: SizedBox(
                                          height: height1,
                                          width: width2,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Container(
                                                    margin:EdgeInsets.symmetric(vertical: 16),
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12),
                                                      border: Border.all(color: Colors.black,width: 4),
                                                    ),
                                                    child: Theme(
                                                      data:Theme.of(context).copyWith(
                                                        colorScheme: ThemeData().colorScheme.copyWith(
                                                          primary:Colors.white,
                                                        ),
                                                      ),
                                                      child: DropdownButtonHideUnderline(
                                                        child: DropdownButton<String>(

                                                          value: secilenDurak,
                                                          icon: Icon(Icons.arrow_drop_down),
                                                          iconSize: 36,
                                                          items: durakAdlar.map<DropdownMenuItem<String>>((String value){
                                                            return DropdownMenuItem<String>(
                                                              value: value,
                                                              child: Text("Durak : ${value}",style: TextStyle(color: Colors.black,fontSize: 20),),

                                                            );
                                                          }).toList(),

                                                          onChanged: (String? secilenVeri){
                                                            setState(() {
                                                              secilenDurak=secilenVeri;

                                                            });
                                                          },

                                                        ),
                                                      ),
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
                                            child: TextButton(
                                              child: Text("İptal",style: TextStyle(color: Colors.white),),

                                              onPressed: (){
                                                Navigator.pop(context);

                                              },

                                            ),
                                          ),
                                          TextButton(
                                            child: Text("Durak Seç",style: TextStyle(color: Colors.white),),
                                            onPressed: () async {
                                              String hangidurak=secilenDurak!;
                                              print("durak:");
                                              print(hangidurak);
                                              await DurakKisidao().DuragaKisiEkle(hangidurak,widget.username);
                                              var location=[];
                                              location=await Duraklardao().durakLatLngGetir(hangidurak);
                                              if(!location.isEmpty){

                                              }
                                              else{

                                              }
                                              GoogleMapController controller = await haritaKontrol.future;

                                              setState(() {


                                                var gidilecekKonum = CameraPosition(target: LatLng(double.parse(location[0]),double.parse(location[1])),zoom: 8,);

                                                controller.animateCamera(CameraUpdate.newCameraPosition(gidilecekKonum));

                                                Navigator.pop(context);

                                              });

                                            },
                                          ),

                                        ],
                                      );
                                    },

                                  ),
                                ),

                              )
                          ));
                    },
                    child: Text("Durak Seç"))
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

