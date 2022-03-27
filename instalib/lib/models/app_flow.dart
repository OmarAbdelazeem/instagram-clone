import 'package:flutter/widgets.dart';

/// Holds information about our app's flows.
class AppFlow {
  const AppFlow({
    @required this.iconData,
    @required this.navigatorKey,
  })  : assert(iconData != null),
        assert(navigatorKey != null);

  final IconData iconData;
  final GlobalKey<NavigatorState> navigatorKey;
}
