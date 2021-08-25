import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SettingsItemsTile extends StatelessWidget {
  const SettingsItemsTile({
    Key? key,
    required this.iconData,
    required this.title,
    required this.screen,
  }) : super(key: key);
  final IconData iconData;
  final String title;
  final Widget screen;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Icon(
          iconData,
          color: Get.theme.primaryColor,
        ),
        title: Text(title),
        onTap: () => Get.to(() => screen),
      ),
    );
  }
}
