import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:inspection_flutter_app/Activity/WorkList.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:inspection_flutter_app/Resources/Strings.dart' as s;
import 'package:inspection_flutter_app/Resources/ColorsValue.dart' as c;
import 'package:inspection_flutter_app/Resources/url.dart' as url;
import 'package:inspection_flutter_app/Resources/ImagePath.dart' as imagePath;
import '../DataBase/DbHelper.dart';
import '../Layout/ReadMoreLess.dart';
import '../Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VillageListFromGeoLocation extends StatefulWidget {
  final villageList;
  VillageListFromGeoLocation({this.villageList});
  @override
  State<VillageListFromGeoLocation> createState() =>
      _VillageListFromGeoLocationState();
}

class _VillageListFromGeoLocationState
    extends State<VillageListFromGeoLocation> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  var dbHelper = DbHelper();
  var dbClient;
  bool noDataFlag = false;
  bool villageListFlag = false;

  @override
  void initState() {
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    dbClient = await dbHelper.db;
    if (widget.villageList.length > 0) {
      noDataFlag = false;
      villageListFlag = true;
    } else {
      noDataFlag = true;
      villageListFlag = false;
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: c.colorPrimary,
            centerTitle: true,
            elevation: 2,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
                      alignment: Alignment.center,
                      child: Text(
                        s.village_list,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: c.white,
            child:Stack(children: [
            Visibility(
              visible: villageListFlag,
              child: Container(
                color: c.white,
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: ListView.builder(
                  itemCount: widget.villageList == null
                      ? 0
                      : widget.villageList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        List schemeItems = [];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WorkList(
                                  schemeList: schemeItems,finYear:'',dcode: widget.villageList[index][s.key_dcode].toString(),bcode: widget.villageList[index][s.key_bcode].toString(),
                                  pvcode:widget.villageList[index][s.key_pvcode].toString(),scheme:  '',flag: 'geo',
                                )));
                      },
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // clipBehavior is necessary because, without it, the InkWell's animation
                        // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                        // This comes with a small performance cost, and you should not set [clipBehavior]
                        // unless you need it.
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: IntrinsicHeight(
                    child:Row(
                          children: [
                            Container(
                              width: 10,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10),
                                    topRight: const Radius.circular(0),
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(0),
                                  ),
                                  gradient: LinearGradient(
                                      colors: [
                                        c.colorPrimary,
                                        c.colorAccentverylight,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight)),
                              child: Text(
                                "",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: c.grey_10),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.villageList[index][s.key_pvname],
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: c.grey_10),
                              ),
                            ),
                          ],
                        ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: noDataFlag,
              child: Align(
                alignment: AlignmentDirectional.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    s.no_village,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            )
          ]),),
        ));
  }

}

