import 'package:flutter/material.dart';
import 'package:school_app/Api/repository.dart';
import 'package:school_app/Screens/details_table.dart';

class AllUserScreen extends StatefulWidget {
  final String deviceId;
  AllUserScreen(this.deviceId);
  @override
  _AllUserScreenState createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  Future userFuture;
  Repository _repository;
  @override
  void initState() {
    _repository = Repository();
    userFuture = _repository.getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<String>>(
          future: userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error occurred!");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: 40,
                  width: 40,
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasData) {
              if (snapshot.data == null) {
                return Text("No data found!");
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/details',
                              arguments: DetailsTable(
                                deviceId: widget.deviceId,
                                userName: snapshot.data[index],
                              ));
                        },
                        leading: Icon(Icons.person),
                        title: Text(snapshot.data[index]),
                      ),
                    );
                  },
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
