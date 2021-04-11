import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Page/VotingPage.dart';
import 'package:testweb/service/DatabaseService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:testweb/Model/VoterList.dart';

class ElectionResult extends StatefulWidget {
  @override
  _ElectionState createState() => _ElectionState();
}

class _ElectionState extends State<ElectionResult> {
  List<charts.Series> seriesList;

  @override
  void initState() {
    super.initState();
    //seriesList = createData(0, null);
  }

  List<charts.Series<Results, String>> createData(int topic, VoterList list) {
    print('create data');

    final resultsData = List.generate(list.voterList.length, (index) {
      int numVotes = list.voterList[index].candidateList[topic].numberOfVote;
      return Results(list.voterList[index].name, numVotes);
    });

    return [
      charts.Series<Results, String>(
          id: 'votes',
          domainFn: (Results result, _) => result.numVotes,
          measureFn: (Results result, _) => result.votes,
          data: resultsData)
    ];
  }

  Widget createCandidateView(Candidate candidate, int index) {
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

  Widget view(Election election) {
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
                    Text("Votes"),
                  ],
                ),
              ),
              // for each candidate fn
              Column(
                children: List.generate(election.candidateList.length, (index) {
                  return createCandidateView(
                      election.candidateList[index], index);
                }),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Column(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget insights(VoterList list) {
    print('insights');
    List<Candidate> candidates;

    if (list.voterList.isNotEmpty)
      candidates = list.voterList[0].candidateList;

    // print(list.voterList[0].name);
    return Scaffold(
        appBar: AppBar(title: Text('Quadratic voting for SPPT topics')),
        body: ListView(children: [
          Column(
            children: List.generate(candidates.length, (index) {
              return viewGraphs(index, list);
            }
            ),)
        ]));
  }

  barChart() {
    print('chart');
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }

  Widget viewGraphs(int count, VoterList list) {
    print('viewGraphs');
    // print(list.voterList[0].name);
    seriesList = createData(count, list);
    return Container(
      //padding: EdgeInsets.all(20),
      width: 600.0,
      height: 600.0,
      child: barChart(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VoterList>(
        stream: DatabaseService().getVotersListStreamWithID("hello world"),
        builder: (BuildContext context, AsyncSnapshot<VoterList> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if (!snapshot.hasData)
                return Text('There no election');
              else
                return insights(snapshot.data);
          }
        });

    /*
    return StreamBuilder<Election>(
        stream: DatabaseService().getElectionStreamWithID("hello world"),
        builder:
            (BuildContext context, AsyncSnapshot<Election> snapshot) {
           if(!snapshot.hasData) return Container(child: Text("no election"));
          return view(snapshot.data);
        }
        );
        */
  }
}

class Results {
  final String numVotes;
  final int votes;

  Results(this.numVotes, this.votes);
}
