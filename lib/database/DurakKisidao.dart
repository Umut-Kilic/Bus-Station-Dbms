import 'package:yazlab2_proje2/database/Duraklar.dart';
import 'package:yazlab2_proje2/database/Duraklardao.dart';
import 'package:yazlab2_proje2/database/Kisiler.dart';

import 'DurakKisi.dart';
import 'package:yazlab2_proje2/database/VeritabaniYardimcisi.dart';

class DurakKisidao{

  Future<List<DurakKisi>> tumDurakKisi() async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From DurakKisi,Duraklar,Kisiler Where 	DurakKisi.durak_id=Duraklar.durak_id and DurakKisi.kisi_id=Kisiler.kisi_id");

    return List.generate(maps.length, (index) {

      var satir=maps[index];
      var kisi=Kisiler(satir['kisi_id'], satir['username'], satir['email'], satir['password'], satir['role']);
      var durak=Duraklar(satir['durak_id'], satir['durak_ad'], satir['lat'], satir['lng'], satir['kisi_sayisi']);
      var dk= DurakKisi(satir['dr_id'], durak,kisi);

      return dk;


    });

  }


  Future<void> DuragaKisiEkle(String stationName,String username) async{

    int user_id=0;
    int durak_id=await Duraklardao().durakIDGetir(stationName);


    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String,dynamic>> maps=await db.rawQuery("Select * From Kisiler");

    List.generate(maps.length, (index) {

      var satir=maps[index];

      if(satir['username']==username ){
        user_id= satir['kisi_id'];

      }

    });

    if(durak_id!=0 && user_id!=0 ) {
      var bilgiler = Map<String, dynamic>();
      bilgiler["durak_id"] = durak_id;
      bilgiler["kisi_id"] = user_id;
      await db.insert("DurakKisi", bilgiler);
      await Duraklardao().durakKisiEkle(durak_id,1);
    }

  }

  Future<void> duraktakiKisileriSfirla(int durak_id) async{

    var db = await VeritabaniYardimcisi.veritabaniErisim();

    await db.delete("DurakKisi", where: "durak_id=?",whereArgs: [durak_id]);

  }



}