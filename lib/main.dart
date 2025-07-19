import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dependencies.dart';
import 'core/database/local_date.dart';
import 'package:device_preview/device_preview.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await ScreenUtil.ensureScreenSize();
  await LocalData.initLocalService();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(
      DevicePreview(
         enabled: !kReleaseMode,
        builder:

        (context)=>  const Application(),

       )
  //  const Application(),
  );
}
 