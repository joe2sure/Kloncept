import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kloncept/Screens/quiz/quiz_submitted.dart';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:kloncept/common/theme.dart' as T;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion>? questions;
  final Quiz? quiz;

  const QuizScreen({Key? key, @required this.questions, this.quiz})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController answer = TextEditingController();
  final Map<String, String> _questionIds = {};
  final Map<String, String> _objAnswers = {};
  final Map<String, String> _cAnswers = {};
  final Map<String, String> _subAnswers = {};

  bool isSubmiting = false;

  @override
  Widget build(BuildContext context) {
    QuizQuestion question = widget.questions![_currentIndex];
    log("Questions : ${question.toJson()}");
    final List<dynamic> options = question.incorrectAnswers as List<dynamic>;
    if (!options.contains(question.correct)) {
      options.add(question.correct);
      options.shuffle();
    }

    T.Theme mode = Provider.of<T.Theme>(context);

    return WillPopScope(
      onWillPop: () async{
        bool? result= await _onWillPop();
        if(result == null){
          result = false;
        }
        return result;
      },
      child: Scaffold(
        backgroundColor: mode.backgroundColor,
        key: _key,
        appBar: customAppBar(context, widget.quiz!.course.toString()),
        body: LoadingOverlay(
          isLoading: isSubmiting,
          progressIndicator: CircularProgressIndicator(
            color: Colors.red,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${_currentIndex + 1}.",
                      style: TextStyle(
                          fontSize: 22,
                          color: mode.titleTextColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        HtmlUnescape()
                            .convert(widget.questions![_currentIndex].question.toString()),
                        softWrap: true,
                        style: MediaQuery.of(context).size.width > 800
                            ? TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w500,
                                color: mode.titleTextColor,
                              )
                            : TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                                color: mode.titleTextColor,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (widget.quiz!.type.toString() == "null")
                      ...options.map(
                        (option) => RadioListTile(
                          title: Text(
                            HtmlUnescape().convert("$option"),
                            style: MediaQuery.of(context).size.width > 800
                                ? TextStyle(fontSize: 30.0)
                                : null,
                          ),
                          groupValue: _answers[_currentIndex],
                          value: option,
                          activeColor: mode.easternBlueColor,
                          onChanged: (value) {
                            setState(
                              () {
                                _answers[_currentIndex] = option;
                                _questionIds["${_currentIndex + 1}"] = widget
                                    .questions![_currentIndex].id
                                    .toString();
                                _subAnswers["${_currentIndex + 1}"] = "";

                                widget.questions![_currentIndex].allAnswers!
                                    .forEach(
                                  (key, value) {
                                    if (value == option) {
                                      _objAnswers["${_currentIndex + 1}"] = key;
                                    }
                                  },
                                );
                                widget.questions![_currentIndex].allAnswers!
                                    .forEach(
                                  (key, value) {
                                    if (value ==
                                        widget
                                            .questions![_currentIndex].correct) {
                                      _cAnswers["${_currentIndex + 1}"] = key;
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    if (widget.quiz!.type.toString() == "1")
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: TextField(
                          onChanged: (ans) {
                            _questionIds["${_currentIndex + 1}"] =
                                widget.questions![_currentIndex].id.toString();
                            _subAnswers["${_currentIndex + 1}"] = ans;
                            _objAnswers["${_currentIndex + 1}"] = "";
                            _cAnswers["${_currentIndex + 1}"] = "";
                          },
                          autofocus: true,
                          controller: answer,
                          maxLines: 5,
                          minLines: 3,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: translate("Enter_answer"),
                            labelText: translate("Answer_"),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (_currentIndex > 0)
                          ButtonTheme(
                            height: 45,
                            minWidth: 100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mode.easternBlueColor,
                                padding: MediaQuery.of(context).size.width > 800
                                    ? const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                        horizontal: 64.0,
                                      )
                                    : null,
                              ),
                              child: Text(
                                translate("Previous_"),
                                style: MediaQuery.of(context).size.width > 800
                                    ? TextStyle(fontSize: 30.0)
                                    : TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 16.0),
                              ),
                              onPressed: _previous,
                            ),
                          ),
                        ButtonTheme(
                          height: 45,
                          minWidth: 100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mode.easternBlueColor,
                              padding: MediaQuery.of(context).size.width > 800
                                  ? const EdgeInsets.symmetric(
                                      vertical: 20.0,
                                      horizontal: 64.0,
                                    )
                                  : null,
                            ),
                            child: Text(
                              _currentIndex == (widget.questions!.length - 1)
                                  ? translate("Submit_")
                                  : translate("Next_"),
                              style: MediaQuery.of(context).size.width > 800
                                  ? TextStyle(fontSize: 30.0)
                                  : TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontSize: 16.0),
                            ),
                            onPressed: _nextSubmit,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _previous() {
    setState(() {
      _currentIndex--;
      if (widget.quiz!.type == "1") {
        if (_subAnswers["${_currentIndex + 1}"] != null)
          answer.text = _subAnswers["${_currentIndex + 1}"]!;
        else
          answer.text = "";
      }
    });
  }

  Future<void> _nextSubmit() async {
    if (_answers[_currentIndex] == null &&
        widget.quiz!.type.toString() == "null") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate("You_must_select_an_answer_to_continue"),
          ),
        ),
      );
      return;
    } else if (answer.text == "" && widget.quiz!.type.toString() == "1") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            translate("You_must_write_answer_to_continue"),
          ),
        ),
      );
      return;
    }

    if (_currentIndex < (widget.questions!.length - 1)) {
      setState(() {
        _currentIndex++;
        if (widget.quiz!.type == "1") {
          if (_subAnswers["${_currentIndex + 1}"] != null)
            answer.text = _subAnswers["${_currentIndex + 1}"]!;
          else
            answer.text = "";
        }
      });
    } else {
      if (widget.quiz!.type == null) {
        await submit();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) =>
                QuizSubmitted(questions: widget.questions, answers: _answers)));
      } else {
        await submit();
      }
    }
  }

  Future<void> submit() async {
    print("Course Id : ${widget.quiz!.courseId}");
    print("Topic Id : ${widget.quiz!.id}");
    print("Question Ids : $_questionIds");
    print("Question Ids : " + jsonEncode(_questionIds));
    print("Subjective Answers : $_subAnswers");
    print("Subjective Answers : " + jsonEncode(_subAnswers));
    print("Objective Answers : $_objAnswers");
    print("Objective Answers : " + jsonEncode(_objAnswers));
    print("Correct Answers : $_cAnswers");
    print("Correct Answers : " + jsonEncode(_cAnswers));
    await _submitQuiz();
  }

  Future<void> _submitQuiz() async {
    setState(() {
      isSubmiting = true;
    });

    Dio dio = new Dio();

    String url = APIData.quizSubmit + APIData.secretKey;

    print("Submit Quiz API - $url");

    log("Bearer " + authToken);

    var _body;

    _body = FormData.fromMap({
      "course_id": widget.quiz!.courseId,
      "topic_id": widget.quiz!.id,
      "question_id": jsonEncode(_questionIds),
      "canswer": jsonEncode(_cAnswers),
      "answer": jsonEncode(_objAnswers),
      "txt_answer": jsonEncode(_subAnswers),
    });

    Response response;
    try {
      response = await dio.post(
        url,
        data: _body,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer " + authToken,
            HttpHeaders.acceptHeader: "Application/json",
          },
        ),
      );

      print("Status Code: " + "${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
            msg: translate("Quiz_Submitted_Successfully"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
        if (widget.quiz!.type == "1") {
          Navigator.pop(context);
        }
      } else if (response.statusCode == 402) {
        Fluttertoast.showToast(
            msg: translate("Quiz_Already_Submitted"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
        if (widget.quiz!.type == "1") {
          Navigator.pop(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: translate("Failed_"),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        await Future.delayed(Duration(seconds: 3));
      }
    } catch (e) {
      print('Exception : $e');
      Fluttertoast.showToast(
          msg: translate("Failed_"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      await Future.delayed(Duration(seconds: 3));
    }
    setState(() {
      isSubmiting = false;
    });
  }

  Future<bool?> _onWillPop() async {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(translate("Are_you_sure_you_want_to_quit_the_quiz")),
          title: Text(translate("Warning_")),
          actions: <Widget>[
            TextButton(
              child: Text(translate("Yes_")),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text(translate("No_")),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }
}
