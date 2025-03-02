import 'package:cached_network_image/cached_network_image.dart';
import '../common/apidata.dart';
import '../model/about_us_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart' as T;
import '../services/http_services.dart';

class AboutUsView extends StatelessWidget {
  Widget containerOneImage(String oneImage, String oneHeading) {
    return Container(
        height: 200,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: APIData.aboutUsImages + "$oneImage",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) =>
                  Image.asset("assets/placeholder/about_us.png"),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/placeholder/about_us.png"),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [
                      0.0,
                      0.6
                    ],
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(0.0),
                    ]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                "$oneHeading",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Mada'),
              ),
            ),
          ],
        ));
  }

  Widget conGradient(String txt, List<Color> gradientColors) {
    return Container(
      height: 70,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "$txt",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Mada'),
            ),
          )),
        ],
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, 20.5),
            spreadRadius: -15.0,
          ),
        ],
      ),
    );
  }

  Widget heading(String head, Color headingColor) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$head",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
          color: headingColor,
          fontFamily: 'Mada',
        ),
      ),
    );
  }

  Widget simpleText(String txt) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        "$txt",
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
      ),
    );
  }

  Widget showImage(String img) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Color(0x1c2464).withOpacity(0.30),
            blurRadius: 15.0,
            offset: Offset(0.0, 20.5),
            spreadRadius: -15.0,
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: APIData.aboutUsImages + "$img",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) =>
            Image.asset("assets/placeholder/about_us.png"),
        errorWidget: (context, url, error) =>
            Image.asset("assets/placeholder/about_us.png"),
      ),
    );
  }

  Widget numberRow(String counta, String countb, String txta, String txtb) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$counta",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                      fontFamily: 'Mada'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$txta",
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$countb",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "$txtb",
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Mada'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gradientContainerChild(String head, String detail) {
    return Container(
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$head",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    fontFamily: 'Mada'),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "$detail",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.95), fontSize: 14.0),
              ),
            ],
          ),
        ));
  }

  Widget gradientContainer(List<About> aboutUs, int index) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6E1A52),
              Color(0xFFF44A4A),
            ]),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("${aboutUs[index].sixHeading}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                        color: Colors.white,
                        fontFamily: 'Mada')),
              ),
            ],
          ),
          gradientContainerChild(aboutUs[index].sixTxtone.toString(),
              aboutUs[index].sixDeatilone.toString()),
          gradientContainerChild(aboutUs[index].sixTxttwo.toString(),
              aboutUs[index].sixDeatiltwo.toString()),
          gradientContainerChild(aboutUs[index].sixTxtthree.toString(),
              aboutUs[index].sixDeatilthree.toString()),
        ],
      ),
    );
  }

  Widget detailPlusImageContainer(List<About> aboutUs, int index) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      height: 400,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          CachedNetworkImage(
            imageUrl: APIData.aboutUsImages + "${aboutUs[index].fiveImageone}",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Image.asset("assets/placeholder/about_us.png"),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [
                    0.05,
                    0.9
                  ],
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.0),
                  ]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 1.0),
                child: Text(
                  "${aboutUs[index].fourHeading}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontSize: 24, fontFamily: 'Mada'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "${aboutUs[index].fourText}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 14.0, fontFamily: 'Mada', color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scaffoldBody(List<About>? aboutUs, T.Theme mode) {
    return ListView.builder(
        itemCount: aboutUs!.length,
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              if (aboutUs[index].oneEnable.toString() != "0")
                containerOneImage(aboutUs[index].oneImage.toString(),
                    aboutUs[index].oneHeading.toString()),
              if (aboutUs[index].oneEnable.toString() != "0")
                conGradient(
                    aboutUs[index].oneText.toString(), mode.gradientColors),
              if (aboutUs[index].twoEnable.toString() != "0")
                heading(
                    aboutUs[index].twoHeading.toString(), mode.headingColor),
              if (aboutUs[index].twoEnable.toString() != "0")
                simpleText(aboutUs[index].twoText.toString()),
              if (aboutUs[index].twoEnable.toString() != "0")
                showImage(aboutUs[index].twoImageone.toString()),
              if (aboutUs[index].twoEnable.toString() != "0")
                conGradient(
                    aboutUs[index].twoTxtone.toString(), mode.gradientColors),
              if (aboutUs[index].twoEnable.toString() != "0")
                simpleText(aboutUs[index].twoImagetext.toString()),
              if (aboutUs[index].threeEnable.toString() != "0")
                heading(
                    aboutUs[index].threeHeading.toString(), mode.headingColor),
              if (aboutUs[index].threeEnable.toString() != "0")
                simpleText(aboutUs[index].threeText.toString()),
              if (aboutUs[index].threeEnable.toString() != "0")
                numberRow(
                    aboutUs[index].threeCountone.toString(),
                    aboutUs[index].threeCounttwo.toString(),
                    aboutUs[index].threeTxtone.toString(),
                    aboutUs[index].threeTxttwo.toString()),
              if (aboutUs[index].threeEnable.toString() != "0")
                numberRow(
                    aboutUs[index].threeCountthree.toString(),
                    aboutUs[index].threeCountfour.toString(),
                    aboutUs[index].threeTxtthree.toString(),
                    aboutUs[index].threeTxtfour.toString()),
              if (aboutUs[index].threeEnable.toString() != "0")
                numberRow(
                    aboutUs[index].threeCountfive.toString(),
                    aboutUs[index].threeCountsix.toString(),
                    aboutUs[index].threeTxtfive.toString(),
                    aboutUs[index].threeTxtsix.toString()),
              SizedBox(
                height: 10,
              ),
              if (aboutUs[index].fiveEnable.toString() != "0")
                detailPlusImageContainer(aboutUs, index),
              if (aboutUs[index].sixEnable.toString() != "0")
                gradientContainer(aboutUs, index),
              SizedBox(
                height: 25.0,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    T.Theme mode = Provider.of<T.Theme>(context);
    return FutureBuilder<List<About>>(
      future: HttpService().fetchAboutUs(),
      builder: (BuildContext context, AsyncSnapshot<List<About>> snapshot) {
        return !snapshot.hasData
            ? Center(
                child: CircularProgressIndicator(color: Color(0xfff44a4a)),
              )
            : Scaffold(
                backgroundColor: mode.bgcolor,
                body: scaffoldBody(snapshot.data, mode),
              );
      },
    );
  }
}
