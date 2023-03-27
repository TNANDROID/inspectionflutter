import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inspection_flutter_app/Resources/Strings.dart' as s;
import 'package:inspection_flutter_app/Resources/url.dart' as url;
import 'package:inspection_flutter_app/Resources/ImagePath.dart' as imagePath;
import 'package:inspection_flutter_app/Resources/ColorsValue.dart' as c;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../DataBase/DbHelper.dart';
import '../Utils/utils.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  Utils utils = Utils();
  TextEditingController user_name = TextEditingController();
  TextEditingController user_password = TextEditingController();
  String userPassKey = "";
  String userDecriptKey = "";
  late SharedPreferences prefs;
  var dbHelper = DbHelper();
  var dbClient;
  bool _passwordVisible = false;
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    _passwordVisible = false;
    prefs = await SharedPreferences.getInstance();
    dbClient = await dbHelper.db;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: c.colorAccentverylight,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  child: Column(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: c.colorPrimary,
                          ),
                          color: c.colorPrimary,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(200),
                              bottomRight: Radius.circular(200))),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 110, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Image.asset(
                            imagePath.logo,
                            height: 60,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(
                        s.appName,
                        style: TextStyle(
                            color: c.grey_8,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Stack(children: <Widget>[
                  Container(
                    transform: Matrix4.translationValues(0.0, -15.0, 0.0),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      // clipBehavior is necessary because, without it, the InkWell's animation
                      // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
                      // This comes with a small performance cost, and you should not set [clipBehavior]
                      // unless you need it.
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Text(
                                  s.mobileNumber,
                                  style:
                                      TextStyle(color: c.grey_8, fontSize: 15),
                                  textAlign: TextAlign.left,
                                )),
                            Container(
                              height: 40,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: c.grey_3, width: 2),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(15),
                                    topRight: const Radius.circular(15),
                                    bottomLeft: const Radius.circular(15),
                                    bottomRight: const Radius.circular(15),
                                  )),
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: AlignmentDirectional.centerStart,
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: user_name,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: s.mobileNumber,
                                  hintStyle: TextStyle(
                                      fontSize: 14.0, color: c.grey_6),
                                  border: InputBorder.none,
                                  prefixIcon: SvgPicture.asset(
                                    imagePath.ic_user,
                                    color: c.colorPrimary,
                                    height: 15,
                                    width: 15,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minHeight: 20,
                                    minWidth: 30,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Text(
                                  s.password,
                                  style:
                                      TextStyle(color: c.grey_8, fontSize: 15),
                                  textAlign: TextAlign.left,
                                )),
                            Container(
                              height: 40,
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: c.grey_3, width: 2),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(15),
                                    topRight: const Radius.circular(15),
                                    bottomLeft: const Radius.circular(15),
                                    bottomRight: const Radius.circular(15),
                                  )),
                              alignment: AlignmentDirectional.center,
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: user_password,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintText: s.password,
                                  hintStyle: TextStyle(
                                      fontSize: 14.0, color: c.grey_6),
                                  border: InputBorder.none,
                                  prefixIcon: SvgPicture.asset(
                                    imagePath.ic_user,
                                    color: c.colorPrimary,
                                    height: 15,
                                    width: 15,
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                    minHeight: 20,
                                    minWidth: 30,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: c.grey_8,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  utils.showToast(context, "click forgot");
                                }, // Handle your callback
                                child: Text(
                                  s.forgot_password,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: c.full_transparent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: c.colorPrimaryDark,
                                    shadows: [
                                      Shadow(
                                          color: c.colorPrimaryDark,
                                          offset: Offset(0, -3))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: c.colorPrimary),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: InkWell(
                              onTap: () async {
                                user_name.text = "9080873403";
                                String ss = new String.fromCharCodes(
                                    new Runes('\u0024'));
                                user_password.text = "crd45#" + ss;
                                if (!user_name.text.isEmpty) {
                                  if (!user_password.text.isEmpty) {
                                    // utils.showToast(context, string.success);
                                    if (await utils.isOnline()) {
                                      login(context);
                                    } else {
                                      utils.showAlert(context, s.no_internet);
                                    }
                                  } else {
                                    utils.showToast(context, s.password_empty);
                                  }
                                } else {
                                  utils.showToast(context, s.user_name_empty);
                                }
                              }, // Image tapped
                              child: Image.asset(
                                imagePath.right_arrow_icon,
                                color: Colors.white,
                                height: 45,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  // Handle your callback
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            s.new_user,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: c.d_grey2,
                                fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            utils.showToast(context, "click register");
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              s.register,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: c.colorPrimaryDark,
                                  fontSize: 17),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      ]),
                ),
                InkWell(
                  onTap: () {
                    utils.showToast(context, "click Here");
                  }, // Handle your callback
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(fontSize: 15, color: c.d_grey3),
                          children: [
                            TextSpan(
                              text: s.otp_validation1,
                              style: TextStyle(fontSize: 15),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle the tap event
                                },
                              text: s.otp_validation2,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold), //<-- SEE HERE
                            ),
                            TextSpan(
                              text: s.otp_validation3,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ])),
              Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Text(
                        s.version,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: c.d_grey2,
                            fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        s.software_designed_and,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: c.grey_8,
                            fontSize: 17),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> login(BuildContext context) async {
    String random_char = utils.generateRandomString(15);
    var request = {
      s.service_id: s.key_login,
      s.user_login_key: random_char,
      s.user_name: user_name.text.trim(),
      s.user_pwd: utils.getSha256(random_char, user_password.text.trim())
    };
    http.Response response = await http.post(url.login, body: request);
    print("login_url>>" + url.login.toString());
    print("login_request>>" + request.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String data = response.body;
      print("login_response>>" + data);
      var decodedData = json.decode(data);
      // var decodedData= await json.decode(json.encode(response.body));
      var STATUS = decodedData[s.status];
      var RESPONSE = decodedData[s.response];
      var KEY;
      var user_data;
      String decryptedKey;
      String userDataDecrypt;
      if (STATUS.toString() == s.ok && RESPONSE.toString() == "LOGIN_SUCCESS") {
        KEY = decodedData[s.key];
        user_data = decodedData[s.user_data];

        userPassKey = utils.textToMd5(user_password.text);
        decryptedKey = utils.decryption(KEY, userPassKey);
        userDecriptKey = decryptedKey;
        print("userDecriptKey: " + userDecriptKey);

        userDataDecrypt = utils.decryption(user_data, userPassKey);
        var userData = jsonDecode(userDataDecrypt);

        prefs.setString(s.name, userData[s.name]);
        prefs.setString(s.user_name, user_name.text.trim());
        prefs.setString(s.password, user_password.text.trim());
        prefs.setString(s.userPassKey, decryptedKey);
        prefs.setString(s.desig_name, userData[s.desig_name]);
        prefs.setString(s.desig_code, userData[s.desig_code]);
        prefs.setString(s.level, userData[s.levels]);

        if (userData['profile_image_found'] == 'Y') {
          if (!(userData[s.profile_image].toString() == ("null") ||
              userData[s.profile_image].toString() == (""))) {
            Uint8List bytes =
                Base64Codec().decode(userData[s.profile_image].toString());
            prefs.setString(
                s.profile_image, userData[s.profile_image].toString());
          }
        } else {
          prefs.setString(s.profile_image, "");
        }

        if (userData[s.levels] == ("S")) {
          prefs.setString(s.scode, userData[s.statecode]);
          prefs.setString(s.stateName, "Tamil Nadu");
          prefs.setString(s.dcode, "");
          prefs.setString(s.bcode, "");
          getDistrictList();
          getBlockList();
        } else if (userData[s.levels] == ("D")) {
          prefs.setString(s.scode, userData[s.statecode]);
          prefs.setString(s.dcode, userData[s.dcode]);
          prefs.setString(s.dname, userData[s.dname]);
          prefs.setString(s.bcode, "");
          getBlockList();
        } else if (userData[s.levels] == ("B")) {
          prefs.setString(s.scode, userData[s.statecode]);
          prefs.setString(s.dcode, userData[s.dcode]);
          prefs.setString(s.dname, userData[s.dname]);
          prefs.setString(s.bcode, userData[s.bcode]);
          prefs.setString(s.bname, userData[s.bname]);
        }
        getProfileData();

        utils.gotoHomePage(context,"Login");
      } else {
        utils.showToast(context, "Failed");
      }
      return decodedData;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed');
    }
  }

  Future<void> getDistrictList() async {
    late Map json_request;
    if (prefs.getString(s.levels) as String == "S") {
      json_request = {
        s.scode: prefs.getString(s.scode) as String,
        s.service_id: s.key_district_list_all,
      };
    }

    Map encrpted_request = {
      s.user_name: prefs.getString(s.user_name),
      s.data_content:
          utils.encryption(jsonEncode(json_request), userDecriptKey),
    };
    http.Response response = await http.post(url.master_service,
        body: json.encode(encrpted_request));
    print("districtList_url>>" + url.master_service.toString());
    print("districtList_request_json>>" + json_request.toString());
    print("districtList_request_encrpt>>" + encrpted_request.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String data = response.body;
      print("districtList_response>>" + data);
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[s.enc_data];
      var decrpt_data = utils.decryption(enc_data, userDecriptKey);
      var userData = jsonDecode(decrpt_data);
      var status = userData[s.status];
      var response_value = userData[s.response];
      if (status == s.ok && response_value == s.ok) {
        List<dynamic> res_jsonArray = userData[s.json_data];
        if (res_jsonArray.length > 0) {
          await dbClient.execute("DELETE FROM District");
          for (int i = 0; i < res_jsonArray.length; i++) {
            await dbClient.rawInsert(
                'INSERT INTO District (dcode, dname) VALUES(' +
                    res_jsonArray[i][s.dcode] +
                    ",'" +
                    res_jsonArray[i][s.dname] +
                    "')");
          }
          List<Map> list = await dbClient.rawQuery('SELECT * FROM District');
          print("list" + list.toString());
        }
      }
    }
  }

  Future<void> getBlockList() async {
    late Map json_request;

    if (prefs.getString(s.levels) as String == "D") {
      json_request = {
        s.scode: prefs.getString(s.scode) as String,
        s.dcode: prefs.getString(s.dcode) as String,
        s.service_id: s.key_block_list_all,
      };
    } else if (prefs.getString(s.levels) as String == "S") {
      json_request = {
        s.scode: prefs.getString(s.scode) as String,
        s.service_id: s.key_block_list_all,
      };
    }

    Map encrpted_request = {
      s.user_name: prefs.getString(s.user_name),
      s.data_content:
          utils.encryption(jsonEncode(json_request), userDecriptKey),
    };
    http.Response response = await http.post(url.master_service,
        body: json.encode(encrpted_request));
    print("BlockList_url>>" + url.master_service.toString());
    print("BlockList_request_json>>" + json_request.toString());
    print("BlockList_request_encrpt>>" + encrpted_request.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String data = response.body;
      print("BlockList_response>>" + data);
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[s.enc_data];
      var decrpt_data = utils.decryption(enc_data, userDecriptKey);
      var userData = jsonDecode(decrpt_data);
      var status = userData[s.status];
      var response_value = userData[s.response];
      if (status == s.ok && response_value == s.ok) {
        List<dynamic> res_jsonArray = userData[s.json_data];
        if (res_jsonArray.length > 0) {
          await dbClient.execute("DELETE FROM Block");
          for (int i = 0; i < res_jsonArray.length; i++) {
            await dbClient.rawInsert(
                'INSERT INTO Block (dcode, bcode, bname) VALUES(' +
                    res_jsonArray[i][s.dcode] +
                    ",'" +
                    res_jsonArray[i][s.bcode] +
                    ",'" +
                    res_jsonArray[i][s.bname] +
                    "')");
          }
          List<Map> list = await dbClient.rawQuery('SELECT * FROM Block');
          print("list >>" + list.toString());
        }
      }
    }
  }

  Future<void> getProfileData() async {
    late Map json_request;

    json_request = {
      s.service_id: s.key_work_inspection_profile_list,
    };

    Map encrpted_request = {
      s.user_name: prefs.getString(s.user_name),
      s.data_content:
          utils.encryption(jsonEncode(json_request), userDecriptKey),
    };
    http.Response response =
        await http.post(url.main_service, body: json.encode(encrpted_request));
    print("ProfileData_url>>" + url.main_service.toString());
    print("ProfileData_request_json>>" + json_request.toString());
    print("ProfileData_request_encrpt>>" + encrpted_request.toString());
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      String data = response.body;
      print("ProfileData_response>>" + data);
      var jsonData = jsonDecode(data);
      var enc_data = jsonData[s.enc_data];
      var decrpt_data = utils.decryption(enc_data, userDecriptKey);
      var userData = jsonDecode(decrpt_data);
      var status = userData[s.status];
      var response_value = userData[s.response];
      if (status == s.ok && response_value == s.ok) {
        List<dynamic> res_jsonArray = userData[s.json_data];
        if (res_jsonArray.length > 0) {
          for (int i = 0; i < res_jsonArray.length; i++) {
            String name = res_jsonArray[i][s.name];
            String mobile = res_jsonArray[i][s.mobile];
            String gender = res_jsonArray[i][s.gender];
            String level = res_jsonArray[i][s.level];
            String desig_code = res_jsonArray[i][s.desig_code].toString();
            String desig_name = res_jsonArray[i][s.desig_name];
            String dcode = res_jsonArray[i][s.dcode].toString();
            String bcode = res_jsonArray[i][s.bcode].toString();
            String office_address = res_jsonArray[i][s.office_address];
            String email = res_jsonArray[i][s.email];
            String profile_image = res_jsonArray[i][s.profile_image];
            String role_code = res_jsonArray[i][s.role_code].toString();

            if (!(profile_image == ("null") || profile_image == (""))) {
              Uint8List bytes = Base64Codec().decode(profile_image);
              prefs.setString(s.profile_image, profile_image);
            } else {
              prefs.setString(s.profile_image, "");
            }

            prefs.setString(s.desig_name, desig_name);
            prefs.setString(s.desig_code, desig_code);
            prefs.setString(s.name, name);
            prefs.setString(s.role_code, role_code);
            prefs.setString(s.level, level);
            prefs.setString(s.dcode, dcode);
            prefs.setString(s.bcode, bcode);

          }
        }
      }
    }
  }
}