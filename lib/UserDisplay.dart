
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class UserDisplay extends StatefulWidget {
  const UserDisplay({Key? key}) : super(key: key);

  @override
  State<UserDisplay> createState() => _UserDisplayState();
}

class _UserDisplayState extends State<UserDisplay> {

  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();

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

    final width1 = MediaQuery.of(context).size.width * 0.37;

    final height1 = MediaQuery.of(context).size.height * 0.13;
    final height2 = MediaQuery.of(context).size.height * 0.60;

    iconOlustur(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ekranı"),
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
              RaisedButton(
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
                                child: AlertDialog(
                                  title: Text("Durak Seçme Alanı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                                          Navigator.pop(context);

                                        },

                                      ),
                                    ),
                                    TextButton(
                                      child: Text("Durak Seç",style: TextStyle(color: Colors.white),),
                                      onPressed: () async {


                                        setState(() async{


                                          stationController.text="";
                                          latController.text="";
                                          lngController.text="";

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
                  child: Text("Durak Seç"))
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

