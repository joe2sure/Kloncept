import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/localization/language_model.dart';
import 'package:kloncept/localization/language_provider.dart';
import 'package:kloncept/screens/bottom_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  bool isLoading = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController language = TextEditingController();

  LanguageProvider? languageProvider = LanguageProvider();
  List<String>? languageList = [];

  @override
  void initState() {
    super.initState();
    languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    var lang = languageProvider!.languageModel!.language;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      languageProvider!.languageModel!.language!.forEach((element) {
        languageList!.add(element.name.toString());
      });

      for (Language? language in lang as List<Language>) {
        languageList!.add(language!.name.toString());
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    language.text = languageProvider!.chooselanguage;
    return Scaffold(
      appBar: customAppBar(context, translate("Language_Setting")),
      body: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(
          color: Colors.red,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 0.0,
              child: Container(
                // padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xFFeaecf2),
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(0xFFf6f8fa),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFeaecf2),
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          translate('Choose_Language'),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF777e8f)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        child: TextFormField(
                          onTap: () {
                            suggestionPopup(
                                textEditingController: language,
                                list: languageList);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return translate("Please_choose_Language");
                            }
                            return null;
                          },
                          controller: language,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: translate("Choose_Language"),
                            labelText: translate("Language_"),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xfff44a4a),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            translate("Save_"),
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            setState(() {
                              isLoading = true;
                            });
                            await languageProvider!.changeLanguageCode(
                                language: language.text, context: context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyBottomNavigationBar(pageInd: 0),
                              ),
                            ).then((value) => setState(() {}));
                          }
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void suggestionPopup(
      {TextEditingController? textEditingController, List<String>? list}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -40.0,
                  top: -40.0,
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
                Container(
                  height: 250.0,
                  child: SuggestionWidget(
                      textEditingController: textEditingController, list: list),
                ),
              ],
            ),
          );
        });
  }
}

class SuggestionWidget extends StatefulWidget {
  SuggestionWidget({this.textEditingController, this.list});

  final TextEditingController? textEditingController;
  final List<String>? list;

  @override
  _SuggestionWidgetState createState() => _SuggestionWidgetState();
}

class _SuggestionWidgetState extends State<SuggestionWidget> {
  TextEditingController controller = TextEditingController();
  String? filter = '';
  String selectedLanguage = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              autofocus: true,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                hintText: "Search...",
              ),
              controller: controller,
            )),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: _buildListView(),
          ),
        )
      ],
    );
  }

  Widget _buildListView() {
    return Container(
      height: 300,
      width: 200,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.list!.length,
          itemBuilder: (BuildContext context, int index) {
            if (filter == null || filter == "") {
              return _buildRow(widget.list![index]);
            } else {
              if (widget.list![index]
                  .toLowerCase()
                  .contains(filter!.toLowerCase())) {
                return _buildRow(widget.list![index]);
              } else {
                return Container();
              }
            }
          }),
    );
  }

  Widget _buildRow(String text) {
    // var languageProvider =
    //     Provider.of<LanguageProvider>(context, listen: false);

    return GestureDetector(
      child: ListTile(
        title: Text(text),
      ),
      onTap: () {
        controller.text = text;
        widget.textEditingController!.text = text;
        Navigator.of(context).pop();
        setState(() {
          selectedLanguage = text; // Set the selected language
        });
      },
    );
  }
}
