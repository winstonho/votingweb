import 'package:flutter/material.dart';
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Model/VoterList.dart';
import 'package:testweb/service/DatabaseService.dart';
import 'package:testweb/Page/ElectionResultPage.dart';

class Voting extends StatefulWidget {
  final Election currentElection;

  Voting(this.currentElection);

  @override
  _VotingState createState() => _VotingState(
      List<int>.generate(currentElection.candidateList.length, (index) => 0));
}

class _VotingState extends State<Voting> {
  List<int> voteNumber;
  String name = "testing";

  _VotingState(this.voteNumber);

  void submitForm() async {
    print("testing");
    Voter vote = Voter(name: name);
    for (int i = 0; i < widget.currentElection.candidateList.length; ++i) {
      Candidate candidate = Candidate(
          name: widget.currentElection.candidateList[i].name,
          description: widget.currentElection.candidateList[i].description);

      //Candidate candidate  = widget.currentElection.candidateList[i]; //this is actually a reference.

      widget.currentElection.candidateList[i].numberOfVote += voteNumber[i];
      print("Before setting candidate.numberOfVote: " +
          widget.currentElection.candidateList[i].numberOfVote.toString());
      candidate.numberOfVote = 0;
      print("After setting candidate.numberOfVote: " +
          widget.currentElection.candidateList[i].numberOfVote.toString());
      candidate.numberOfVote += voteNumber[i];

      vote.candidateList.add(candidate);
    }
    await DatabaseService().updateVoteResult(widget.currentElection, vote);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ElectionResult()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quadratic voting for SPPT topics')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              nameTextField(),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Text("Budget"),
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
              GestureDetector(onTap: submitForm, child: createSubmitButton())
            ],
          ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text(candidate.name), Text(candidate.description)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    voteNumber[index]++;
                  });
                },
                child: Icon(Icons.arrow_drop_up),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.solid, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Votes: ' + voteNumber[index].toString())),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (voteNumber[index] > 0) voteNumber[index]--;
                  });
                },
                child: Icon(Icons.arrow_drop_down),
              )
            ],
          )
        ],
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
            color: Colors.grey,
            border: Border.all(style: BorderStyle.solid, width: 1.0),
            borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10.0),
            Center(
              child: Text('Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
            )
          ],
        ),
      ),
    );
  }

  Widget nameTextField() {
    return Form(
      child: TextField(
        onChanged: (String val){
          name = val;
        },
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white24)),
          labelText: 'Please enter name',
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54)),
        ),
      ),
    );
  }
}
