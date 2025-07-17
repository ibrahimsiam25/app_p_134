import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dependencies.dart';
import 'core/database/local_date.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData.initLocalService();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(
    const Application(),
  );
}
