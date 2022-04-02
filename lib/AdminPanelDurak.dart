
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yazlab2_proje2/AdminTablo.dart';
import 'package:yazlab2_proje2/database/DurakKisidao.dart';
import 'package:yazlab2_proje2/database/Duraklar.dart';
import 'package:yazlab2_proje2/database/Duraklardao.dart';

import 'AdminDurakIslemleri.dart';


class AdminPanelDurak extends StatefulWidget {
  const AdminPanelDurak({Key? key}) : super(key: key);


  @override
  State<AdminPanelDurak> createState() => _AdminPanelDurakState();
}



class _AdminPanelDurakState extends State<AdminPanelDurak> {


  late BitmapDescriptor konumIcon;

  Completer<GoogleMapController> haritaKontrol = Completer();

  var baslangicKonum = CameraPosition(target: LatLng(40.766666,29.916668),zoom: 8,);

  List<Marker> isaretler = <Marker>[];

  var gidilecekKonum = CameraPosition(target: LatLng(41.0039643,28.4517462),zoom: 10,);


  Future<void> konumaGit() async {
    GoogleMapController controller = await haritaKontrol.future;


  }
  List<Duraklar> duraklar=[];
  List listLat = [];
  List listLng = [];

  Future getBusStation() async {
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


  List<Marker> _createMarker (){
    var array= <Marker>[];

    for( var i = 0 ; i <= listLat.length-1; i++ ) {

      var x=Marker(
          markerId: MarkerId("asdsa"),
          position: LatLng( double.parse(listLat[i]), double.parse(listLng[i])),
          onTap: () {
        //this is what you're looking for!
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


  TextEditingController stationController=TextEditingController();
  TextEditingController latController=TextEditingController();
  TextEditingController lngController=TextEditingController();
  TextEditingController person_count_Controller=TextEditingController();


  Future<void> durakEkle(String stationName,String lat,String lng) async{

    await Duraklardao().durakEkle(stationName, lat, lng,0);


    Navigator.pop(context);  // pop current page
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminPanelDurak()));
  }

  Future<void> durakKisiEkle(int durak_id,int kisi_sayisi) async{

    await Duraklardao().durakKisiEkle(durak_id,kisi_sayisi);

  }

  Future<void> durakKisiSifirla(int durak_id) async{

    await Duraklardao().durakKisiSifirla(durak_id);
    await DurakKisidao().duraktakiKisileriSfirla(durak_id);

  }



  List<String> durakAdlar=[];
  String secilenDurak="";
  Future<void> durakAdGetir() async{

    durakAdlar=await Duraklardao().durakAdGetir();
    secilenDurak=durakAdlar[0];

  }


  @override
  void initState() {
    super.initState();
    durakAdGetir();

  }





  @override
  Widget build(BuildContext context) {


    final width1 = MediaQuery.of(context).size.width * 0.37;

    final height1 = MediaQuery.of(context).size.height * 0.36;
    final height2 = MediaQuery.of(context).size.height * 0.60;
    final height3 = MediaQuery.of(context).size.height * 0.25;

    return FutureBuilder<dynamic> (
      future: getBusStation(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Center(child: Text("Beklenmeyen bir hata ortaya çıktı"));
          }

          else if(snapshot.hasData){
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
                        height: height2,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: baslangicKonum,
                          markers:  Set<Marker>.of( _createMarker()),

                          onMapCreated: (GoogleMapController controller){
                            haritaKontrol.complete(controller);
                          },
                        ),
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
                                              child: Text("Durak Ekle",style: TextStyle(color: Colors.white),),
                                              onPressed: () async {

                                                durakEkle(stationController.text, latController.text, lngController.text);

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
                      ElevatedButton(
                        onPressed: (){
                          Future.delayed(
                              const Duration(seconds: 0),
                                  () => showDialog(
                                  context: context,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      child: AlertDialog(
                                        title: Text("Durağa Kişi Ekleme Alanı",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        backgroundColor: Colors.orangeAccent,
                                        content: SizedBox(
                                          height: height3,
                                          width: width1,
                                          child: Column(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 16),
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(color: Colors.black,width: 4),
                                                  ),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(

                                                      onChanged: (String? secilenVeri){
                                                        print("secilen veri $secilenVeri");
                                                        setState(() {
                                                          secilenDurak=secilenVeri!;

                                                        });
                                                      },
                                                      value: secilenDurak,
                                                      icon: Icon(Icons.arrow_drop_down),
                                                      iconSize: 36,
                                                      items: durakAdlar.map<DropdownMenuItem<String>>((String value){
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text("Durak : ${value}",style: TextStyle(color: Colors.black,fontSize: 20),),

                                                        );
                                                      }).toList(),


                                                    ),
                                                  ),
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
                                                person_count_Controller.text="";
                                                Navigator.pop(context);

                                              },

                                            ),
                                          ),
                                          TextButton(
                                            child: Text("Duraktaki kişileri sıfırla",style: TextStyle(color: Colors.white),),
                                            onPressed: () async {
                                              int id=await Duraklardao().durakIDGetir(secilenDurak);

                                              if(id>0){
                                                await durakKisiSifirla(id);

                                                setState(() async{



                                                  Navigator.pop(context);

                                                });
                                              }
                                              else{
                                                /*ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: (){
                                                      return Text("asfsfa");
                                                    }),
                                                );*/
                                              }

                                            },
                                          ),
                                          TextButton(
                                            child: Text("Kişi ekle",style: TextStyle(color: Colors.white),),
                                            onPressed: () async {
                                              int id=await Duraklardao().durakIDGetir(secilenDurak);

                                              if(id>0){
                                                await durakKisiEkle(id, int.parse(person_count_Controller.text));

                                                setState(() async{

                                                  stationController.text="";
                                                  person_count_Controller.text="";

                                                  Navigator.pop(context);

                                                });
                                              }
                                              else{
                                                /*ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: (){
                                                      return Text("asfsfa");
                                                    }),
                                                );*/
                                              }



                                            },
                                          ),

                                        ],
                                      ),
                                    ),

                                  )
                              ));
                        },
                        child: Text("Durak Kişi Ekle/Çıkar",style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminTablo()));

                        },
                        child: Text("Durak Tablo",style: TextStyle(color: Colors.white)),
                      ),
                    ],
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
