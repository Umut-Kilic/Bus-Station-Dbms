import 'Duraklar.dart';
import 'package:yazlab2_proje2/database/VeritabaniYardimcisi.dart';

class Duraklardao{


  Future<List<Duraklar>> tumDuraklar() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar");

    return List.generate(maps.length, (index) {

      var satir=maps[index];


      return Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']);


    });

  }

  Future<void> durakEkle(String stationName,String  lat,String lng,int person_count) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler=Map<String,dynamic>();
    bilgiler["durak_ad"]=stationName;
    bilgiler["lat"]=lat;
    bilgiler["lng"]=lng;
    bilgiler["kisi_sayisi"]=person_count;
    await db.insert("Duraklar", bilgiler);


  }


  Future<int> durakIDGetir(String station_name) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar");

    List<Duraklar> liste=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];

      liste.add(Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']));


    });

    for(int i=0;i<liste.length;i++){
      if(liste[i].durak_ad==station_name){
        return liste[i].durak_id;
      }
    }
    return 0;

  }

  Future<List<String>> durakAdGetir() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar");

    List<String> liste=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];

      liste.add(satir['durak_ad']);


    });

    return liste;

  }


  Future<List> durakLatLngGetir(String station_name) async{
    var location = [];

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar");

    List<Duraklar> liste=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];

      liste.add(Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']));


    });

    for(int i=0;i<liste.length;i++){
      if(liste[i].durak_ad==station_name){
        location.add(liste[i].lat);
        location.add(liste[i].lng);

        return location; liste[i].lng;
      }
    }
    return location;

  }




  Future<void> durakKisiEkle(int durak_id,int kisi_sayisi) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar Where durak_id=$durak_id");

    int kisi=maps[0]["kisi_sayisi"];
    kisi+=kisi_sayisi;
    var bilgiler=Map<String,dynamic>();
    bilgiler["kisi_sayisi"]= kisi;
    await db.update("Duraklar", bilgiler,where: "durak_id=?",whereArgs: [durak_id]);

  }

  Future<void> durakKisiSifirla(int durak_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler=Map<String,dynamic>();

    bilgiler["kisi_sayisi"]=0;
    await db.update("Duraklar", bilgiler,where: "durak_id=?",whereArgs: [durak_id]);


  }


  Future<void> durakSil(int durak_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();


//birden fazla parametrede whereargsa yollayabılrıız where durakid=? and durak_ad =? gibi
    await db.delete("Duraklar", where: "durak_id = ?",whereArgs: [durak_id]);

  }

  Future<void> durakGuncelle(int durak_id,String stationName,String  lat,String lng,int kisi_sayisi) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler=Map<String,dynamic>();
    bilgiler["durak_ad"]=stationName;
    bilgiler["lat"]=lat;
    bilgiler["lng"]=lng;
    bilgiler["kisi_sayisi"]=kisi_sayisi;

    await db.update("Duraklar", bilgiler,where: "durak_id=?",whereArgs: [durak_id]);

  }




  Future<int> kayitKontrol(String stationName) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select count(*) as sonuc From Duraklar where username='$stationName'");

    return maps[0]['sonuc'];

  }

  Future<Duraklar> durakGetir(int durak_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select *  From Duraklar where durak_id=$durak_id ");

    var satir=maps[0];
    return Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']);

  }

  Future<List<Duraklar>> durakArama(String aramaKelimesi) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar where durak_ad like '%$aramaKelimesi%'");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']);


    });

  }



  Future<List<Duraklar>> rastgele2durakGetir() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Duraklar Order By RANDOM() LIMIT 2");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']);


    });

  }
}