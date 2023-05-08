import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:inspection_flutter_app/Activity/RdprOnlineWorkListFromFilter.dart';
import 'package:inspection_flutter_app/Layout/ReadMoreLess.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inspection_flutter_app/Resources/Strings.dart' as s;
import 'package:inspection_flutter_app/Resources/ColorsValue.dart' as c;
import 'package:inspection_flutter_app/Resources/url.dart' as url;
import 'package:inspection_flutter_app/Resources/ImagePath.dart' as imagePath;
import '../DataBase/DbHelper.dart';
import '../ModelClass/ModelClass.dart';
import '../Resources/ColorsValue.dart';
import '../Resources/ImagePath.dart';
import '../Resources/Strings.dart';
import '../Resources/global.dart';
import '../Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Work_detailed_ViewScreen extends StatefulWidget {
  @override


  final flag;
  final selectedRDPRworkList;
  final selectedOtherWorkList;
  final selectedATRWorkList;
  final imagelist;

  Work_detailed_ViewScreen({this.selectedRDPRworkList, this.flag,this.imagelist,this.selectedOtherWorkList,this.selectedATRWorkList});
  State<Work_detailed_ViewScreen> createState() => Work_detailed_ViewScreenState();
}
class Work_detailed_ViewScreenState extends State<Work_detailed_ViewScreen> {
  var appBarvisibility = true;
  bool isWorklistAvailable = false;
  late SharedPreferences prefs;
  Utils utils = Utils();
  bool noDataFlag = false;
  bool imageListFlag = false;
  List workList = [];
  List ImageList = [];
  List<Map<String, String>> img_jsonArray = [];
  List<Map<String, String>> img_jsonArray_val = [];
  String town_type = "T";
  String inspection_id="";
  String work_id="";
  String action_taken_id="";
  String other_work_inspection_id="";
  String type="";
  String area_type="";

