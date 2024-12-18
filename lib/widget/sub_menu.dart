import 'dart:ui';

import 'package:flutter/material.dart';

import '../controller/device_controller.dart';
import '../util/app_dimens.dart';
import '../util/color_set.dart';
import '../util/enum.dart';

class SubMenu extends StatelessWidget {
  const SubMenu({super.key, required this.selectedTitle, required this.onPressed});
  final String selectedTitle;
  final Function(String) onPressed;

  final TextStyle unSelectedStyle = const TextStyle(color: ColorSet.blackOpacity300,fontSize: 18,fontWeight: FontWeight.w600);
  final TextStyle selectedStyle = const TextStyle(color: ColorSet.violet500,fontSize: 20,fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorSet.white,
      width: AppDimens.subMenuWidth,
      height: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 15),
            child: Image.asset("asset/logo.png",width: DeviceController.to.device.value == DeviceEnum.phone? 150 : 180,),
          ),
          ...SubMenuEnum.values.map((e) => subMenu(
              icon: e.icon,
              menu: e.title,
              style: e.title == selectedTitle? selectedStyle : unSelectedStyle,
              onPressed: () => onPressed(e.title)
          )),
          const Spacer(),
          subMenu(icon: Icons.logout, menu: "Logout", onPressed: (){},style: unSelectedStyle)
        ],
      ),
    );
  }

  Widget subMenu({required IconData icon,required String menu,required VoidCallback onPressed,required TextStyle style}){
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        splashFactory: NoSplash.splashFactory,
        backgroundColor: ColorSet.transparent,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 20,),
            Text(menu,style: style,)
          ],
        ),
      ),
    );
  }

}
