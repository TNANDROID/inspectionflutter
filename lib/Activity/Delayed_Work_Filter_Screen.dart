// ignore_for_file: unused_local_variable, non_constant_identifier_names, file_names, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:inspection_flutter_app/Resources/Strings.dart' as s;
import 'package:inspection_flutter_app/Resources/ColorsValue.dart' as c;
import 'package:inspection_flutter_app/Resources/ImagePath.dart' as imagePath;
import 'package:inspection_flutter_app/Resources/url.dart' as url;
import 'package:shared_preferences/shared_preferences.dart';

import '../DataBase/DbHelper.dart';
import '../Utils/utils.dart';

class DelayedWorkFilterScreen extends StatefulWidget {
  const DelayedWorkFilterScreen({Key? key}) : super(key: key);

  @override
  State<DelayedWorkFilterScreen> createState() =>
      _DelayedWorkFilterScreenState();
}

class _DelayedWorkFilterScreenState extends State<DelayedWorkFilterScreen> {
  //Bool Error
  bool finYearError = false;
  bool districtError = false;
  bool blockError = false;

  //bool Loading
  bool isLoadingFinYear = false;
  bool isLoadingDistrict = false;

  //Bool visibility
  bool bFlag = false;
  bool dFlag = false;
  bool sFlag = false;
  bool delay = false;
  bool pvTable = false;

  //Bool
  bool submitFlag = false;

  //String
  String selectedFinYear = "";
  String selectedLevel = "";
  String selectedDistrict = "";
  String selectedBlock = "";
  String selectedMonth = "";

  //List
  List finYearItems = [];
  List districtItems = [];
  List blockItems = [];
  List monthItems = [];
  List finList = [];

  //Default Values
  Map<String, String> defaultSelectedFinYear = {
    s.key_fin_year: s.select_financial_year,
  };
  Map<String, String> defaultSelectedBlock = {
    s.key_bcode: "0",
    s.key_bname: s.selectBlock
  };
  Map<String, String> defaultSelectedDistrict = {
    s.key_dcode: "0",
    s.key_dname: s.selectDistrict
  };
  Map<String, String> defaultSelectedMonth = {'monthId': "00", 'month': '0'};

  Utils utils = Utils();
  late SharedPreferences prefs;
  var dbHelper = DbHelper();
  var dbClient;

  TextEditingController asController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    dbClient = await dbHelper.db;
    List<Map> list =
        await dbClient.rawQuery('SELECT * FROM ${s.table_FinancialYear}');
    finYearItems.add(defaultSelectedFinYear);
    finYearItems.addAll(list);
    selectedFinYear = defaultSelectedFinYear[s.key_fin_year]!;
    selectedLevel = prefs.getString(s.key_level)!;
    print(finYearItems.toString());
    if (selectedLevel == 'S') {
      sFlag = true;
      List<Map> list =
          await dbClient.rawQuery('SELECT * FROM ${s.table_District}');
      print(list.toString());
      districtItems.add(defaultSelectedDistrict);
      districtItems.addAll(list);
      selectedDistrict = defaultSelectedDistrict[s.key_dcode]!;
      selectedBlock = defaultSelectedBlock[s.key_bcode]!;
    } else if (selectedLevel == 'D') {
      dFlag = true;
      List<Map> list =
          await dbClient.rawQuery('SELECT * FROM ${s.table_Block}');
      print(list.toString());
      blockItems.add(defaultSelectedBlock);
      blockItems.addAll(list);
      selectedDistrict = prefs.getString(s.key_dcode)!;
      selectedBlock = defaultSelectedBlock[s.key_bcode]!;
    } else if (selectedLevel == 'B') {
      bFlag = true;
      selectedDistrict = prefs.getString(s.key_dcode)!;
      selectedBlock = prefs.getString(s.key_bcode)!;
    }

