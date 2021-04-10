import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/service/DatabaseService.dart';

class ElectionResult extends StatefulWidget {
  @override
  _ElectionState createState() => _ElectionState();
}

class _ElectionState extends State<ElectionResult> {


  Widget createCandidateView(Candidate candidate,int index) {
    return Container(
      width: 1000,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(12.0, 6.0, 12, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text(candidate.name), Text(candidate.description)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.solid, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(candidate.numberOfVote.toString())),
            ],
          )
        ],
      ),
    );
  }

  Widget view(Election election)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Quadratic voting for SPPT topics')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Name'),
                    Text("NumberOFVote"),
                  ],
                ),
              ),
              // for each candidate fn
              Column(
                children: List.generate(election.candidateList.length, (index) {
                  return createCandidateView(election.candidateList[index],index);}
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Election>(
        stream: DatabaseService().getElectionStreamWithID("hello world"),
        builder:
            (BuildContext context, AsyncSnapshot<Election> snapshot) {
           if(!snapshot.hasData) return Container(child: Text("no election"));
          return view(snapshot.data);
        });
  }
}

