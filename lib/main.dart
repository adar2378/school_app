import 'package:flutter/material.dart';
import 'package:school_app/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      theme: ThemeData(
          fontFamily: "Ubuntu",
          appBarTheme: AppBarTheme(
              elevation: 0,
              color: Colors.white,
              textTheme: TextTheme(
                  title: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.black))),
      onGenerateRoute: Routes().getRoute,
      builder: (context, child) {
        var data = MediaQuery.of(context).copyWith(
            textScaleFactor: (1 - (MediaQuery.of(context).textScaleFactor - 1))
                .abs()); // formula to scale text
        return MediaQuery(
          data: data,
          child: child,
        );
      },
    );
  }
}
