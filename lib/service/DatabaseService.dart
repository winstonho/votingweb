import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testweb/Model/Election.dart';

class DatabaseService {
  final CollectionReference electionCollection =
  Firestore.instance.collection("election");



  //will
  Future updateElection(Election data) async {
    return await electionCollection
        .document(data.uid)
        .setData(data.toJson());
  }

  Future getElectionWithID(String id) async {
    return await electionCollection
        .document(id).get().then((value) =>  Election().fromJson(value.data));
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



// Future<List<Class>> qureMyClass(String uid)
//{
// Query temp = userCollection.where('instructorID' == uid);
//temp.getDocuments();
//}

}