  @override
  void initState() {
    super.initState();
    setState(() {
     if(widget.flag=="other")
       {
         print("FLAG#####"+widget.flag);
         getSavedOtherWorkDetails();
       }
     else if(widget.flag=="rdpr"){
       getWorkDetails();
      }
     else if(widget.flag=="atr")
     {
       getAtrWorkDetails();

     }
    });

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
        backgroundColor: c.ca1,
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          elevation: 2,
          automaticallyImplyLeading: true,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    transform: Matrix4.translationValues(80, 2, 15),
                    alignment: Alignment.center,
                    child: Visibility(
                        visible: appBarvisibility,
                        child: Text(
                         "Inspection Taken",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
              ],
            ),
          ),
          /* actions: <Widget>[
            Padding(padding: EdgeInsets.only(top: 8),)
          ],*/
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              color: ca1,
              child: Column(
                children: [
                  widget.flag=="other"? _OtherWorkList():_WorkList(),
                  widget.flag=="atr"? _ATRWorkList():_WorkList(),
                  Container(
                    child:Padding(
                      padding: EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10),
                        child: Text(
                          "Photos",style: TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 15
                        ),
                        )
                    ),
                  ),
                  _Photos(),
                ],
              )),
        ),
      ),
    );
  }
  _WorkList() {
    return Container(
        color: ca1,
        child: Padding(
          padding: EdgeInsets.only(top: 20,left: 15,right: 15),
         child:Stack(
           children: [
             Visibility(
                 child:Container(
               child: ListView.builder(
                   physics: NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                    itemCount: 1,
                   itemBuilder: (BuildContext context,int index)
            {
              inspection_id=widget.selectedRDPRworkList[index][s.key_inspection_id].toString();
              town_type=widget.selectedRDPRworkList[index][s.key_town_type];

            return InkWell(
            child:Card(
            elevation: 5,
            color: c.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
            ),
            ),
            clipBehavior: Clip.hardEdge,
            child: ClipPath(
            clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20))),
            child: Container(
            child: Container(
            child: Column(children: [
            Container(
            child: Padding(
            padding: EdgeInsets.all(27),
            child: Column(children: [
            Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
            Expanded(
            flex: 1,
            child: Text(
            s.work_id,
            style: TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.normal,
            color: c.black),
            overflow:
            TextOverflow.clip,
            maxLines: 1,
            softWrap: true,
            ),
            ),
            Expanded(
            flex: 0,
            child: Text(
            ':',
            style: TextStyle(
            fontSize: 15,
            fontWeight:
            FontWeight.normal,
            color: c.black),
            overflow:
            TextOverflow.clip,
            maxLines: 1,
            softWrap: true,
            ),
            ),
            Expanded(
            flex: 1,
            child: Text(
                work_id=widget.selectedRDPRworkList[index][s.key_work_id].toString(),
            style: TextStyle(
            color: c.black),
            maxLines: 1),
            ),
            ],
            ),
            SizedBox(
            height: 10,
            ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      s.status,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.normal,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      ':',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.normal,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(widget.selectedRDPRworkList[index][s.key_status_name].toString(),
                        style: TextStyle(
                            color: c.black),
                        maxLines: 1),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      s.work_name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      ':',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.normal,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(widget.selectedRDPRworkList[index][s.key_work_name],
                        style: TextStyle(
                            color: c.black),
                        maxLines: 4),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      s.description,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.bold,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      ':',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.normal,
                          color: c.black),
                      overflow:
                      TextOverflow.clip,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(widget.selectedRDPRworkList[index][s.key_description],
                        style: TextStyle(
                          fontSize: 15,
                            color: c.black),
                        maxLines: 1),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
            )
            )
            )
            ]
            )
            ))
            )
            ));
            }
        )
    )
    )
    ])));
  }
  _ATRWorkList() {
    return Container(
        color: ca1,
        child: Padding(
            padding: EdgeInsets.only(top: 20,left: 15,right: 15),
            child:Stack(
                children: [
                  Visibility(
                      visible: widget.flag=="other"?false:true,
                      child:Container(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (BuildContext context,int index)
                              {
                                action_taken_id=widget.selectedATRWorkList[index][s.key_action_taken_id].toString();
                                inspection_id=widget.selectedATRWorkList[index][s.key_inspection_id].toString();
                                return InkWell(
                                    child:Card(
                                        elevation: 5,
                                        color: c.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15),
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15),
                                          ),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: ClipPath(
                                            clipper: ShapeBorderClipper(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(20))),
                                            child: Container(
                                                child: Container(
                                                    child: Column(children: [
                                                      Container(
                                                          child: Padding(
                                                              padding: EdgeInsets.all(27),
                                                              child: Column(children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        s.work_id,
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.normal,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 0,
                                                                      child: Text(
                                                                        ':',
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.normal,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                          work_id=widget.selectedATRWorkList[index][s.key_work_id].toString(),
                                                                          style: TextStyle(
                                                                              color: c.black),
                                                                          maxLines: 1),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        s.work_name,
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 0,
                                                                      child: Text(
                                                                        ':',
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.normal,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(widget.selectedATRWorkList[index][s.key_work_name],
                                                                          style: TextStyle(
                                                                              color: c.black),
                                                                          maxLines: 4),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  crossAxisAlignment:
                                                                  CrossAxisAlignment.start,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(
                                                                        s.description,
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.bold,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 0,
                                                                      child: Text(
                                                                        ':',
                                                                        style: TextStyle(
                                                                            fontSize: 15,
                                                                            fontWeight:
                                                                            FontWeight.normal,
                                                                            color: c.black),
                                                                        overflow:
                                                                        TextOverflow.clip,
                                                                        maxLines: 1,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Text(widget.selectedATRWorkList[index][s.key_description],
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: c.black),
                                                                          maxLines: 1),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                              )
                                                          )
                                                      )
                                                    ]
                                                    )
                                                ))
                                        )
                                    ));
                              }
                          )
                      )
                  )
                ])));
  }
  _OtherWorkList() {
    return Container(
        color: ca1,
        child: Padding(
            padding: EdgeInsets.only(top: 20,left: 15,right: 15),
            child:Stack(
                children: [
                  Visibility(
                      child:Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (BuildContext context,int index)
                          {

                            other_work_inspection_id=widget.selectedOtherWorkList[index][s.key_other_work_inspection_id].toString();
                            // town_type=widget.selectedOtherWorkList[index][s.key_town_type].toString();
                            return InkWell(
                                child:Card(
                                    elevation: 5,
                                    color: c.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: ClipPath(
                                        clipper: ShapeBorderClipper(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20))),
                                        child: Container(
                                            child: Container(
                                                child: Column(children: [
                                                  Container(
                                                      child: Padding(
                                                          padding: EdgeInsets.all(27),
                                                          child: Column(children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.other_work_id,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_other_work_inspection_id].toString(),
                                                                      style: TextStyle(
                                                                          color: c.black),
                                                                      maxLines: 1),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.financial_year,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_fin_year].toString(),
                                                                      style: TextStyle(
                                                                          color: c.black),
                                                                      maxLines: 1),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.status,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_status_name].toString(),
                                                                      style: TextStyle(
                                                                          color: c.black),
                                                                      maxLines: 1),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.other_inspection,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_other_work_category_name],
                                                                      style: TextStyle(
                                                                          color: c.black),
                                                                      maxLines: 4),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.other_work_details,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_other_work_name],
                                                                      style: TextStyle(
                                                                          color: c.black),
                                                                      maxLines: 4),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(
                                                                    s.description,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 0,
                                                                  child: Text(
                                                                    ':',
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight:
                                                                        FontWeight.normal,
                                                                        color: c.black),
                                                                    overflow:
                                                                    TextOverflow.clip,
                                                                    maxLines: 1,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Text(widget.selectedOtherWorkList[index][s.key_description],
                                                                      style: TextStyle(
                                                                          fontSize: 15,
                                                                          color: c.black),
                                                                      maxLines: 1),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                          )
                                                      )
                                                  )
                                                ]
                                                )
                                            ))
                                    )
                                ));
                          }
                      )
                  )
                  )
                ])));
  }
  _Photos() {
    return Visibility(
        visible: imageListFlag,
          child: Container(
          color: ca1,
          child: Padding(
              padding: EdgeInsets.only(top: 10,left: 20,right: 15),
              child:Stack(
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ImageList.length,
                        itemBuilder: (BuildContext context,int index)
                        {
                          return Card(
                              elevation: 5,
                              color: c.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: ClipPath(
                                  clipper: ShapeBorderClipper(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                  child: Column(
                                      children: [
                                        Container(
                                          height:200,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:MemoryImage(
                                                  base64.decode(ImageList[index][s.key_image]),
                                                ),
                                              )
                                          ),
                                        ),
                                        Container(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                                              child: Text(
                                                s.description +" : "+  ImageList[index][s.key_image_description].toString(),style: TextStyle(
                                                  fontSize: 14,fontWeight: FontWeight.normal,color: c.black
                                              ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                  )
                              )
                          );
                        }
                    )
                  ]))
      ));
  }
  Future<void> getWorkDetails() async {
    utils.showProgress(context, 1);
    prefs = await SharedPreferences.getInstance();
    late Map json_request;
    prefs.getString(s.key_rural_urban);
    json_request = {
      s.key_service_id: s.service_key_work_id_wise_inspection_details_view,
      s.key_inspection_id:inspection_id,
      s.key_work_id:work_id,
      s.key_rural_urban:prefs.getString(s.key_rural_urban),
    };
    if (s.key_rural_urban=="U") {
      Map urbanRequest = {s.key_town_type:town_type};
      json_request.addAll(urbanRequest);
    }
    if(type=="atr")
      {
        json_request = {
          s.key_service_id: s.service_key_date_wise_inspection_details_view,
          s.key_action_taken_id:s.service_key_work_id_wise_inspection_details_view
        };
      }
    Map encrypted_request = {
      s.key_user_name: prefs.getString(s.key_user_name),
      s.key_data_content: utils.encryption(jsonEncode(json_request), prefs.getString(s.userPassKey).toString()),
    };
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response = await _ioClient.post(
        url.main_service, body: json.encode(encrypted_request));
    print("WorkList_url>>" + url.main_service.toString());
    print("WorkList_request_json>>" + json_request.toString());
    print("WorkList_request_encrpt>>" + encrypted_request.toString());
    String data = response.body;
    print("WorkList_response>>" + data);
    var jsonData = jsonDecode(data);
    var enc_data = jsonData[s.key_enc_data];
    var decrypt_data = utils.decryption(enc_data, prefs.getString(s.userPassKey).toString());
    var userData = jsonDecode(decrypt_data);
    var status = userData[s.key_status];
    var response_value = userData[s.key_response];
    utils.hideProgress(context);
    ImageList.clear();
    if (status == s.key_ok && response_value == s.key_ok) {
      List<dynamic> res_jsonArray = userData[s.key_json_data];
      if (res_jsonArray.length > 0) {
        for (int i = 0; i < res_jsonArray.length; i++) {
          List res_image = res_jsonArray[i][s.key_inspection_image];
          print("Res image>>>"+res_image.toString());
          inspection_id=res_jsonArray[i][s.key_inspection_id].toString();
          print("WORK_ID>>>>>>"+ inspection_id);
          List description=res_jsonArray[i][s.key_image_description];
          print("image description>>>>"+description.toString());
          ImageList.addAll(res_image);
          print("image_List>>>>>>"+ImageList.toString());
        }
      }
      setState(() {
        _Photos();
      });
    }
    else if (status == s.key_ok && response_value == s.key_noRecord) {
      setState(() {

      });
    }
    if (ImageList.length > 0) {
      noDataFlag = false;
      imageListFlag = true;
    } else {
      noDataFlag = true;
      imageListFlag = false;
    }
  }
  Future<void> getSavedOtherWorkDetails() async {
    utils.showProgress(context, 1);
    prefs = await SharedPreferences.getInstance();
    Map dataset = {
      s.key_service_id:s.service_key_other_inspection_details_view,
      s.key_rural_urban: prefs.getString(s.key_rural_urban),
      s.key_other_work_inspection_id: other_work_inspection_id,
    };
    if(s.key_rural_urban=="U")
    {
      Map set = {
        s.key_town_type: town_type,
      };
      dataset.addAll(set);
    }
    print("Other Work Request>>>>"+dataset.toString());
    Map encrypted_request = {
      s.key_user_name: prefs.getString(s.key_user_name),
      s.key_data_content: utils.encryption(jsonEncode(dataset), prefs.getString(s.userPassKey).toString()),
    };
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response = await _ioClient.post(
        url.main_service, body: json.encode(encrypted_request));
    print("Saved_OtherWorkList_url>>" + url.main_service.toString());
    print("Saved_OtherWorkList_request_json>>" + dataset.toString());
    print("Saved_OtherWorkList_request_encrpt>>" + encrypted_request.toString());
    String data = response.body;
    print("Saved_OtherWorkList_response>>" + data);
    var jsonData = jsonDecode(data);
    var enc_data = jsonData[s.key_enc_data];
    var decrypt_data = utils.decryption(enc_data, prefs.getString(s.userPassKey).toString());
    var userData = jsonDecode(decrypt_data);
    var status = userData[s.key_status];
    var response_value = userData[s.key_response];
    utils.hideProgress(context);
    if (status == s.key_ok && response_value == s.key_ok) {
      List<dynamic> res_jsonArray = userData[s.key_json_data];
      if (res_jsonArray.length > 0) {
        for (int i = 0; i < res_jsonArray.length; i++) {
          List res_image = res_jsonArray[i][s.key_inspection_image];
          other_work_inspection_id=res_jsonArray[i][s.key_other_work_inspection_id].toString();
          print("OTHER_WORK_ID"+other_work_inspection_id);
          print("Res image>>>"+res_image.toString());
          ImageList.addAll(res_image);
          print("image_List>>>>>>"+ImageList.toString());
        }
      }
      setState(() {
        _Photos();
      });
    }
    else if (status == s.key_ok && response_value == s.key_noRecord) {
      setState(() {

      });
    }
    if (ImageList.length > 0) {
      noDataFlag = false;
      imageListFlag = true;
    } else {
      noDataFlag = true;
      imageListFlag = false;
    }
  }
  Future<void> getAtrWorkDetails() async {
    utils.showProgress(context, 1);
    prefs = await SharedPreferences.getInstance();
    late Map json_request;
    prefs.getString(s.key_rural_urban);
    json_request = {
      s.key_service_id: s.service_key_work_id_wise_inspection_action_taken_details_view,
      s.key_inspection_id:inspection_id,
      s.key_work_id:work_id,
      s.key_action_taken_id:action_taken_id,
      s.key_rural_urban:prefs.getString(s.key_rural_urban),
    };
    if (s.key_rural_urban=="U") {
      Map urbanRequest = {s.key_town_type:town_type};
      json_request.addAll(urbanRequest);
    }
    Map encrypted_request = {
      s.key_user_name: prefs.getString(s.key_user_name),
      s.key_data_content: utils.encryption(jsonEncode(json_request), prefs.getString(s.userPassKey).toString()),
    };
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response = await _ioClient.post(
        url.main_service, body: json.encode(encrypted_request));
    print("WorkList_url>>" + url.main_service.toString());
    print("WorkList_request_json>>" + json_request.toString());
    print("WorkList_request_encrpt>>" + encrypted_request.toString());
    String data = response.body;
    print("WorkList_response>>" + data);
    var jsonData = jsonDecode(data);
    var enc_data = jsonData[s.key_enc_data];
    var decrypt_data = utils.decryption(enc_data, prefs.getString(s.userPassKey).toString());
    var userData = jsonDecode(decrypt_data);
    var status = userData[s.key_status];
    var response_value = userData[s.key_response];
    utils.hideProgress(context);
    ImageList.clear();
    if (status == s.key_ok && response_value == s.key_ok) {
      List<dynamic> res_jsonArray = userData[s.key_json_data];
      if (res_jsonArray.length > 0) {
        for (int i = 0; i < res_jsonArray.length; i++) {
          List res_image = res_jsonArray[i][s.key_inspection_image];
          print("Res image>>>"+res_image.toString());
          inspection_id=res_jsonArray[i][s.key_inspection_id].toString();
          action_taken_id=res_jsonArray[i][s.key_action_taken_id].toString();
          print("WORK_ID>>>>>"+ work_id);
          print("Inspection_ID>>>>>"+ inspection_id);
          print("Action_Taken_ID>>>>>"+ action_taken_id);
          List description=res_jsonArray[i][s.key_image_description];
          print("image description>>>>"+description.toString());
          ImageList.addAll(res_image);
          print("image_List>>>>>>"+ImageList.toString());
        }
      }
      setState(() {
        _Photos();
      });
    }
    else if (status == s.key_ok && response_value == s.key_noRecord) {
      setState(() {

      });
    }
    if (ImageList.length > 0) {
      noDataFlag = false;
      imageListFlag = true;
    } else {
      noDataFlag = true;
      imageListFlag = false;
    }
  }
}