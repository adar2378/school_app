import 'package:school_app/Api/api_provider.dart';
import 'package:school_app/Model/LogData.dart';
import 'package:school_app/Model/device.dart';

class Repository {
  ApiProvider _apiProvider = ApiProvider();

  Future<LogData> fetchLog(String deviceId, String startDate, String endDate) =>
      _apiProvider.fetchLog(deviceId, startDate, endDate);

  Future<List<Device>> getDevices() => _apiProvider.getDevices();

  Future<List<String>> getUserList() => _apiProvider.getUserList();
}
