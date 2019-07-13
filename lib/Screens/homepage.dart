import 'package:flutter/material.dart';
import 'package:school_app/Api/repository.dart';
import 'package:school_app/Model/device.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Repository repository;
  Future deviceFuture;
  @override
  void initState() {
    repository = Repository();
    deviceFuture = repository.getDevices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FlutterLogo(),
        centerTitle: true,
        elevation: 2,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: Center(child: Text("List of schools"))),
          Expanded(
            flex: 10,
            child: Container(
              child: FutureBuilder<List<Device>>(
                future: deviceFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error occurred!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
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
                                Navigator.pushNamed(context, '/all_users',arguments: snapshot.data[index].deviceId);
                              },
                              leading: Icon(Icons.school),
                              title: Text(snapshot.data[index].deviceName),
                              subtitle: Text(snapshot.data[index].deviceId),
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
          )
        ],
      ),
    );
  }
}
