import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/device_controller.dart';
import '../util/app_dimens.dart';
import '../util/color_set.dart';
import '../util/enum.dart';
import '../widget/sub_menu.dart';
import 'appointment.dart';
import 'dashboard.dart';
import 'messages.dart';
import 'patients.dart';
import 'settings.dart';

class Home extends StatefulWidget {
  const Home({Key? key,required this.menu}) : super(key: key);
  final SubMenuEnum menu;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet.white200,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          DeviceController.to.updateDeviceType(context);
          bool isNeedDrawer = constraints.maxWidth < AppDimens.subMenuWidth + AppDimens.minPageWidth;
          final appMenuWidget = SubMenu(
            onPressed: (title){
              if(widget.menu.title != title){
                Get.offAllNamed("/$title");
              }
            },
            selectedTitle: widget.menu.title,
          );
          final body = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            child: getPages(),
          );
          if(isNeedDrawer){
            return Scaffold(
              backgroundColor: ColorSet.white200,
              drawer: Drawer(
                child: appMenuWidget,
              ),
              appBar: AppBar(
                backgroundColor: ColorSet.white200,
                title: Image.asset("asset/logo.png",color: ColorSet.violet500,height: 28,),
              ),
              body: body,
            );
          }
          return Scaffold(
            backgroundColor: ColorSet.white200,
            body: Row(
              children: [
                appMenuWidget,
                Expanded(
                  child: body
                ),
              ],
            ),
          );
        },),
      ),
    );
  }

  Widget getPages(){
    switch(widget.menu){
      case SubMenuEnum.settings:
        return const Settings();
      case SubMenuEnum.messages:
        return const Messages();
      case SubMenuEnum.patients:
        return const Patients();
      case SubMenuEnum.appointment:
        return const Appointment();
      case SubMenuEnum.dashboard:
        return const Dashboard();
      default:
        return const Dashboard();
    }
  }

}
