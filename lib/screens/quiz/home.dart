import 'dart:convert';
import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/common/apidata.dart';
import 'package:kloncept/common/global.dart';
import 'package:kloncept/model/content_model.dart';
import 'package:kloncept/provider/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'quiz_custom_dialog.dart';
import 'package:kloncept/common/theme.dart' as T;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    var quiz = Provider.of<ContentProvider>(context, listen: false).contentModel != null
        ? Provider.of<ContentProvider>(context, listen: false).contentModel!.quiz
        : [];
    return Scaffold(
      appBar: customAppBar(context, translate("Quiz_")),
      backgroundColor: mode.backgroundColor,
      body: quiz!.length == 0
          ? Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 40),
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 180,
                        width: 180,
                        decoration: BoxDecoration(),
                        child: Image.asset("assets/images/emptycategory.png"),
                      ),
                    ),
                    Container(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            translate("Quiz_is_not_available"),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: 200,
                            child: Text(
                              translate("There_is_no_Quiz_to_be_shown"),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: quiz.length,
              itemBuilder: _buildCategoryItem,
            ),
    );
  }

  Future<void> getQuizReport(BuildContext context, {int? id}) async {
    http.Response response = await http.get(
      Uri.parse('${APIData.quizReport}$id'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    print("Quiz Report API :-> ${APIData.quizReport}$id");
    Map<String, String> result = {};
    var body = jsonDecode(response.body);
    print('Response :-> $body');
    if (response.statusCode == 200) {
      result['question_count'] = body['question_count'].toString();
      result['correct_count'] = body['correct_count'].toString();
      result['per_question_mark'] = body['per_question_mark'].toString();
      result['total_marks'] = body['total_marks'].toString();

      AlertDialog alertDialog = AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate("Quiz Report"),
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2.0,
            ),
          ],
        ),
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -44.0,
              top: -112.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                  backgroundColor: Colors.red,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Total Questions',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        result['question_count']!,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Correct Answers',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        result['correct_count']!,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Marks Per Question',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        result['per_question_mark']!,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        'Total Obtain Marks',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        result['total_marks']!,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ],
        ),
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No data!!!'),
        ),
      );
    }
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    var quiz =
        Provider.of<ContentProvider>(context, listen: false).contentModel!.quiz;
    T.Theme mode = Provider.of<T.Theme>(context);
    return "${quiz![index].status}" == "1"
        ? Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1c2464).withOpacity(0.30),
                  blurRadius: 15.0,
                  offset: Offset(0.0, 10.0),
                  spreadRadius: -5.0,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  quiz[index].title.toString(),
                  minFontSize: 20.0,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  wrapWords: false,
                  style: TextStyle(
                      color: mode.titleTextColor, fontWeight: FontWeight.w700),
                ),
                AutoSizeText(
                  "${quiz[index].description}",
                  minFontSize: 16.0,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  wrapWords: false,
                  style: TextStyle(
                      color: mode.titleTextColor.withOpacity(0.9),
                      fontWeight: FontWeight.w500),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        translate("Type_"),
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: mode.titleTextColor.withOpacity(0.8),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${quiz[index].type}" == "1"
                            ? translate("Subjective_")
                            : translate("Objective_"),
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        translate("Per_Question_Mark"),
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: mode.titleTextColor.withOpacity(0.8),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${quiz[index].perQuestionMark}",
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        translate("Due_Days"),
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: mode.titleTextColor.withOpacity(0.8),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${quiz[index].dueDays}",
                        style: TextStyle(
                            color: mode.titleTextColor.withOpacity(0.8),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ButtonTheme(
                        height: 45,
                        minWidth: 150,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mode.easternBlueColor,
                          ),
                          onPressed: () async {
                            if (quiz[index].questions!.length == 0) {
                              print("Questions are not available!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Questions are not available!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please wait...'),
                                ),
                              );
                              await getQuizReport(context, id: quiz[index].id);
                            }
                          },
                          child: Text(
                            translate("Quiz Report"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      flex: 1,
                      child: ButtonTheme(
                        height: 45,
                        minWidth: 150,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mode.easternBlueColor,
                          ),
                          onPressed: () {
                            if (quiz[index].questions!.length == 0) {
                              print("Questions are not available!");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Questions are not available!'),
                                ),
                              );
                            } else {
                              showAlertDialog(context, quiz[index], index);
                            }
                          },
                          child: Text(
                            translate("Start_Quiz"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : SizedBox.shrink();
  }

  showAlertDialog(BuildContext context, Quiz quiz, int index) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(translate("Start_Quiz")),
      content: QuizCustomDialog(
        quiz: quiz,
        index: index,
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
