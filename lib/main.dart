import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:testweb/Model/Candidate.dart';
import 'package:testweb/Model/Election.dart';
import 'package:testweb/Page/ElectionResultPage.dart';
import 'package:testweb/service/DatabaseService.dart';
//import 'package:uuid/uuid.dart';
import 'package:testweb/Page/VotingPage.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  Future<String> createElectionData() async {
    Election temp = Election(id: "hello world");
    temp.name = "Testing Election";
    temp.candidateList.add(Candidate(name: "dragon", description: "Dragon it the best"));
    temp.candidateList.add(Candidate(name: "tiger", description: "Tiger is the best"));
    temp.candidateList.add(Candidate(name: "lion", description: "lion is the best"));
    temp.candidateList.add(Candidate(name: "wolf", description: "wolf is the best"));
    temp.candidateList.add(Candidate(name: "dog", description: "dog is the best"));
    temp.candidateList.add(Candidate(name: "cat", description: "cat is the best"));

    await DatabaseService().createElection(temp);

    return "create election";
  }

  Future<Election> _getElection() async {

    Election temp = await DatabaseService().getElectionWithID("hello world");

    return temp;
  }

  Widget votePage()
  {
    createElectionData();
    return FutureBuilder(
        future: _getElection(),
        // a previously-obtained Future<String> or null
        builder:
            (BuildContext context, AsyncSnapshot<Election> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else if(!snapshot.hasData)
                return Text('There no election');
              else
                return Voting(snapshot.data, 36);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: votePage());

  }
}






