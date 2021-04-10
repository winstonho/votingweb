import 'dart:convert' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testweb/Model/Candidate.dart';


class Voter
{
  String name = "dummy";
  List<Candidate> candidateList = <Candidate>[];
  DocumentReference reference;
  //List<String> bookingIdHistory = <String>[];
  //List<ClassRecord> bookingHistory= <ClassRecord>[];


  Voter({this.name});


  Map<String, dynamic> toJson() =>
      {
        'name'          : name,
        'candidateList' : jsonEncode(candidateList)
      };

  Voter fromJson ( Map<String, dynamic> json)
  {
    name = json['name'] as String;
    var temp = jsonDecode(json['candidateList']) as List;
    candidateList =  temp.map((i) => Candidate().fromJson(i)).toList();
    return this;
  }

}

class VoterList
{
  String id;
  String electionID;
  List<Voter> voterList = <Voter>[];
  DocumentReference reference;




  VoterList({this.id});


  Map<String, dynamic> toJson() =>
      {
        'id'  : id,
        'electionID' : electionID,
        'voterList' : jsonEncode(voterList)
      };

  VoterList fromJson ( Map<String, dynamic> json)
  {
    id  = json['id'] as String;
    electionID  = json['electionID'] as String;
    var temp = jsonDecode(json['voterList']) as List;
    voterList =  temp.map((i) => Voter().fromJson(i)).toList();
    this.reference = reference;
    return this;
  }

}