import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/logger.dart';
import '../utils/package_info_global.dart';

Scaffold createScaffold({
  required BuildContext context,
  String appIconPath = "assets/app_logo.png",
  required Widget child,
  List<Widget>? actions,
  Widget? floatingActionButton,
  required bool isLoading,
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      leading: Container(
        padding: const EdgeInsets.all(8),
        child: Image.asset(appIconPath),
      ),
      title: FittedBox(
        fit: .fitWidth,
        child: Text(Globals.packageInfo.appName),
      ),
      actions: actions,
    ),
    body: isLoading ? const Center(child: CircularProgressIndicator()) : child,
    floatingActionButton: floatingActionButton,
  );
}

MaterialApp createApp(String appTitle, Widget child) {
  return MaterialApp(
    title: appTitle,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: .dark,
      ),
      useMaterial3: true,
    ),
    themeMode: .system,
    home: child,
  );
}

void initApp(Widget content) async {
  WidgetsFlutterBinding.ensureInitialized();
  await FileLogger.init();
  final packageInfo = await PackageInfo.fromPlatform();
  Globals.packageInfo = packageInfo;
  FileLogger.log(
    'Starting app "${Globals.packageInfo.appName}" (${Globals.packageInfo.version})',
  );

  runApp(JsFlutterApp(content));
}

class JsFlutterApp extends StatelessWidget {
  final Widget content;

  const JsFlutterApp(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return createApp(Globals.packageInfo.appName, content);
  }
}
