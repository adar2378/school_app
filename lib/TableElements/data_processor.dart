import 'package:flutter/foundation.dart';
import 'package:school_app/Model/LogData.dart';

class DataProcessor {
  final LogData logData;
  DataProcessor({@required this.logData});
  Map<String, String> getUsers() {
    var users = <String, String>{};

    var logList = logData.log;
    for (int i = 0; i < logList.length; i++) {
      var name = logList[i].registrationId;
      users.putIfAbsent(name, () => name);
    }
    users.forEach((k, v) => print(k));
    return users;
  }

  List<AttendenceData> getUserDetails(String user) {
    print("starting");
    var logList = logData.log;
    var entryMap = <AttendenceData>[];
    var currentDate = "";
    var tempTime = AttendenceData();
    for (int i = 0; i < logList.length; i++) {
      if (logList[i].registrationId == user) {
        // print(
        //     'found user current: $currentDate date :${logList[i].accessDate} ');
        if (currentDate.isEmpty) {
          currentDate = logList[i].accessDate.toString();
          tempTime.setDate = currentDate;
          tempTime.accessTimes.add(logList[i].accessTime);
        } else if (currentDate == logList[i].accessDate.toString()) {
          tempTime.accessTimes.add(logList[i].accessTime);
        } else if (currentDate != logList[i].accessDate.toString()) {
          print(
              "adding new entry ${logList[i].accessDate}  ${logList[i].accessTime}");

          entryMap.add(tempTime);
          tempTime = AttendenceData();
          currentDate = logList[i].accessDate.toString();
          tempTime.accessTimes.add(logList[i].accessTime);
          tempTime.setDate = currentDate;
        }
      }
    }
    if (tempTime.date != null) {
      // print("adding to map from temp");
      entryMap.add(tempTime);
    }
    for (int i = 0; i < entryMap.length; i++) {
      for (int j = 0; j < entryMap[i].accessTimes.length; j++) {
        print(
            "date : ${entryMap[i].date} Times x $j  ${entryMap[i].accessTimes[j]}");
      }
    }

    print(entryMap.length);
    return entryMap;
    // entryMap.forEach((v) => print(
    //     "date: ${v.date} entered: ${v.accessTimes.first} left: ${v.accessTimes.last} "));
    // print("finished");
  }
}

class AttendenceData {
  String date;
  var accessTimes = <String>[];

  set setDate(String date) => this.date = date;
}
