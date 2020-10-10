import 'package:VisitApp/Core/Const_data.dart';
import 'package:VisitApp/Core/Place_data.dart';
import 'package:flutter/material.dart';

class PlaceDetailView extends StatefulWidget {
  @override
  _PlaceDetailViewState createState() => _PlaceDetailViewState();
}

class _PlaceDetailViewState extends State<PlaceDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  final PlaceData _placeData= ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: _placeData != null ? CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: false, pinned: true, snap: false,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(_placeData.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                background: Image.network(
                  _placeData.imgsrc,
                  fit: BoxFit.fill,
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: EdgeInsets.only(top: 30,bottom: 50,left: 20,right:20),
                  child: Text(                    
                    _placeData.text,
                    textAlign: TextAlign.start,
                    style: new TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20.0,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ):Text("Data pass not implement !"),
    );
  }
}
