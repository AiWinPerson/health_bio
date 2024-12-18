import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'util/controller_bindings.dart';
import 'util/go_router.dart';

import 'package:device_preview/device_preview.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => GetMaterialApp(
        initialBinding: ControllerBindings(),
        getPages: GoRouter.routers,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
      ),));
}