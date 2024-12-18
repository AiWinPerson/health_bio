import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'util/controller_bindings.dart';
import 'util/go_router.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(GetMaterialApp(
    initialBinding: ControllerBindings(),
    getPages: GoRouter.routers,
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
  ));
}