import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/provider/terms_policy_provider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsPolicy extends StatefulWidget {
  @override
  _TermsPolicyState createState() => _TermsPolicyState();
}

class _TermsPolicyState extends State<TermsPolicy> {
  Future<void> loadData() async {
    termsPolicyProvider =
        Provider.of<TermsPolicyProvider>(context, listen: false);
    await termsPolicyProvider.getData();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  TermsPolicyProvider termsPolicyProvider = TermsPolicyProvider();

  bool isLoading = true;

  Widget html(htmlContent, clr, size) {
    return HtmlWidget(
      htmlContent,
      textStyle: TextStyle(
        fontSize: size,
        color: clr,
      ),
      customStylesBuilder: (element) {
        return {'font-weight': '600', 'font-size': '16', 'align': 'justify'};
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "T&C and Policy"),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Divider(),
                    HtmlWidget(
                      termsPolicyProvider.termsPolicyModel!.termsPolicy![0].terms.toString(),
                      customStylesBuilder: (element) {
                        return {
                          'font-weight': '400',
                          'font-size': '10',
                          'align': 'justify',
                        };
                      },
                    ),
                    Divider(
                      height: 30.0,
                      thickness: 2.0,
                      color: Colors.red,
                    ),
                    Text(
                      "Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Divider(),
                    HtmlWidget(
                      termsPolicyProvider
                          .termsPolicyModel!.termsPolicy![0].policy.toString(),
                      customStylesBuilder: (element) {
                        return {
                          'font-weight': '400',
                          'font-size': '10',
                          'align': 'justify',
                        };
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
