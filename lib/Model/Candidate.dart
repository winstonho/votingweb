import 'dart:convert' ;

import 'package:flutter/cupertino.dart';



class Candidate
{
  String name = "dummy";
  int numberOfVote = 0;
  //List<String> bookingIdHistory = <String>[];
  //List<ClassRecord> bookingHistory= <ClassRecord>[];


  Candidate({@required this.name});


  Map<String, dynamic> toJson() =>
  {
    'numberOfVote'  : numberOfVote,
    'name'          : name
  };

  Candidate fromJson ( Map<String, dynamic> json)
  {
    numberOfVote  = json['numberOfVote'] as int;
    name = json['name'] as String;
    return this;
  }

}
