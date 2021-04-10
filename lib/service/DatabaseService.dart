

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Model/VoterList.dart';

class DatabaseService {
  final CollectionReference electionCollection = Firestore.instance.collection("election");
  final CollectionReference voterListCollection = Firestore.instance.collection("voterList");



  //will create a new data in database if it not in the database
  Future createElection(Election data) async {
     await electionCollection.document(data.id).setData(data.toJson());

     VoterList list = VoterList();
     list.id = data.id;
     list.electionID = data.id;
     await voterListCollection.document(data.id).setData(list.toJson());
  }

  Future updateElection(Election data) async {
    return await electionCollection
        .document(data.id)
        .setData(data.toJson());
  }

  Future getElectionWithID(String id) async {
    return await electionCollection
        .document(id).get().then((value) =>  Election().fromJson(value.data,value.reference));
  }

  Future getVoterListWithID(String id) async {
    return await voterListCollection
        .document(id).get().then((value) =>  Election().fromJson(value.data,value.reference));
  }

  Stream<Election> getElectionStreamWithID(String id)  {
    return  electionCollection
        .document(id).get().then((value) =>  Election().fromJson(value.data,value.reference)).asStream();
  }

/*
  List<String> _tockenFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data['token']);
      return doc.data['token'] as String;
    }).toList();
  }

  Future<List<String>> getDeviceTocken(String uid) async {
    return deviceCollection
        .where("userid", isEqualTo: uid)
        .snapshots()
        .map(_tockenFromSnapshot)
        .first;
  }

  List<ClassRecord> _recordToList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print("gg");
      ClassRecord temp = ClassRecord();
      temp.fromJson(doc.data);
      temp.reference = doc.reference;
      return temp;
    }).toList();
  }

  ClassInfo _classinfoFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) {
      ClassInfo temp = ClassInfo(uid: doc.data['uid']);
      temp.fromJson(doc.data);
      temp.reference = doc.reference;
      return temp;
    })
        .toList()
        .first;
  }

  List<ClassInfo> _classesListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      ClassInfo temp = ClassInfo(uid: doc.data['uid']);
      temp.fromJson(doc.data);
      temp.reference = doc.reference;
      return temp;
    }).toList();
  }



  Stream<NoticeInfoList> getInfoList() {
    try {
      return noticeInfoListCollection
          .document(MasterData.instance.user.uid)
          .snapshots()
          .map((event) {
        print(event.toString());
        MasterData.instance.infoList.fromJson(event.data);
        return MasterData.instance.infoList;
      });
    }
    catch(e)
    {
      print("error");
      print(e.toString());
    }
  }*/

}