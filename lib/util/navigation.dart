
import 'package:brotherquickstart/util/app_permissions_page.dart';
import 'package:brotherquickstart/brother/brother_bluetooth_printer.dart';
import 'package:brotherquickstart/brother/brother_wifi_printer.dart';
import 'package:brotherquickstart/brother/brother_wifi_scanner.dart';
import 'package:brotherquickstart/home.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class Navigation {

  static  void openBrotherBluetoothPrinter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BrotherBluetoothPrinter(title: 'Brother Bluetooth Printer'),
      ),
    );
  }

  static  void openBrotherBrotherWifiScanner(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BrotherWifiScanner(title: 'Brother Wifi Scanner'),),);
  }

  static  void openBrotherWifiPrinter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BrotherWifiPrinter(title: 'Brother Wifi Printer'),
      ),
    );
  }

  static  void goHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const Home(
                title: "4Site Hacks Scanner",
              )),
      (Route<dynamic> route) => false,
    );
  }

  static  void openAppPermissions(BuildContext context, List<Permission> permissionList) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppPermissions(title: 'App Permissions', permissionList: permissionList),
      ),
    );
  }

  static Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Image.asset("assets/logo2.png", height: 150),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                height: 5,
                color: Colors.black,
              ),
              TextButton.icon(
                label: const Text("Home"),
                onPressed: () {
                  Navigator.pop(context);
                  goHome(context);
                },
                icon: const Icon(Icons.home),
              ),
              TextButton.icon(
                label: const Text("Wifi Printers"),
                onPressed: () {
                  Navigator.pop(context);
                  openBrotherWifiPrinter(context);
                },
                icon: const Icon(Icons.wifi),
              ),
              TextButton.icon(
                label: const Text("Bluetooth Printers"),
                onPressed: () {
                  Navigator.pop(context);
                  openBrotherBluetoothPrinter(context);
                },
                icon: const Icon(Icons.bluetooth),
              ),
              TextButton.icon(
                label: const Text("Wifi Scanner"),
                onPressed: () {
                  Navigator.pop(context);
                  openBrotherBrotherWifiScanner(context);
                },
                icon: const Icon(Icons.scanner),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
