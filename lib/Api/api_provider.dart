import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:school_app/Api/list_parser.dart';
import 'package:school_app/Model/LogData.dart';
import 'package:school_app/Model/device.dart';
import 'package:school_app/TableElements/data_processor.dart';

class ApiProvider {
  final String baseUrl = "https://rumytechnologies.com/rams/json_api";
  final String authCode = "u37b8dfjeai2wx8ca0gt109u4qms83p";
  final String authUser = "xbit";
  final String startingTime = "08:00:00"; //8am
  final String endingTime = "17:00:00"; // 5pm
  final Duration timeOutDuration = Duration(seconds: 15);

  Future<LogData> fetchLog(
      String deviceId, String startDate, String endDate) async {
    http.Client client = http.Client();
    LogData logData;
    var payloadMap = <String, String>{
      'operation': _Operation.fetchLog,
      'auth_user': authUser,
      'auth_code': authCode,
      'device_id': deviceId,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startingTime,
      'end_time': endingTime
    };
    var payload = jsonEncode(payloadMap);
    // print(payload);
    try {
      final response = await client.post(baseUrl,
          headers: {'Content-Type': 'application/json'}, body: payload);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        logData = logDataFromJson(response.body);
      } else {
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint(e);
    }
    client.close();
    return logData;
  }

  Future<List<Device>> getDevices() async {
    var result;
    http.Client client = http.Client();
    var payloadMap = <String, String>{
      'operation': _Operation.fetchDeviceDetail,
      'auth_user': authUser,
      'auth_code': authCode,
    };
    var payload = jsonEncode(payloadMap);
    try {
      final response = await client.post(baseUrl,
          headers: {'Content-Type': 'application/json'}, body: payload);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // print(response.body);
        result = ListParser(inputString: response.body).getDeviceList(true);
      } else {
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint(e);
    }
    return result;
  }

  Future<List<String>> getUserList() async {
    var result;
    http.Client client = http.Client();
    var payloadMap = <String, String>{
      'operation': _Operation.fetchUserInDeviceList,
      'auth_user': authUser,
      'auth_code': authCode,
    };
    var payload = jsonEncode(payloadMap);
    try {
      final response = await client.post(baseUrl,
          headers: {'Content-Type': 'application/json'}, body: payload);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // print(response.body);
        result = ListParser(inputString: response.body).getDeviceList(false);
      } else {
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint(e);
    }
    return result;
  }
}

class _Operation {
  static String fetchLog = "fetch_log";
  static String fetchDeviceDetail = "fetch_device_detail";
  static String fetchUserList = "fetch_user_list";
  static String fetchUserInDeviceList = "fetch_user_in_device_list";
}
