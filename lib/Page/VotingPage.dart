import 'package:flutter/material.dart';

class Voting extends StatefulWidget {
  @override
  _VotingState createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  @override
  Widget build(BuildContext context) {
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
                   // nameTextField(),
                    Text('Name'),
                   Text("Budget"),
                  ],
                ),
              ),
              // for each candidate fn
              createCandidateOption('name', 'description'),
              createCandidateOption('name', 'description'),
              createCandidateOption('name', 'description'),
              createCandidateOption('name', 'description'),
              createCandidateOption('name', 'description'),
              createCandidateOption('name', 'description'),
              SizedBox(
                height: 50,
              ),
              GestureDetector(onTap: () {}, child: createSubmitButton())
            ],
          ),
        ),
      ),
    );
  }

  Widget createCandidateOption(String name, String description) {
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
            children: [Text(name), Text(description)],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                onPressed: () {},
                child: Icon(Icons.arrow_drop_up),
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(style: BorderStyle.solid, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Votes: ')),
              FlatButton(
                onPressed: () {},
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
        decoration: InputDecoration(
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24)),
      labelText: 'Please enter name',
      labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        ),
      ),
    );
  }
}
