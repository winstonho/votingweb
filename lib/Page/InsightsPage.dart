import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Page/VotingPage.dart';
import 'package:testweb/service/DatabaseService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:testweb/Model/VoterList.dart';
String id = 'hello world';
//String id = 'testing';


class Insights extends StatefulWidget {
  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insights> {

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

    resultsData.sort((a, b) => a.votes.compareTo(b.votes));
    print('sorted');

    return [
      charts.Series<Results, String>(
          id: 'votes',
          domainFn: (Results result, _) => result.numVotes,
          measureFn: (Results result, _) => result.votes,
          data: resultsData)
    ];
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<VoterList>(
        stream: DatabaseService().getVotersListStreamWithID(id),
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
  }

  Widget insights(VoterList list) {
    if (list.voterList.isEmpty)
      return Text('No votes yet');
    List<Candidate> candidates;

    if (list.voterList.isNotEmpty) candidates = list.voterList[0].candidateList;

    // print(list.voterList[0].name);
    return Scaffold(
        appBar: AppBar(title: Text('Insights')),
        body: ListView(children: [
          Text('Total number of voters: ' + list.voterList.length.toString(), style: TextStyle(fontSize: 20),),
          SizedBox(height: 50,),
          Column(
            children: List.generate(candidates.length, (index) {
              return viewGraphs(index, list);
            }),
          )
        ]));
  }

  Widget viewGraphs(
      int count,
      VoterList list,
      ) {
    // print(list.voterList[0].name);
    seriesList = createData(count, list);
    int totalVotes = 0;

    for (int i = 0; i < list.voterList.length; ++i) {
      totalVotes =
          totalVotes + list.voterList[i].candidateList[count].numberOfVote;
    }

    return Container(
        child: Column(
          children: [
            Text(list.voterList[0].candidateList[count].name + " - " + totalVotes.toString() + ' Votes.'),
            Row(
              children: [
                //Text('Total Votes: ' + totalVotes.toString()),
                Container(
                  width: 600.0,
                  height: 600.0,
                  child: barChart(),
                ),
              ],
            ),

            SizedBox(height: 50,)
          ],
        ));
  }

  barChart() {
    return charts.BarChart(
      seriesList,
      animate: true,
      vertical: true,
    );
  }
}

class Results {
  final String numVotes;
  final int votes;

  Results(this.numVotes, this.votes);
}