import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yazlab2_proje2/database/DurakKisidao.dart';
import 'package:yazlab2_proje2/database/Duraklardao.dart';

class AdminTablo extends StatefulWidget {

  @override
  State<AdminTablo> createState() => _AdminTabloState();
}


class _AdminTabloState extends State<AdminTablo> {
  List<List> listem=[];
  Future <List<List>> DurakGetir() async{
   listem= await Duraklardao().durakKisiSayisiGetir();

   return listem;
  }



  @override
  Widget build(BuildContext context) {
    DurakGetir();

    final width1 = MediaQuery.of(context).size.width * 1;

    final height1 = MediaQuery.of(context).size.height * 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Duraklardaki Kişi Tablosu",style: TextStyle(color: Colors.white,fontSize: 20),),
        centerTitle: true,
      ),
      body: FutureBuilder<List<List>>(
        future: DurakGetir(),
        builder: (context, snapshot){
          if(snapshot.hasData){

            List<dynamic> stationNameList=listem[0];
            List<dynamic> passangerCountList=listem[1];
            return  SingleChildScrollView(
              child: Container(
                height: height1,
                width: width1,
                child: DataTable(
                  columns: <DataColumn>[
                    mySpesicialDataColumn("Durak Adı"),
                    mySpesicialDataColumn("Kişi Sayısı"),

                  ],
                  rows:

                )

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

DataColumn mySpesicialDataColumn(String veri){
  return   DataColumn(
    label:  Expanded(
          child: Text(
            veri,
            style: TextStyle(fontSize:24,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ))
  );


}

DataCell mySpesicialDataCell(var veri){
  return DataCell(
      Center(child: Text(veri.toString(),style: TextStyle(fontSize: 20),textAlign: TextAlign.center,)));
}

List<DataRow> mySpesicialDataRow(List<dynamic> stationNameList,List<dynamic> passengerCountList,int listLength){
  List<DataRow> listem=[];
  for(int i=0;i<listLength;i++){
    listem.add(
        DataRow(cells: <DataCell>[
          mySpesicialDataCell(stationNameList[i]),
          mySpesicialDataCell(passengerCountList[i])
        ])
    );
  }
  return listem;
}