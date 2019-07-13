// To parse this JSON data, do
//
//     final logData = logDataFromJson(jsonString);

import 'dart:convert';

LogData logDataFromJson(String str) => LogData.fromJson(json.decode(str));

String logDataToJson(LogData data) => json.encode(data.toJson());

class LogData {
    List<Log> log;

    LogData({
        this.log,
    });

    factory LogData.fromJson(Map<String, dynamic> json) => new LogData(
        log: new List<Log>.from(json["log"].map((x) => Log.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "log": new List<dynamic>.from(log.map((x) => x.toJson())),
    };
}

class Log {
    String unitName;
    String registrationId;
    String accessTime;
    String department;
    String accessDate;
    String userName;
    String card;

    Log({
        this.unitName,
        this.registrationId,
        this.accessTime,
        this.department,
        this.accessDate,
        this.userName,
        this.card,
    });

    factory Log.fromJson(Map<String, dynamic> json) => new Log(
        unitName: json["unit_name"],
        registrationId: json["registration_id"],
        accessTime: json["access_time"],
        department: json["department"],
        accessDate:json["access_date"],
        userName: json["user_name"],
        card: json["card"],
    );

    Map<String, dynamic> toJson() => {
        "unit_name": unitName,
        "registration_id": registrationId,
        "access_time": accessTime,
        "department": department,
        "access_date": accessDate,
        "user_name": userName,
        "card": card,
    };
}
