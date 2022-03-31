
import 'package:yazlab2_proje2/database/VeritabaniYardimcisi.dart';

import 'Kisiler.dart';

class Kisilerdao{


  Future<List<Kisiler>> tumKisiler() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);


    });

  }

  Future<void> kisiEkle(String username,String  email,String password,String role) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler=Map<String,dynamic>();
    bilgiler["username"]=username;
    bilgiler["email"]=email;
    bilgiler["password"]=password;
    bilgiler["role"]=role;
    await db.insert("Kisiler", bilgiler);


  }

  Future<void> kisiSil(int kisi_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();


//birden fazla parametrede whereargsa yollayabılrıız where kisiid=? and kisi_ad =? gibi
    await db.delete("Kisiler", where: "kisi_id = ?",whereArgs: [kisi_id]);

  }

  Future<void> kisiGuncelle(int kisi_id,String username,String  email,String password,String role) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var bilgiler=Map<String,dynamic>();
    bilgiler["username"]=username;
    bilgiler["email"]=email;
    bilgiler["password"]=password;
    bilgiler["role"]=role;

    await db.update("Kisiler", bilgiler,where: "kisi_id=?",whereArgs: [kisi_id]);

  }

  Future<int> kayitKontrol(String username) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select count(*) as sonuc From Kisiler where username='$username'");

    return maps[0]['sonuc'];

  }

  Future<Kisiler> kisiGetir(int kisi_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select *  From Kisiler where kisi_id=$kisi_id ");

    var satir=maps[0];
    return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);

  }

  Future<List<Kisiler>> kisiArama(String aramaKelimesi) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler where username like '%$aramaKelimesi%'");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);


    });

  }

  Future<List<Kisiler>> rastgele2KisiGetir() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler Order By RANDOM() LIMIT 2");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);


    });

  }

}