/*
class WorkListFromGeoLocation extends StatefulWidget {
  final completedWorkList;
  final ongoingWorkList;
  WorkListFromGeoLocation({this.completedWorkList, this.ongoingWorkList});
  @override
  State<WorkListFromGeoLocation> createState() =>
      _WorkListFromGeoLocationState();
}

class _WorkListFromGeoLocationState extends State<WorkListFromGeoLocation> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  var dbHelper = DbHelper();
  var dbClient;
  bool noDataFlag = false;
  bool workListFlag = false;
  List<bool> showFlag=[];
  int flag = 1;
  List workList = [];
  @override
  void initState() {
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    dbClient = await dbHelper.db;

    if (widget.ongoingWorkList.length > 0) {
      workList = [];
      workList.addAll(widget.ongoingWorkList);
      flag = 1;
      noDataFlag = false;
      workListFlag = true;
    } else if (widget.completedWorkList.length > 0) {
      workList = [];
      workList.addAll(widget.completedWorkList);
      flag = 2;
      noDataFlag = false;
      workListFlag = true;
    } else {
      workList = [];
      flag = 1;
      noDataFlag = true;
      workListFlag = false;
    }
    for(int i=0;i<workList.length;i++){
      showFlag.add(false);
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: c.colorPrimary,
            centerTitle: true,
            elevation: 2,
            title: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
                      alignment: Alignment.center,
                      child: Text(
                        s.work_list,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: c.bg_screen,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            flag = 1;
                            if (widget.ongoingWorkList.length > 0) {
                              workList = [];
                              workList.addAll(widget.ongoingWorkList);
                              noDataFlag = false;
                              workListFlag = true;
                            } else {
                              workList = [];
                              noDataFlag = true;
                              workListFlag = false;
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width,
                          alignment: AlignmentDirectional.center,
                          decoration: new BoxDecoration(
                              color: flag == 1 ? c.colorAccent : c.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(30),
                                topRight: const Radius.circular(0),
                                bottomLeft: const Radius.circular(30),
                                bottomRight: const Radius.circular(0),
                              )),
                          child: Text(
                            s.ongoing_works+' ('+widget.ongoingWorkList.length.toString()+') ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: flag == 1 ? c.white : c.grey_8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            flag = 2;
                            if (widget.completedWorkList.length > 0) {
                              workList = [];
                              workList.addAll(widget.completedWorkList);
                              noDataFlag = false;
                              workListFlag = true;
                            } else {
                              workList = [];
                              noDataFlag = true;
                              workListFlag = false;
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
                          padding: EdgeInsets.all(5),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          alignment: AlignmentDirectional.center,
                          decoration: new BoxDecoration(
                              color: flag == 2 ? c.colorAccent : c.white,
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(0),
                                topRight: const Radius.circular(30),
                                bottomLeft: const Radius.circular(0),
                                bottomRight: const Radius.circular(30),
                              )), // Align however you like (i.e .centerRight, centerLeft)
                            child:Text(
                            s.completed_works+' ('+widget.completedWorkList.length.toString()+') ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: flag == 2 ? c.white : c.grey_8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(children: [
                    Visibility(
                      visible: workListFlag,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: ListView.builder(
                          itemCount: workList == null ? 0 : workList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return                              InkWell(
                                onTap: () {},
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),

                                  ),

                                  // clipBehavior is necessary because, without it, the InkWell's animation
                                  // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                                  // This comes with a small performance cost, and you should not set [clipBehavior]
                                  // unless you need it.
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child:  ClipPath(
                                      clipper: ShapeBorderClipper(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(3))),
                                child: Container(
                                  width: 10,
                                padding: EdgeInsets.fromLTRB(10,5,5,5),
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: c.colorAccent, width: 5),
                                ),
                              ),
                              child: Container(
                                child: Column(children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () {

                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 5, 10, 0),
                                            child: Image.asset(
                                              imagePath.action,
                                              height: 35,
                                              width: 40,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                s.work_id,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_work_id]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                s.work_name,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 0, 5, 0),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_work_name]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                s.stage_name,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 0, 5, 0),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_stage_name]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                s.work_type_name,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_work_type_name]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                s.scheme,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Text(
                                                ' : ',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: c.grey_8),
                                                overflow:
                                                TextOverflow.clip,
                                                maxLines: 1,
                                                softWrap: true,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_scheme_name]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    0, 10, 0, 10),
                                                child: Text(
                                                  s.financial_year,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    0, 10, 0, 10),
                                                child:Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Container(
                                                margin:
                                                EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child: Align(
                                                  alignment:
                                                  AlignmentDirectional
                                                      .topStart,
                                                  child: ExpandableText(
                                                      workList[index][s
                                                          .key_fin_year]
                                                          .toString(),
                                                      trimLines: 2),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: (){
                                                  setState(() {
                                                    showFlag[index]=!showFlag[index];
                                                  });

                                                },
                                                child:Container(
                                                  alignment:
                                                  Alignment.topLeft,
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child: Image.asset(
                                                      imagePath
                                                          .arrow_down_icon,
                                                      color: c
                                                          .primary_text_color2,
                                                      height: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: showFlag[index],
                                    child: AnimatedSwitcher(
                                      duration: Duration(seconds: 5),
                                      child:showFlag[index] ? Container(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.district,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_dname]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.block,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 5, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_bname]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.village,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 5, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_pvname]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.town_panchayat,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_townpanchayat_name]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.municipality,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_municipality_name]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.corporation,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_corporation_name]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ), Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.as_value,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_as_value]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ), Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.ts_value,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_ts_value]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ), Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.agreement_work_orderdate,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_work_order_date]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ), Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.as_date,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_as_value]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ), Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  s.ts_date,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 0,
                                                child: Text(
                                                  ' : ',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: c.grey_8),
                                                  overflow:
                                                  TextOverflow.clip,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  margin:
                                                  EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),
                                                  child: Align(
                                                    alignment:
                                                    AlignmentDirectional
                                                        .topStart,
                                                    child: ExpandableText(
                                                        workList[index][s
                                                            .key_ts_date]
                                                            .toString(),
                                                        trimLines: 2),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),

                                    ): SizedBox(),
                                    ),
                                  ),
                                ]),
                              )),
                                )));
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: noDataFlag,
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            s.no_village,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ));
  }
}
*/
