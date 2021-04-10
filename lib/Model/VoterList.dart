import 'dart:convert' ;
import 'package:cloud_firestore/cloud_firestore.dart';



class Voter
{
  String name = "dummy";
  int numberOfVote = 0;
  String candidateName = '';
  DocumentReference reference;
  //List<String> bookingIdHistory = <String>[];
  //List<ClassRecord> bookingHistory= <ClassRecord>[];


  Voter({this.name , this.candidateName , this.numberOfVote = 0});


  Map<String, dynamic> toJson() =>
      {
        'numberOfVote'  : numberOfVote,
        'name'          : name,
        'candidateName' : candidateName
      };

  Voter fromJson ( Map<String, dynamic> json)
  {
    numberOfVote  = json['numberOfVote'] as int;
    name = json['name'] as String;
    candidateName = json['candidateName'] as String;
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
        'candidateList' : jsonEncode(voterList)
      };

  VoterList fromJson ( Map<String, dynamic> json, DocumentReference reference)
  {
    id  = json['id'] as String;
    electionID  = json['electionID'] as String;
    var temp = jsonDecode(json['candidateList']) as List;
    voterList =  temp.map((i) => Voter().fromJson(i)).toList();
    this.reference = reference;
    return this;
  }

}