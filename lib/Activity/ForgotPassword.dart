// ignore_for_file: no_leading_underscores_for_local_identifiers, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:InspectionAppNew/Resources/Strings.dart' as s;
import 'package:InspectionAppNew/Resources/url.dart' as url;
import 'package:InspectionAppNew/Resources/ImagePath.dart' as imagePath;
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/utils.dart';
import '../Resources/ColorsValue.dart' as c;

class ForgotPassword extends StatefulWidget {
  @override
  final isForgotPassword;
  ForgotPassword({this.isForgotPassword});
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  Utils utils = Utils();
  late SharedPreferences prefs;
  String userPassKey = "";
  String userDecryptKey = "";
  var appBarvisibility = true;
  var tcVisibility = false;
  var visibility = false;
  var tvisibility = false;
  String mobilenumber = "";
  String Otp = "";
  String newpassword = "";
  String confirmpassword = "";
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController mobile_number = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
  }
  Future<bool> _onWillPop() async {
    Navigator.of(context, rootNavigator: true).pop(context);
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
        backgroundColor: c.white,
        appBar: AppBar(
          backgroundColor: c.colorPrimary,
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Visibility(
              visible: appBarvisibility,
              child: Text(
                tcVisibility?"OTP Verification":tvisibility?"Change Password":"Mobile Verification ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),

          /* actions: <Widget>[
            Padding(padding: EdgeInsets.only(top: 8),)
          ],*/
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      imagePath.otp,
                      width: double.infinity,
                      height: 250,
                    ),
                    Stack(children: <Widget>[
                      Visibility(
                        visible: !visibility,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 35),
                            child: Text(
                                s.enter_registered_mobile_number_to_send_otp,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.black),
                                textAlign: TextAlign.center)),
                      ),
                      Visibility(
                        visible: !visibility,
                        child: Padding(
                          padding: EdgeInsets.only(top: 45),
                          child: Container(
                            height: 55,
                            /* decoration: new BoxDecoration(
                                  color: c.ca2,
                                  border: Border.all(color: c.ca2, width: 2),
                                  borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10),
                                    topRight: const Radius.circular(10),
                                    bottomLeft: const Radius.circular(10),
                                    bottomRight: const Radius.circular(10),
                                  )),*/
                            child: TextFormField(
                              controller: mobile_number,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.isEmpty
                                  ? s.mobile_number_must_be_of_10_digits
                                  : Utils().isNumberValid(value)
                                  ? null
                                  : s.enter_a_valid_mobile_number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 15),
                                filled: true,
                                fillColor: c.ca1,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 0.1, color: c.ca1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: c.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            /* child: TextField(
                                controller: mobile_number,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  // suffixIcon: Icon(Icons.visibility_off_outlined),
                                  contentPadding: EdgeInsets.only(top: 15,
                                      left: 15),
                                  isDense: true,
                                  border: InputBorder.none,
                                ),
                              )*/
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !visibility,
                        child: Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: SizedBox(
                            height: 37,
                            width: double.infinity,
                            child: Container(
                                child: TextButton(
                                  child: Text(s.send_otp,
                                      style: TextStyle(color: c.white)),
                                  style: ButtonStyle(
                                      padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(5)),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          c.colorPrimary),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                                bottomLeft: Radius.circular(25),
                                                bottomRight: Radius.circular(25),
                                              ),
                                              side:
                                              BorderSide(color: Colors.cyan)))),
                                  onPressed: () async {
                                    if (!mobile_number.text.isEmpty) {
                                      if (mobile_number.text.length != 10) {
                                        utils.showAlert(context,
                                            s.mobile_number_must_be_of_10_digits);
                                      } else {
                                        if (await utils.isOnline()) {
                                          // print("Isforgotpassword"+widget.isForgotPassword);
                                          if (utils
                                              .isNumberValid(mobile_number.text)) {
                                            if (widget.isForgotPassword ==
                                                "forgot_password") {
                                            /*  print("Isforgotpassword   " +
                                                  widget.isForgotPassword);*/
                                              FORGOT_PASSWORD_send_otp();
                                            } else if (widget.isForgotPassword ==
                                                "change_password") {
                                              change_password_send_otpParams();
                                            } else {
                                              sendOtp(
                                                  mobile_number.text.toString());
                                            }
                                          } else {
                                            utils.customAlertWidet(context, "Error",
                                                s.please_enter_valid_num);
                                          }
                                        }
                                      }
                                    } else {
                                      utils.showAlert(
                                          context, s.enter_a_valid_mobile_number);
                                    }
                                  },
                                )),
                          ),
                        ),
                      ),
                      //Change Password
                    ]
                      //OTP VERIFICATION
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(s.otp_verification,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black))),
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(s.please_verify_otp,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black),
                              textAlign: TextAlign.center)),
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                            height: 55,
                            child: TextFormField(
                              controller: otp,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.isEmpty
                                  ? s.enter_a_otp
                                  : Utils().isOtpValid(value)
                                      ? null
                                      : s.enter_a_valid_otp,
                              maxLength: 6,
                              decoration: InputDecoration(
                                hintText: s.key_otp,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                filled: true,
                                fillColor: c.ca1,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 0.1, color: c.ca1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: c.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            )),
                      ),
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Padding(
                        padding: EdgeInsets.only(left: 200),
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: Container(
                              child: TextButton(
                            child: Text(
                              s.resend_otp,
                              style:
                                  TextStyle(color: c.colorAccent, fontSize: 13),
                                  textAlign: TextAlign.end,
                                ),
                                onPressed: () async {
                                  if (await utils.isOnline()) {
                                    if (widget.isForgotPassword ==
                                        "forgot_password") {
                                      ResendOtpForgotPasswordParams();
                                    } else if (widget.isForgotPassword ==
                                        "change_password") {
                                      change_password_Resend_otpParams(context);
                                    } else {
                                      resend_otp(context);
                                    }
                                  } else {
                                    utils.customAlertWidet(
                                        context, "Error", s.no_internet);
                                  }
                                },
                              )),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: tcVisibility,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: SizedBox(
                          height: 37,
                          width: double.infinity,
                          child: Container(
                              child: TextButton(
                                child: Text(s.verify,
                                    style: TextStyle(color: c.white, fontSize: 13)),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(10)),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        c.colorPrimary),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                            ),
                                            side: BorderSide(color: Colors.cyan)))),
                                onPressed: () async {
                                  if (!otp.text.isEmpty) {
                                    if (otp.text.length == 6) {
                                      if (await utils.isOnline()) {
                                        if (widget.isForgotPassword ==
                                            "forgot_password") {
                                          FORGOT_PASSWORD_OTP_Params();
                                        } else if (widget.isForgotPassword ==
                                            "change_password") {
                                          change_password_OTP_Params();
                                        } else {
                                          otp_params();
                                        }
                                      } else {
                                        utils.customAlertWidet(
                                            context, "Error", s.no_internet);
                                      }
                                    } else {
                                      utils.showToast(
                                          context, s.otp_must_be_6_characters);
                                    }
                                  } else {
                                    utils.showToast(context, s.otp_mus_be_filled);
                                  }
                                },
                              )),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(s.change_password,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: c.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)),
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                              s.please_enter_new_password_and_confirm_password,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  color: Colors.black),
                              textAlign: TextAlign.center)),
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                            height: 55,
                            child: TextFormField(
                              controller: new_password,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.isEmpty
                                  ? s.please_enter_new_password_and_confirm_password
                                  : Utils().isPasswordValid(value)
                                  ? null
                                  : s.enter_a_valid_password,
                              maxLength: 15,
                              decoration: InputDecoration(
                                hintText: s.enter_new_password,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                filled: true,
                                fillColor: c.ca1,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 0.1, color: c.ca1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: c.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                      ),
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Container(
                            height: 55,
                            child: TextFormField(
                              controller: confirm_password,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.isEmpty
                                  ? s.please_enter_new_password_and_confirm_password
                                  : Utils().isPasswordValid(value)
                                  ? null
                                  : s.enter_a_valid_password,
                              maxLength: 15,
                              decoration: InputDecoration(
                                hintText: s.enter_confirm_password,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                filled: true,
                                fillColor: c.ca1,
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(width: 0.1, color: c.ca1),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1, color: c.colorPrimary),
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                            )),
                      ),
                    ),
                    Visibility(
                      visible: tvisibility,
                      child: Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Container(
                              child: TextButton(
                                child: Text(s.submit,
                                    style: TextStyle(color: c.white, fontSize: 13)),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.all(15)),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        c.colorPrimary),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25),
                                              bottomLeft: Radius.circular(25),
                                              bottomRight: Radius.circular(25),
                                            ),
                                            side: BorderSide(color: Colors.cyan)))),
                                onPressed: () {
                                  ValidatePassword();
                                },
                              )),
                        ),
                      ),
                    )
                  ],
                )))), onWillPop: _onWillPop);
  }

  Future<dynamic> ValidatePassword() async {
    if (new_password.text.length & confirm_password.text.length != 0) {
      if (new_password.text.length & confirm_password.text.length >= 8) {
        if (new_password.text == confirm_password.text) {
          if (await utils.isOnline()) {
            if (widget.isForgotPassword == "forgot_password") {
              forgot_password_Params();
            } else if (widget.isForgotPassword == "change_password") {
              changepassword_params();
            }
          } else {
            utils.customAlertWidet(context, "Error", s.no_internet);
          }
        } else {
          utils.showToast(
              context, s.new_password_and_confirm_password_must_be_same);
        }
      } else {
        utils.showToast(context, s.password_must_be_atleast_8_to_15_characters);
      }
    } else {
      utils.showToast(context, s.password_field_must_not_be_empty);
    }
  }

  Future<dynamic> sendOtp(String mobile_number) async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.resend_otp,
      s.service_key_mobile_number: mobile_number,
    };
    // print(""+mobile_number.text);
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    // print("send_otp_url>>" + url.open_service.toString());
    // print("otp>>" + request.toString());
    String data = response.body;
    // print("otp_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      String mask = mobile_number.replaceAll("\\w(?=\\w{4})", "*");
      mobile_number = mask;
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<void> resend_otp(BuildContext context) async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_resend_otp,
      s.service_key_mobile_number: mobile_number.text,
    };
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("Resend_otp_url>>" + url.open_service.toString());
    print("Resendotp>>" + request.toString());
    String data = response.body;
    print("Resendotp_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      mobile_number.text = "";
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<dynamic> otp_params() async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_verify_otp,
      s.key_mobile_otp: otp.text,
      s.service_key_mobile_number: mobile_number.text,
    };
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("otp_url>>" + url.open_service.toString());
    print("otp>>" + request.toString());
    String data = response.body;
    print("otp_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
      setState(() {
        tcVisibility = !tcVisibility;
        visibility = visibility;
        tvisibility = !tvisibility;
      });
    } else {
      utils.customAlertWidet(context, "Error", s.failed);
    }
  }

  Future<dynamic> FORGOT_PASSWORD_send_otp() async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_send_otp_for_forgot_password,
      s.service_key_mobile_number: mobile_number.text,
      s.key_appcode: s.service_key_appcode,
    };

    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("forgot_password_url>>" + url.open_service.toString());
    print("otp_request>>" + request.toString());
    String data = response.body;
    print("password_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      mobilenumber = mobile_number.text.toString();
      String mask = mobile_number.text.replaceAll("\\w(?=\\w{4})", "*");
      print("Mask" + mask);
      mobile_number.text = mask;
      setState(() {
        tcVisibility = !tcVisibility;
        visibility = !visibility;
      });
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<void> ResendOtpForgotPasswordParams() async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_resend_otp_forgot_password,
      s.service_key_mobile_number: mobile_number.text.toString(),
      s.key_appcode: s.service_key_appcode,
    };
    print("Mobile_number" + mobile_number.text);
    print("Resend_Otp" + request.toString());
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("Resend_otp_forgot_password_url>>" + url.open_service.toString());
    print("Resend_otp_forgot_password_request>>" + request.toString());
    String data = response.body;
    print("Resend_forgot_password_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    var KEY;
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      otp.text = "";
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<void> FORGOT_PASSWORD_OTP_Params() async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_forgotpassword_verify_otp,
      s.service_key_mobile_number: mobile_number.text.toString(),
      s.key_mobile_otp: otp.text,
      s.key_appcode: s.service_key_appcode,
    };
    print("FORGOT_PASSWORD_OTP>>>>>>>>>>" + request.toString());
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("FORGOT_PASSWORD_OTP_url>>" + url.open_service.toString());
    String data = response.body;
    print("FORGOT_PASSWORD_OTP_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    var KEY;
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      mobilenumber = mobile_number.text.toString();
      Otp = otp.text.toString();
      setState(() {
        tcVisibility = !tcVisibility;
        visibility = visibility;
        tvisibility = !tvisibility;
      });
      utils.customAlertWidet(context, "Success", decodedData[s.key_message]);
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<void> forgot_password_Params() async {
    utils.showProgress(context, 1);
    Map request = {
      s.key_service_id: s.service_key_forgotpassword,
      s.service_key_mobile_number: mobile_number.text.toString(),
      s.key_otp: otp.text,
      s.key_new_password: new_password.text,
      s.key_confirm_password: confirm_password.text,
      s.key_appcode: s.service_key_appcode,
    };
    print("forgot_password" + request.toString());
    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = new IOClient(_client);
    var response =
        await _ioClient.post(url.open_service, body: json.encode(request));
    // http.Response response = await http.post(url.open_service, body:jsonEncode(request));
    print("forgot_password_url>>" + url.open_service.toString());
    print("forgot_password_request>>" + request.toString());
    String data = response.body;
    print("forgot_password_response>>" + data);
    utils.hideProgress(context);
    var decodedData = json.decode(data);
    var STATUS = decodedData[s.key_status];
    var RESPONSE = decodedData[s.key_response];
    var KEY;
    if (STATUS.toString() == s.key_ok && RESPONSE.toString() == s.key_ok) {
      utils.customAlertWithDataPassing(
          context, "Success", decodedData[s.key_message], true, false, {});

      /* mobilenumber = mobile_number.text.toString();
      Otp = otp.text.toString();*/
    } else {
      utils.customAlertWidet(context, "Error", decodedData[s.key_message]);
    }
  }

  Future<void> change_password_send_otpParams() async {
    utils.showProgress(context, 1);
    late Map json_request;

    String? key = prefs.getString(s.userPassKey);
    String? userName = prefs.getString(s.key_user_name);

    json_request = {
      s.key_service_id: s.service_key_send_otp_changepassword,
      s.service_key_mobile_number: mobile_number.text,
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

    print("change_password_send_otp_url>>" + url.main_service_jwt.toString());
    print("change_password_send_otp_request_encrypt>>" +
        encrypted_request.toString());

    utils.hideProgress(context);

    if (response.statusCode == 200) {
      String data = response.body;

      print("Change_password_otp" + data);

      String? authorizationHeader = response.headers['authorization'];

      String? token = authorizationHeader?.split(' ')[1];

      print("change_password_send_otp Authorization -  $token");

      String responceSignature = utils.jwt_Decode(key, token!);

      String responceData = utils.generateHmacSha256(data, key, false);

      print("change_password_send_otp responceSignature -  $responceSignature");

      print("change_password_send_otp responceData -  $responceData");

      if (responceSignature == responceData) {
        print("change_password_send_otp responceSignature - Token Verified");

        var userData = jsonDecode(data);

        var status = userData[s.key_status];
        var response_value = userData[s.key_response];
        if (status == s.key_ok && response_value == s.key_ok) {
          mobilenumber = mobile_number.text.toString();
          String mask = mobile_number.text.replaceAll("\\w(?=\\w{4})", "*");
          mobile_number.text = mask;
          setState(() {
            tcVisibility = !tcVisibility;
            visibility = !visibility;
          });
          utils.customAlertWidet(context, "Success", userData[s.key_message]);
        } else {
          utils.customAlertWidet(context, "Error", userData[s.key_message]);
        }
      } else {
        utils.customAlertWidet(context, "Error", s.jsonError);
        print(
            "change_password_send_otp responceSignature - Token Not Verified");
      }
    }
  }

  Future<void> change_password_Resend_otpParams(BuildContext context) async {
    utils.showProgress(context, 1);
    late Map json_request;

    String? key = prefs.getString(s.userPassKey);
    String? userName = prefs.getString(s.key_user_name);

    json_request = {
      s.key_service_id: s.service_key_resend_otp_changepassword,
      s.service_key_mobile_number: mobile_number.text.toString(),
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
    IOClient _ioClient = IOClient(_client);

    var response = await _ioClient.post(url.main_service_jwt,
        body: jsonEncode(encrypted_request), headers: header);

    print("change_password_Resend_otp_url>>" + url.main_service_jwt.toString());
    print("change_password_Resend_otp_request_encrypt>>" +
        encrypted_request.toString());

    utils.hideProgress(context);

    if (response.statusCode == 200) {
      String data = response.body;

      print("Change_password_Resend_otp" + data);

      print("Change_password_Resend_otp_response>>" + data);

      String? authorizationHeader = response.headers['authorization'];

      String? token = authorizationHeader?.split(' ')[1];

      print("Change_password_Resend_otp Authorization -  $token");

      String responceSignature = utils.jwt_Decode(key, token!);

      String responceData = utils.generateHmacSha256(data, key, false);

      print(
          "Change_password_Resend_otp responceSignature -  $responceSignature");

      print("Change_password_Resend_otp responceData -  $responceData");

      if (responceSignature == responceData) {
        print("Change_password_Resend_otp responceSignature - Token Verified");

        var userData = jsonDecode(data);

        var status = userData[s.key_status];
        var response_value = userData[s.key_response];
        if (status == s.key_ok && response_value == s.key_ok) {
          utils.customAlertWidet(context, "Success", userData[s.key_message]);
        } else {
          utils.customAlertWidet(context, "Error", userData[s.key_message]);
        }
      } else {
        utils.customAlertWidet(context, "Error", s.jsonError);
        print(
            "Change_password_Resend_otp responceSignature - Token Not Verified");
      }
    }
  }

  Future<void> change_password_OTP_Params() async {
    utils.showProgress(context, 1);
    late Map json_request;

    String? key = prefs.getString(s.userPassKey);
    String? userName = prefs.getString(s.key_user_name);

    json_request = {
      s.key_service_id: s.service_key_change_password_verify_otp,
      s.service_key_mobile_number: mobile_number.text.toString(),
      s.key_mobile_otp: otp.text.toString(),
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

    print("change_password_send_otp_url>>" + url.main_service_jwt.toString());
    print("change_password_send_otp_request_encrypt>>" +
        encrypted_request.toString());

    utils.hideProgress(context);

    if (response.statusCode == 200) {
      String data = response.body;
      print("Change_password_otp" + data);

      print("Change_password_otp_response>>" + data);

      String? authorizationHeader = response.headers['authorization'];

      String? token = authorizationHeader?.split(' ')[1];

      print("Change_password_otp Authorization -  $token");

      String responceSignature = utils.jwt_Decode(key, token!);

      String responceData = utils.generateHmacSha256(data, key, false);

      print("Change_password_otp responceSignature -  $responceSignature");

      print("Change_password_otp responceData -  $responceData");

      if (responceSignature == responceData) {
        print("Change_password_otp responceSignature - Token Verified");

        var userData = jsonDecode(data);

        var status = userData[s.key_status];
        var response_value = userData[s.key_response];
        if (status == s.key_ok && response_value == s.key_ok) {
          utils.customAlertWidet(context, "Success", userData[s.key_message]);
          setState(() {
            tcVisibility = !tcVisibility;
            visibility = visibility;
            tvisibility = !tvisibility;
          });
        } else {
          utils.customAlertWidet(context, "Error", userData[s.key_message]);
        }
      } else {
        utils.customAlertWidet(context, "Error", s.jsonError);
        print("Change_password_otp responceSignature - Token Not Verified");
      }
    }
  }

  Future<void> changepassword_params() async {
    utils.showProgress(context, 1);
    late Map json_request;

    String? key = prefs.getString(s.userPassKey);
    String? userName = prefs.getString(s.key_user_name);

    json_request = {
      s.key_service_id: s.service_key_change_password,
      s.service_key_mobile_number: mobile_number.text,
      s.key_otp: otp.text,
      s.key_new_password: new_password.text,
      s.key_confirm_password: confirm_password.text
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

    print("ENCRYPTED_REQUEST>>>" + encrypted_request.toString());

    HttpClient _client = HttpClient(context: await utils.globalContext);
    _client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient _ioClient = IOClient(_client);

    var response = await _ioClient.post(url.main_service_jwt,
        body: jsonEncode(encrypted_request), headers: header);

    print("ChangePassword_url>>" + url.main_service_jwt.toString());
    print("ChangePassword_request_encrypt>>" + encrypted_request.toString());

    utils.hideProgress(context);

    if (response.statusCode == 200) {
      String data = response.body;
      print("ChangePassword_response>>" + data);

      print("ChangePassword_response>>" + data);

      String? authorizationHeader = response.headers['authorization'];

      String? token = authorizationHeader?.split(' ')[1];

      print("ChangePassword Authorization -  $token");

      String responceSignature = utils.jwt_Decode(key, token!);

      String responceData = utils.generateHmacSha256(data, key, false);

      print("ChangePassword responceSignature -  $responceSignature");

      print("ChangePassword responceData -  $responceData");

      if (responceSignature == responceData) {
        print("ChangePassword responceSignature - Token Verified");

        var userData = jsonDecode(data);

        var status = userData[s.key_status];
        var response_value = userData[s.key_response];
        if (status == s.key_ok && response_value == s.key_ok) {
          utils.customAlertWithDataPassing(
              context, "Success", userData[s.key_message], true, false, {});
        } else {
          utils.customAlertWidet(context, "Error", userData[s.key_message]);
        }
      } else {
        utils.customAlertWidet(context, "Error", s.jsonError);
        print("ChangePassword responceSignature - Token Not Verified");
      }
    }
  }

  Widget showButton() {
    return Container(
      child: Visibility(
        visible: true,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Container(
              height: 40,
              decoration: new BoxDecoration(
                  color: c.ca2,
                  border: Border.all(color: c.ca2, width: 2),
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  )),
              alignment: AlignmentDirectional.center,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                    contentPadding: EdgeInsets.all(10.0),
                    isDense: true,
                    border: InputBorder.none,
                    hintText: s.enter_confirm_password),
              )),
        ),
      ),
    );
  }
}
