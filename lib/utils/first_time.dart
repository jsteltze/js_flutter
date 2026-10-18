import 'package:shared_preferences/shared_preferences.dart';

Future<void> checkFirstTime(Function onFirstTime) async {
  final prefs = await SharedPreferences.getInstance();
  final bool? isFirstTime = prefs.getBool('first_time');

  if (isFirstTime == null || isFirstTime) {
    onFirstTime.call();
    await prefs.setBool('first_time', false);
  }
}
