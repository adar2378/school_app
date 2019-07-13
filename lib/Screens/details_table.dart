import 'package:flutter/material.dart';
import 'package:school_app/Bloc/logDataBloc.dart';
import 'package:intl/intl.dart';
import 'package:school_app/TableElements/data_processor.dart';

class DetailsTable extends StatefulWidget {
  final String userName;
  final String deviceId;
  DetailsTable({this.userName, this.deviceId});
  @override
  _DetailsTableState createState() => _DetailsTableState();
}

class _DetailsTableState extends State<DetailsTable> {
  String user;
  Future future;
  LogDataBloc logDataBloc;

  @override
  void initState() {
    user = widget.userName;
    logDataBloc = LogDataBloc();

    super.initState();
  }

  DataTable generateTableElements(List<AttendenceData> attendenceData) {
    var result = <DataRow>[];

    for (int i = 0; i < attendenceData.length; i++) {
      result.add(DataRow(cells: [
        DataCell(Text(attendenceData[i].date)),
        DataCell(Text(TimeOfDay.fromDateTime(DateTime.parse(
                attendenceData[i].date +
                    " " +
                    attendenceData[i]
                        .accessTimes
                        .first)) // converting 24 hours to 12 hours time
            .format(context))),
        DataCell(Text(TimeOfDay.fromDateTime(DateTime.parse(
                attendenceData[i].date +
                    " " +
                    attendenceData[i].accessTimes.last))
            .format(context))),
      ]));
    }
    DataTable table = DataTable(
      columns: [
        DataColumn(
          label: Text("Date"),
        ),
        DataColumn(
          label: Text("Entered"),
        ),
        DataColumn(
          label: Text("Left"),
        )
      ],
      rows: result,
    );
    return table;
  }

  Future<String> _selectDate(BuildContext context, bool from) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: from ? fromDateTime : toDateTime,
        firstDate: from ? DateTime(2015, 8) : fromDateTime,
        lastDate: DateTime.now());
    if (picked != null) {
      if (from) {
        fromDateTime =
            picked; // if formDate then assign the value to fromDateTime else toDateTime
      } else {
        toDateTime = picked;
      }
      return DateFormat('yyyy-MM-dd').format(picked);
    } else
      return from ? fromDate : toDate;
  }

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  String fromDate = DateFormat('yyyy-MM-dd').format(DateTime
      .now()); // setting the dateTime format to something like '2019-07-09'
  String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$user's Detail"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('From'),
                    SizedBox(
                      width: 8,
                    ),
                    OutlineButton(
                      color: Colors.black12,
                      child: Text(fromDate),
                      onPressed: () {
                        _selectDate(context, true).then((v) {
                          setState(() {
                            fromDate = v;
                          });
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('To'),
                    SizedBox(
                      width: 8,
                    ),
                    OutlineButton(
                      child: Text(toDate),
                      onPressed: () {
                        _selectDate(context, false).then((v) {
                          setState(() {
                            toDate = v;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            RaisedButton(
              child: Text('show table'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                logDataBloc.inputSink.add(InputMap(event: Event.fetch, value: {
                  'startDate': fromDate,
                  'endDate': toDate,
                  'deviceId': widget.deviceId,
                  'user': user
                }));
              },
            ),
            StreamBuilder<OutputMap>(
              stream: logDataBloc.outputStream,
              initialData: OutputMap(state: ScreenState.idle, value: 0),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error);
                } else if (snapshot.data.state == ScreenState.loading) {
                  return Container(
                      height: 40,
                      width: 40,
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasData) {
                  
                  if (snapshot.data != null &&
                      snapshot.data.state == ScreenState.done) {
                    List<AttendenceData> result = snapshot.data.value;
                    if (result != null && result.length != 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.green.shade300,
                                ),
                                Text(
                                  'Present ${snapshot.data.value.length}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.clear,
                                  color: Colors.red.shade300,
                                ),
                                Text(
                                  'Absent ${toDateTime.difference(fromDateTime).inDays - (toDateTime.difference(fromDateTime).inDays ~/ 7) - snapshot.data.value.length}',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          generateTableElements(snapshot.data.value),
                        ],
                      ); // generating the table based on result
                    } else {
                      return Center(child: Text("No data found!"));
                    }
                  } else if (snapshot.data.state == ScreenState.idle) {
                    return Center(
                        child: Text("please press 'show table' to view data"));
                  } else {
                    return Center(child: Text("No data found!"));
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
