import 'package:flutter/material.dart';

navigateTo(context, widget) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

navigateAndFinish(context, widget) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => widget),
    (route) => false,
  );
}

void showToast(BuildContext context, {required String message}) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      action:
          SnackBarAction(label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
  Navigator.pop(context);
}

String getDay(day) {
  switch (day) {
    case 1:
      return 'Monday';
    case 2:
      return 'Tuesday';
    case 3:
      return 'Wednesday';
    case 4:
      return 'Thursday';
    case 5:
      return 'Friday';
    case 6:
      return 'Saturday';
    case 7:
      return 'Sunday';
    default:
      return 'Err';
  }
}

String getMonth(month) {
  switch (month) {
    case 1:
      return 'Jan, ';
    case 2:
      return 'Feb, ';
    case 3:
      return 'Mar, ';
    case 4:
      return 'Apr, ';
    case 5:
      return 'May';
    case 6:
      return 'Jun, ';
    case 7:
      return 'Jul, ';
    case 8:
      return 'Aug, ';
    case 9:
      return 'Sept, ';
    case 10:
      return 'Oct, ';
    case 11:
      return 'Nov, ';
    case 12:
      return 'Dec, ';
    default:
      return 'Err';
  }
}
