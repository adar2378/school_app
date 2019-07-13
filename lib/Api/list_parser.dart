// this will parse output string returned from the api call for device list

import 'package:school_app/Model/device.dart';

class ListParser {
  final String inputString;
  ListParser({this.inputString});

  List<dynamic> getDeviceList(bool device) {
    var itemList = device ? <Device>[] : <String>[];
    String trimmed = inputString.substring(1, inputString.length - 1);
    print(trimmed);
    int startIndex = 0;
    int endIndex = 0;

    for (int i = 0; i < trimmed.length; i++) {
      if (trimmed[i] == '(') {
        startIndex = i;
      } else if (trimmed[i] == ')') {
        endIndex = i;
        var deviceData = trimmed
            .substring(startIndex + 1, endIndex - 1)
            .replaceAll(RegExp(r"u'"), '');
        var list = deviceData.split(',');
        if (device) {
          itemList.add(Device(
              deviceId: list[0].substring(0, list[0].length - 1),
              deviceName: list[1].substring(0, list[1].length - 1)));
        } else {
          itemList.add(list[0].substring(0, list[0].length - 1));
        }
      }
    }
    return itemList;
  }
}
