import 'package:kloncept/Widgets/appbar.dart';
import 'package:kloncept/model/manual_payment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'manual_payment.dart';

class ManualPaymentList extends StatefulWidget {
  ManualPaymentList({this.manualPaymentModel});

  final ManualPaymentModel? manualPaymentModel;

  @override
  _ManualPaymentListState createState() => _ManualPaymentListState();
}

final scaffoldKey = new GlobalKey<ScaffoldState>();

class _ManualPaymentListState extends State<ManualPaymentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(context, "Manual Payment List"),
      backgroundColor: Color(0xFFF1F3F8),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Card(
              elevation: 4,
              child: ListTile(
                leading: Image.network(
                  widget.manualPaymentModel!.manualPayment![index].imagePath.toString(),
                  height: 40,
                  errorBuilder: (_, __, ___) {
                    return SizedBox.shrink();
                  },
                ),
                title: Text(
                  widget.manualPaymentModel!.manualPayment![index].name!
                      .toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  widget.manualPaymentModel!.manualPayment![index].detail.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onTap: () {
                  if (widget.manualPaymentModel!.manualPayment![index].status ==
                      "1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualPayment(
                          manual_payment:
                              widget.manualPaymentModel!.manualPayment![index],
                        ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: translate("Not_Active"),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
              ),
            ),
          );
        },
        itemCount: widget.manualPaymentModel!.manualPayment!.length,
      ),
    );
  }
}
