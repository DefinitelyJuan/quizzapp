import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizzapp/quiz_brain.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_model.dart';

List<Widget> scoreKeeper = [];
bool ready = false;
int score = 0;

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late QuizBrain quiz;

  @override
  void initState(){
    super.initState();
    quiz = QuizBrain();
    quiz.getQuestions().then((value) {
      setState(() {
        ready = true;
      });
    });
  }
  void buildDialog(){
    var alert = AlertDialog(
      content: Text("Juego Terminado\n$score/12",style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.white10,
      actions: [
        TextButton(
            onPressed: () {
              scoreKeeper = [];
              setState(() {
                Navigator.pop(context);
                //quiz.getQuestions();
                quiz = QuizBrain();
                quiz.getQuestions().then((value) {
                  setState(() {
                    ready = true;
                  });
                });
              });
            },
            child: Text("Aceptar"))
      ],
    );
    showDialog(context: context, builder: (BuildContext context){return alert;},barrierDismissible: false);
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: ready ? Text(quiz.getQuestionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  )
              ) : const CircularProgressIndicator()
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green)
              ),
              child: Text(
                'Verdadero',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                bool answer = quiz.getQuestionAnswer;
                if(answer){
                  scoreKeeper.add(Icon(Icons.check,color: Colors.green));
                  score ++;
                }
                else {
                  scoreKeeper.add(Icon(Icons.close, color: Colors.red));
                }
                setState(() {
                  int questionCount = quiz.nextQuestion();
                  if(questionCount == 0) {
                    ready = false;
                    buildDialog();
                  }
                });
                //The user picked true.
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red)
              ),
              child: Text(
                'Falso',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                bool answer = quiz.getQuestionAnswer;
                if(!answer){
                  scoreKeeper.add(Icon(Icons.check,color: Colors.green));
                  score ++;
                }
                else {
                  scoreKeeper.add(Icon(Icons.close, color: Colors.red));
                }
                setState(() {
                  int questionCount = quiz.nextQuestion();
                  if(questionCount == 0) {
                    ready = false;
                    buildDialog();
                  }
                });
                },
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            children: [Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scoreKeeper,

            )],
          ),
        ),
      ],
    );
  }
}




