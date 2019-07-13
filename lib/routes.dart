import 'package:flutter/material.dart';

import 'Screens/all_users_screen.dart';
import 'Screens/details_table.dart';
import 'Screens/homepage.dart';

class Routes {
  Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/all_products':
        return _buildRoute(settings, HomePage());
      case '/all_users':
        return _buildRoute(settings, AllUserScreen(settings.arguments));
      case '/details':
        DetailsTable detailsTable = settings.arguments;
        return _buildRoute(
            settings,
            DetailsTable(
              userName: detailsTable.userName,
              deviceId: detailsTable.deviceId,
            ));
      // case '/login':
      //   return _buildRoute(settings, AccountScreen());
      // case '/checkout':
      //   return _buildRoute(settings, CheckoutScreen());
      // case '/account_checker':
      //   return _buildRoute(settings, AccountCheckerScreen());
      // case '/product_details':
      //   return _buildRoute(
      //       settings,
      //       ProductDetails(
      //         product: settings.arguments,
      //       ));

      default:
        return _buildRoute(settings, HomePage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      maintainState: true,
      builder: (BuildContext context) => builder,
    );
  }
}
