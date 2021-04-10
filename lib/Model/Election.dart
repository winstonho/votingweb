import 'dart:convert' ;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testweb/Model/Candidate.dart';



class Election
{
  String id = '';
  String name = "dummy";
  String voterListId = '';
  DateTime startDate = new DateTime.now();
  DateTime endDate = new DateTime.now();
  List<Candidate> candidateList = <Candidate>[];
  DocumentReference reference;

  Election({this.id});

  Map<String, dynamic> toJson() =>
      {
        'id'  : id,
        'name': name,
        'startDate': startDate.toString(),
        'endDate': startDate.toString(),
        'candidateList' : jsonEncode(candidateList),
        'voterListId'   : voterListId
      };

  Election fromJson ( Map<String, dynamic> json , DocumentReference reference)
  {
    id  = json['id'] as String;
    name = json['name'] as String;
    voterListId = json['voterListId'] as String;
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    var temp = jsonDecode(json['candidateList']) as List;
    candidateList =  temp.map((i) => Candidate().fromJson(i)).toList();
    this.reference = reference;
    return this;
  }

}
