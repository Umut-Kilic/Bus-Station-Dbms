
import 'package:yazlab2_proje2/database/Kisiler.dart';
import 'package:yazlab2_proje2/database/VeritabaniYardimcisi.dart';



class Kisilerdao{


  Future<List<Kisiler>> tumKisiler() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler");

    return List.generate(maps.length, (index) {

      var satir=maps[index];

      return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);


    });

  }

  Future<List<Kisiler>> tumKullanicilar() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler");
    List liste=[];
    List<Kisiler> liste2=[];
    List.generate(maps.length, (index) {

      var satir=maps[index];


      liste.add(Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']));
      //return Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);


    });

    for(Kisiler k in liste){
      if(k.role=="user"){
        liste2.add(k);

      }

    }
    return liste2;

  }

  Future<bool> emailCheck(String email) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select email From Kisiler");

    List liste=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];
      liste.add(satir['email']);

    });

    for(String s in liste){
      if(email==s){
        return false;
      }
    }
    return true;
  }

  Future<bool> girisYap(String username,String password) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select username,password,role From Kisiler");
    List userNames=[];
    List passwords=[];
    List roles=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];

      userNames.add(satir['username']);
      passwords.add(satir['password']);
      roles.add(satir['role']);

    });

    for(int i =0;i<roles.length;i++){
      if(userNames[i]==username && passwords[i]==password && roles[i]=="user"){
        return true;
      }
    }
    return false;
  }

  Future<bool> admingiris(String username,String password) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select username,password,role From Kisiler");
    List userNames=[];
    List passwords=[];
    List roles=[];

    List.generate(maps.length, (index) {

      var satir=maps[index];

      userNames.add(satir['username']);
      passwords.add(satir['password']);
      roles.add(satir['role']);

    });

    for(int i =0;i<roles.length;i++){
      if(userNames[i]==username && passwords[i]==password && roles[i]=="admin"){
        return true;
      }
    }
    return false;
  }


  Future<int> idGetir(String username,String email,String password) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler");

    List.generate(maps.length, (index) {

      var satir=maps[index];

      if(satir['username']==username && satir['password']==password && satir['email']==email){
        return satir['kisi_id'];
      }

    });
    return 0;

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