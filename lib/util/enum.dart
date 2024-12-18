import 'package:flutter/material.dart';

enum SubMenuEnum{

  settings("Settings",Icons.settings),
  messages("Messages",Icons.message_rounded),
  patients("Patients",Icons.medical_services),
  appointment("Appointment",Icons.calendar_today),
  dashboard("Dashboard",Icons.dashboard);
  const SubMenuEnum(this.title,this.icon);
  final String title;
  final IconData icon;
}

enum DeviceEnum{
  phone,
  tablet,
}