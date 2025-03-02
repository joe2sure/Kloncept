import 'package:cached_network_image/cached_network_image.dart';
import 'package:kloncept/model/InstituteDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import '../Widgets/appbar.dart';
import '../provider/InstituteDetailsProvider.dart';
import 'institute_tab_screen.dart';

class InstituteProfileScreen extends StatefulWidget {
  final int? instituteId;
  final String? slug;

  const InstituteProfileScreen({this.instituteId, this.slug});

  @override
  State<InstituteProfileScreen> createState() => _InstituteProfileScreenState();
}

class _InstituteProfileScreenState extends State<InstituteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, translate("Institute_Profile")),
      backgroundColor: Color(0xFFF1F3F8),
      body: FutureBuilder<InstituteDetailsModel?> (
        future: context.read<InstituteDetailsProvider>().fetchData(widget.instituteId, widget.slug) ,
        builder: (BuildContext context, AsyncSnapshot<InstituteDetailsModel?> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InstituteTabScreen(
                        instituteDetailsModel: snapshot.data,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 10.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          CircleAvatar(
                            radius: 140,
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!.institute!.first.image ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(140.0),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/placeholder/slider.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          SizedBox(height: 40),
                          Text(
                            snapshot.data!.institute!.first.title ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            snapshot.data!.institute!.first.mobile ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            snapshot.data!.institute!.first.email ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            snapshot.data!.institute!.first.address ?? "",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(height: 40),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  "${snapshot.data!.institute!.first.status}" ==
                                          "1"
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              "${snapshot.data!.institute!.first.status}" == "1"
                                  ? translate("Active_")
                                  : translate("Inactive_"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  "${snapshot.data!.institute!.first.verified}" ==
                                          "1"
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              "${snapshot.data!.institute!.first.verified}" == "1"
                                  ? translate("Verified_")
                                  : translate("Unverified_"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 25),
                          Text(
                            translate("TAP_FOR_MORE"),
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        },
      ),
    );
  }
}
