import 'package:get/get.dart';

import '../screen/home.dart';
import 'enum.dart';

class GoRouter{
  static List<GetPage> routers = [
    GetPage(name: "/", page: () => const Home(menu: SubMenuEnum.dashboard),transition: Transition.noTransition),
    GetPage(name: "/${SubMenuEnum.settings.title}", page: () => const Home(menu: SubMenuEnum.settings),transition: Transition.noTransition),
    GetPage(name: "/${SubMenuEnum.messages.title}", page: () => const Home(menu: SubMenuEnum.messages),transition: Transition.noTransition),
    GetPage(name: "/${SubMenuEnum.patients.title}", page: () => const Home(menu: SubMenuEnum.patients),transition: Transition.noTransition),
    GetPage(name: "/${SubMenuEnum.appointment.title}", page: () => const Home(menu: SubMenuEnum.appointment),transition: Transition.noTransition),
    GetPage(name: "/${SubMenuEnum.dashboard.title}", page: () => const Home(menu: SubMenuEnum.dashboard),transition: Transition.noTransition),
  ];
}