import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Page/InsightsPage.dart';
import 'package:testweb/service/DatabaseService.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:testweb/Model/VoterList.dart';

class ElectionResult extends StatefulWidget {
  @override
  _ElectionState createState() => _ElectionState();
}

class _ElectionState extends State<ElectionResult> {
  List<charts.Series> seriesList;
  final String password = 'MCCYSP';
  final passwordformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //seriesList = createData(0, null);
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
          SizedBox(
            width: 50,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Column(
                children: [
                  Text(candidate.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    candidate.description,
                    maxLines: 5,
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
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
            ),
          )
        ],
      ),
    );
  }

  Widget view(Election election) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                // for each candidate fn
                Column(
                  children:
                      List.generate(election.candidateList.length, (index) {
                    return createCandidateView(
                        election.candidateList[index], index);
                  }),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                    child: GestureDetector(
                  child: createInsightButton(),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Password restricted'),
                            content: Form(
                              key: passwordformKey,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                validator: (val) =>
                                    val != password ? 'Wrong password' : null,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Back",
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (passwordformKey.currentState.validate())
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Insights()));
                                },
                                child: Text(
                                  "Next",
                                ),
                              )
                            ],
                          );
                        });
                  },
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
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
*/

    return StreamBuilder<Election>(
        stream: DatabaseService().getElectionStreamWithID("hello world"),
        builder: (BuildContext context, AsyncSnapshot<Election> snapshot) {
          if (!snapshot.hasData) return Container(child: Text("no election"));
          return view(snapshot.data);
        });
  }

  Widget createInsightButton() {
    return Container(
      height: 40.0,
      width: 300,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              style: BorderStyle.solid,
              width: 1.0,
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Center(
              child: Text('View Insights',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat')),
            )
          ],
        ),
      ),
    );
  }
}