    monthItems.add(defaultSelectedMonth);
    for (int i = 1; i < 5; i++) {
      Map<String, String> mymap =
          {}; // This created one object in the current scope.
      // First iteration , i = 0
      mymap['monthId'] = (i * 3).toString(); // Now mymap = { name: 'test0' };
      mymap['month'] = (i * 3).toString(); // Now mymap = { name: 'test0' };
      monthItems.add(mymap);
    }
    print("months>>$monthItems");
    selectedMonth = defaultSelectedMonth['monthId']!;

    setState(() {});
  }

  void loadUIBlock(String value) async {
    if (await utils.isOnline()) {
      selectedDistrict = value.toString();
      await getBlockList(value);
      setState(() {});
    } else {
      utils.customAlert(context, "E", s.no_internet);
    }
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
                        s.filter_work_list,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            color: c.white,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    s.select_financial_year,
                    style: GoogleFonts.getFont('Roboto',
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: c.grey_8),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: c.grey_out,
                      border: Border.all(
                          width: finYearError ? 1 : 0.1,
                          color: finYearError ? c.red : c.grey_10),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: IgnorePointer(
                    ignoring: isLoadingFinYear ? true : false,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        style: const TextStyle(color: Colors.black),
                        value: selectedFinYear,
                        isExpanded: true,
                        items: finYearItems
                            .map((item) => DropdownMenuItem<String>(
                                  value: item[s.key_fin_year].toString(),
                                  child: Text(
                                    item[s.key_fin_year].toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != s.select_financial_year) {
                            isLoadingFinYear = false;
                            finYearError = false;
                            selectedFinYear = value.toString();
                            setState(() {});
                          } else {
                            setState(() {
                              selectedFinYear = value.toString();
                              finYearError = true;
                            });
                          }
                        },
                        buttonStyleData: const ButtonStyleData(
                          height: 45,
                          padding: EdgeInsets.only(right: 10),
                        ),
                        iconStyleData: IconStyleData(
                          icon: isLoadingFinYear
                              ? SpinKitCircle(
                                  color: c.colorPrimary,
                                  size: 30,
                                  duration: const Duration(milliseconds: 1200),
                                )
                              : const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                          iconSize: 30,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Visibility(
                  visible: sFlag ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          s.selectDistrict,
                          style: GoogleFonts.getFont('Roboto',
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: c.grey_8),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: c.grey_out,
                            border: Border.all(
                                width: districtError ? 1 : 0.1,
                                color: districtError ? c.red : c.grey_10),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: IgnorePointer(
                          ignoring: isLoadingDistrict ? true : false,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              style: const TextStyle(color: Colors.black),
                              value: selectedDistrict,
                              isExpanded: true,
                              items: districtItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item[s.key_dcode].toString(),
                                        child: Text(
                                          item[s.key_dname].toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != "0") {
                                  isLoadingDistrict = true;
                                  loadUIBlock(value.toString());
                                  setState(() {});
                                } else {
                                  setState(() {
                                    selectedDistrict = value.toString();
                                    districtError = true;
                                  });
                                }
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 45,
                                padding: EdgeInsets.only(right: 10),
                              ),
                              iconStyleData: IconStyleData(
                                icon: isLoadingDistrict
                                    ? SpinKitCircle(
                                        color: c.colorPrimary,
                                        size: 30,
                                        duration:
                                            const Duration(milliseconds: 1200),
                                      )
                                    : const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black45,
                                      ),
                                iconSize: 30,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Visibility(
                        visible: districtError ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            s.please_enter_district,
                            // state.hasError ? state.errorText : '',
                            style: TextStyle(
                                color: Colors.redAccent.shade700,
                                fontSize: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: bFlag ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        child: Text(
                          s.selectBlock,
                          style: GoogleFonts.getFont('Roboto',
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: c.grey_8),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: c.grey_out,
                            border: Border.all(
                                width: blockError ? 1 : 0.1,
                                color: blockError ? c.red : c.grey_10),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            value: selectedBlock,
                            style: const TextStyle(color: Colors.black),
                            isExpanded: true,
                            items: blockItems
                                .map((item) => DropdownMenuItem<String>(
                                      value: item[s.key_bcode].toString(),
                                      child: Text(
                                        item[s.key_bname].toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != "0") {
                                print(value);
                                setState(() {
                                  delay = true;
                                  selectedBlock = value.toString();
                                  setState(() {});
                                });
                              }
                              //Do something when changing the item if you want.
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 45,
                              padding: EdgeInsets.only(right: 10),
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black45,
                              ),
                              iconSize: 30,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Visibility(
                        visible: blockError ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            s.please_enter_block,
                            // state.hasError ? state.errorText : '',
                            style: TextStyle(
                                color: Colors.redAccent.shade700,
                                fontSize: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: delay,
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: c.grey_out,
                                border:
                                    Border.all(width: 0.1, color: c.grey_10),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 5, right: 0),
                                  child: Text(
                                    'Months Delayed',
                                    style: GoogleFonts.getFont('Roboto',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: c.grey_8),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton2(
                                        style: const TextStyle(
                                            color: Colors.black),
                                        value: selectedMonth,
                                        isExpanded: true,
                                        items: monthItems
                                            .map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item['monthId']
                                                      .toString(),
                                                  child: Text(
                                                    item['month'].toString(),
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) async {
                                          if (value != "00") {
                                            selectedMonth = value.toString();
                                            submitFlag = true;
                                            setState(() {});
                                          }
                                        },
                                        buttonStyleData: const ButtonStyleData(
                                          height: 45,
                                          padding: EdgeInsets.only(right: 10),
                                        ),
                                        dropdownStyleData: DropdownStyleData(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                color: c.grey_out,
                                border:
                                    Border.all(width: 0.1, color: c.grey_10),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, bottom: 0, left: 5, right: 0),
                                  child: Text(
                                    'AS Value >=',
                                    style: GoogleFonts.getFont('Roboto',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 12,
                                        color: c.grey_8),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    alignment: AlignmentDirectional.center,
                                    height: 30,
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 13),
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: asController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: '0',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    utils.hideSoftKeyBoard(context);
                                    if (asController.text.isNotEmpty &&
                                        int.parse(asController.text) > 0) {
                                      submitFlag = true;
                                    } else {
                                      utils.customAlert(context, "E",
                                          "Please Enter AS value");
                                    }
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 30,
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                        color: c.colorPrimary,
                                        border: Border.all(
                                            width: 0, color: c.grey_10),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(10),
                                        )),
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Image.asset(
                                      imagePath.right_arrow_icon,
                                      fit: BoxFit.contain,
                                      color: c.white,
                                      height: 18,
                                      width: 18,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: submitFlag,
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                c.colorPrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ))),
                        onPressed: () async {
                          asController.text.isEmpty
                              ? asController.text = "-1"
                              : null;

                          if (int.parse(asController.text) > 0 ||
                              selectedMonth != "00") {
                            await fetchDelayedWorkList();
                          } else {
                            utils.customAlert(context, "E",
                                "Please Select AS value or Months");
                          }
                          pvTable = true;
                          setState(() {});
                        },
                        child: Text(
                          s.submit,
                          style: GoogleFonts.getFont('Roboto',
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: c.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
          )),
    );
  }

  /*
  ***********************************************************************************************
                                              * API CALL *
  */

  Future<void> fetchDelayedWorkList() async {
    String? key = prefs.getString(s.userPassKey);
    String? userName = prefs.getString(s.key_user_name);
    utils.showProgress(context, 1);

    finList = [];
    finList.add(selectedFinYear);

    Map json_request = {
      s.key_service_id: s.service_key_get_inspection_delayed_work_details,
      s.key_dcode: selectedDistrict,
      s.key_bcode: selectedBlock,
      s.key_fin_year: finList,
      if (pvTable) s.flag: 2 else s.flag: 1,
      if (selectedMonth.isNotEmpty) s.key_month: selectedMonth,
      if (asController.text.isNotEmpty) s.key_as_value: asController.text,
    };

    Map encrypted_request = {
      s.key_user_name: prefs.getString(s.key_user_name),
      s.key_data_content: json_request,
    };

    String jsonString = jsonEncode(encrypted_request);

    String headerSignature = utils.generateHmacSha256(jsonString, key!, true);

    String header_token = utils.jwt_Encode(key, userName!, headerSignature);
    Map<String, String> header = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $header_token"
    };

    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response = await _ioClient.post(url.main_service_jwt,
        body: jsonEncode(encrypted_request), headers: header);

    print("WorkList_response_url>>${url.master_service}");
    print("WorkList_response_request_json>> ${jsonEncode(json_request)}");
    print("WorkList_response_request_encrpt>>$encrypted_request");

    utils.hideProgress(context);

    if (response.statusCode == 200) {
      String data = response.body;

      print("WorkList_response>>" + data);

      String? authorizationHeader = response.headers['authorization'];

      String? token = authorizationHeader?.split(' ')[1];

      print("WorkList Authorization -  $token");

      String responceSignature = utils.jwt_Decode(key, token!);

      String responceData = utils.generateHmacSha256(data, key, false);

      print("WorkList responceSignature -  $responceSignature");

      print("WorkList responceData -  $responceData");

      if (responceSignature == responceData) {
        print("WorkList responceSignature - Token Verified");
        var userData = jsonDecode(data);

        var status = userData[s.key_status];
        var response_value = userData[s.key_response];

        if (status == s.key_ok && response_value == s.key_ok) {
          List<dynamic> res_jsonArray = userData[s.key_json_data];

          print(res_jsonArray);
        }
      }
    }
  }

  Future<void> getBlockList(String dcode) async {
    Map json_request = {
      s.key_dcode: dcode,
      s.key_service_id: s.service_key_block_list_district_wise_master,
    };

    Map encrpted_request = {
      s.key_user_name: prefs.getString(s.key_user_name),
      s.key_data_content: utils.encryption(
          jsonEncode(json_request), prefs.getString(s.userPassKey).toString()),
    };
    // http.Response response = await http.post(url.master_service, body: json.encode(encrpted_request));
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = IOClient(_client);
    var response = await _ioClient.post(url.master_service,
        body: json.encode(encrpted_request));
    print("BlockList_url>>${url.master_service}");
    print("BlockList_request_json>> ${jsonEncode(json_request)}");
    print("BlockList_request_encrpt>>$encrpted_request");
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String data = response.body;
      print("BlockList_response>>$data");
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[s.key_enc_data];
      var decrpt_data = utils.decryption(
          enc_data.toString(), prefs.getString(s.userPassKey).toString());
      var userData = jsonDecode(decrpt_data);
      var status = userData[s.key_status];
      var responseValue = userData[s.key_response];
      if (status == s.key_ok && responseValue == s.key_ok) {
        List<dynamic> res_jsonArray = userData[s.key_json_data];
        res_jsonArray.sort((a, b) {
          return a[s.key_bname]
              .toLowerCase()
              .compareTo(b[s.key_bname].toLowerCase());
        });
        if (res_jsonArray.isNotEmpty) {
          blockItems = [];
          blockItems.add(defaultSelectedBlock);
          blockItems.addAll(res_jsonArray);
          selectedBlock = defaultSelectedBlock[s.key_bcode]!;
          bFlag = true;
        }
      } else if (status == s.key_ok && responseValue == s.key_noRecord) {
        Utils().showAlert(context, "No Block Found");
      }
      isLoadingDistrict = false;
      districtError = false;
      setState(() {});
    }
  }

  /*
  ***********************************************************************************************
  */
}