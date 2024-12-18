import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/enum.dart';

class DeviceController extends GetxController{
  static DeviceController to = Get.find<DeviceController>();
  Rx<DeviceEnum> device = DeviceEnum.tablet.obs;

  void updateDeviceType(BuildContext context){
    double deviceWidth = MediaQuery.of(context).size.shortestSide;
    device.value = deviceWidth < 600? DeviceEnum.phone : DeviceEnum.tablet;
  }

}