import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Model/VoterList.dart';
import 'package:testweb/service/DatabaseService.dart';
import 'package:testweb/Page/ElectionResultPage.dart';
import 'package:url_launcher/url_launcher.dart';

String id = 'hello world';
//String id = 'testing';

class Voting extends StatefulWidget {
  final Election currentElection;
  int remainingCredits;

  Voting(this.currentElection, this.remainingCredits);

  @override
  _VotingState createState() => _VotingState(
      List<int>.generate(currentElection.candidateList.length, (index) => 0));
}

class _VotingState extends State<Voting> {
  List<int> voteNumber;

  List<int> numVotes = [0, 0, 0, 0, 0, 0];

  String name = "testing";
  int totalCredits = 36;
  int cost = 0;
  int prevCost = 0;
  int totalCost = 0;

  _VotingState(this.voteNumber);

  final nameformKey = GlobalKey<FormState>();

  final _url =
      'https://towardsdatascience.com/what-is-quadratic-voting-4f81805d5a06';

  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  void submitForm() async {
    print("testing");
    Voter vote = Voter(name: name);
    Election currentElection = await DatabaseService().getElectionWithID(id);

    for (int i = 0; i < currentElection.candidateList.length; ++i) {
      Candidate candidate = Candidate(
          name: currentElection.candidateList[i].name,
          description: currentElection.candidateList[i].description);

      //Candidate candidate  = widget.currentElection.candidateList[i]; //this is actually a reference.

      currentElection.candidateList[i].numberOfVote += voteNumber[i];
      print("Before setting candidate.numberOfVote: " +
          currentElection.candidateList[i].numberOfVote.toString());
      candidate.numberOfVote = 0;
      print("After setting candidate.numberOfVote: " +
          currentElection.candidateList[i].numberOfVote.toString());
      candidate.numberOfVote += voteNumber[i];

      vote.candidateList.add(candidate);
    }
    await DatabaseService().updateVoteResult(currentElection, vote);

    /*
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ElectionResult()));
        */
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Vote Submitted. Thank you!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Back",
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quadratic voting for SPPT topics')),
      body: Center(
        child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            createInstructions('Vote for your favourite topics below.'),
            createInstructions(
                'You may vote for more than 1 topic, and allocate more than 1 vote for the topic(s) you have chosen (to express stronger preference), as long as you have enough voting credits.'),
            createInstructions(
                'The cost of your votes = number of votes^2 credits (see table below). You are given a total budget of 36 credits. '),
            SizedBox(
              height: 30,
            ),
            Container(
                height: 250,
                child: Column(children: [
                  Image(image: AssetImage('quadVoteTable.png')),
                  InkWell(
                    child: Text(
                      'Click here for more details on quadratic voting',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          color: Colors.blue),
                    ),
                    onTap: () {
                      _launchURL();
                    },
                  ),
                ])),
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                nameTextField(),
                Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Credits: " + widget.remainingCredits.toString()),
                    ],
                  ),
                ),
                // for each candidate fn
                Column(
                  children: List.generate(
                      widget.currentElection.candidateList.length, (index) {
                    return createCandidateOption(
                        widget.currentElection.candidateList[index], index);
                  }),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (nameformKey.currentState.validate()) submitForm();
                        },
                        child: createSubmitButton()),
                    SizedBox(
                      width: 50,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ElectionResult()));
                        },
                        child: createResultsButton()),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget createCandidateOption(Candidate candidate, int index) {
    return Container(
      width: 1000,
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.fromLTRB(12.0, 6.0, 12, 0),
      child: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 20,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        print((widget.remainingCredits.toString()));

                        for (int i = 0;
                            i < widget.currentElection.candidateList.length;
                            ++i) {
                          if (i == index) continue;

                          totalCost = voteNumber[i] * voteNumber[i] + totalCost;
                        }

                        if ((totalCost +
                                (voteNumber[index] + 1) *
                                    (voteNumber[index] + 1)) <=
                            36) {
                          prevCost = (voteNumber[index] * voteNumber[index]);

                          voteNumber[index]++;

                          cost = (voteNumber[index] * voteNumber[index]);
                          widget.remainingCredits =
                              widget.remainingCredits - cost + prevCost;
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Insufficient Credits!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Back",
                                      ),
                                    )
                                  ],
                                );
                              });
                        }

                        totalCost = 0;
                      });
                    },
                    child: Icon(Icons.arrow_drop_up),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        border:
                            Border.all(style: BorderStyle.solid, width: 1.0),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('Votes: ' + voteNumber[index].toString())),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (voteNumber[index] > 0) {
                          prevCost = (voteNumber[index] * voteNumber[index]);
                          voteNumber[index]--;
                          cost = (voteNumber[index] * voteNumber[index]);
                          widget.remainingCredits =
                              widget.remainingCredits - cost + prevCost;
                        }
                      });
                    },
                    child: Icon(Icons.arrow_drop_down),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget createSubmitButton() {
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
              child: Text('Submit',
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

  Widget createResultsButton() {
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
              child: Text('View Results',
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

  Widget nameTextField() {
    return Container(
      width: 500,
      child: Form(
        key: nameformKey,
        child: TextFormField(
          validator: (val) => val.isEmpty ? 'Please fill in name' : null,
          onChanged: (String val) {
            name = val;
          },
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            labelText: 'Please enter name',
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}

Text createInstructions(String text) {
  return Text(
    text,
    style:
        TextStyle(fontSize: 20, fontFamily: 'Montserrat', color: Colors.black),
  );
}
