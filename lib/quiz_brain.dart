import 'dart:convert';
import 'dart:io';
import 'data_model.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
class QuizBrain {

  //Atributos
  int _questionCount = 0;
  List<DataModel> questionList = [];

  String get getQuestionText {
    return questionList[_questionCount].question;
  }

  bool get getQuestionAnswer {
    return questionList[_questionCount].answer;
  }

  //Incremento
  int nextQuestion(){
    if(_questionCount < questionList.length - 1){
      _questionCount++;
    }
    else{
      _questionCount = 0;
    }
    return _questionCount;
  }

  Future<void> getQuestions() async{
    List<DataModel> questions = [];
    var res = await getResponse().whenComplete(() => null);
    var unescape = HtmlUnescape();
    Map<String, dynamic> map = jsonDecode(res.body);
    List<dynamic> data = map["results"];
    data.forEach((element) {
      bool answer = element["correct_answer"].toString().toLowerCase() == "true";
      var question = DataModel(unescape.convert(element["question"]), answer);
        questions.add(question);
    }
    );
    questionList = questions;
  }

  Future<http.Response> getResponse() async{
    final url = Uri.parse('https://opentdb.com/api.php?amount=12&category=11&type=boolean');
    final res = await http.get(url);
    return res;
  }
}