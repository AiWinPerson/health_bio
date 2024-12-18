import 'package:get/get.dart';

import '../controller/device_controller.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(DeviceController(),permanent: true);
    // TODO: implement dependencies
  }

}