import 'dart:convert';
import 'dart:io';
import 'package:VisitApp/Core/Const_data.dart';
import 'package:VisitApp/Core/Navigation_helper.dart';
import 'package:VisitApp/Core/Place_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool hasError = false;
  bool _checkJSONData = false;
  String error = "";

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ConstData.HomeAppBarTitle),
        ),
        body: Center(
          child: _getPlaceWidgets,
        ));
  }
  Container get _getPlaceWidgets =>
      Container(child:_dataFromFireBase);

FutureBuilder get _dataFromFireBase => FutureBuilder(
      future: _getPlaceDatas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != "null") {
            var _placeDatas = parsePlaceDatas(snapshot.data);
            var _cards = placeDatasToCardList(_placeDatas);
            return _cards;
          } else {
            error = "Veriler getirilemedi !";
            hasError = true;
            return Text(error);
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          hasError = true;
          error = "Bağlantı problemi yaşanıyor !";
          return Text(error);
        }
      });
  Future<String> _getPlaceDatas() async {
    final _response = await http.get(ConstData.PlaceDataFirebase);
    if (_response.statusCode == 200) {
      return _response.body;
    } else {
      hasError = true;
      error = "Response Status Code:" + _response.statusCode.toString();
      return null;
    }
  }


  List<PlaceData> parsePlaceDatas(String jsonData) {
    final parsed = jsonDecode(jsonData).cast<Map<String, dynamic>>();
    var result =
        parsed.map<PlaceData>((json) => PlaceData.fromJson(json)).toList();
    return result;
  }

  Widget placeDatasToCardList(List<PlaceData> placeDatas) {
    List<Card> _cards = new List<Card>();
    for (var place in placeDatas) {
      Card _card = new Card(
        margin: EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  place.title,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromRGBO(123, 65, 123, 1),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Image.network(
                place.imgsrc,
                fit: BoxFit.fill,
                width: 300,
                height: 250,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 50, right: 50),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.blue)),
                  onPressed: () {
                    Navigator.pushNamed(context, NavigationHelper.DETAIL,
                        arguments: place);
                  },
                  textColor: Colors.white,
                  child: Text(ConstData.ShowDetail.toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
              )
            ],
          ),
        ),
      );
      _cards.add(_card);
    }
    return SingleChildScrollView(
        child: Column(
      children: _cards,
    ));
  }
}
