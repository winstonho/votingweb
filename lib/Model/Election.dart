import 'dart:convert' ;

import 'package:testweb/Model/Candidate.dart';



class Election
{
  String uid;
  String name = "dummy";
  DateTime startDate = new DateTime.now();
  DateTime endDate = new DateTime.now();
  List<Candidate> candidateList = <Candidate>[];
  //List<ClassRecord> bookingHistory= <ClassRecord>[];


  Election({this.uid});


  Map<String, dynamic> toJson() =>
      {
        'id'  : uid,
        'name': name,
        'startDate': startDate.toString(),
        'endDate': startDate.toString(),
        'candidateList' : jsonEncode(candidateList)
      };

  Election fromJson ( Map<String, dynamic> json)
  {
    uid  = json['id'] as String;
    name = json['name'] as String;
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    var temp = jsonDecode(json['candidateList']) as List;
    print(temp);
    candidateList =  temp.map((i) => Candidate().fromJson(i))
    .toList();
    return this;
  }

}
