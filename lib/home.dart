import 'dart:io';

import 'package:another_brother/printer_info.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:brotherquickstart/brother/brother_bluetooth_printer.dart';
import 'package:brotherquickstart/brother/brother_wifi_printer.dart';
import 'package:brotherquickstart/brother/brother_wifi_scanner.dart';
import 'package:brotherquickstart/util/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<File> _filesToPrint = List.empty(growable: true);
  bool isPrinting = false;
  PrinterInfo _printInfo = PrinterInfo();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      loadPage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_filesToPrint.isNotEmpty && isPrinting) {
      debugPrint("Home: build: _filesToPrint.isNotEmpty && isPrinting");
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Navigation.buildDrawer(context),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filesToPrint.length,
                    itemBuilder: (BuildContext context, int index) {
                      File file = _filesToPrint[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        shadowColor: Colors.black,
                        // elevation: 11,
                        borderOnForeground: false,
                        color: Colors.white70,
                        child: Column(
                          children: [
                            Image.file(file),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: buildBottomSheet(),
      );
    }

    if (BrotherWifiPrinter.netPrinter == null && BrotherBluetoothPrinter.bluetoothPrinter == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Navigation.buildDrawer(context),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Select Printer.", style: TextStyle(fontSize: 22, color: Colors.black),),
              const SizedBox(height: 11,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      onPressed: () {
                        onPressedWifi();
                      },
                      icon: const Icon(Icons.wifi),
                      label: const Text("Wifi Printer")),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      onPressed: () {
                        onPressedBluetooth();
                      },
                      icon: const Icon(Icons.bluetooth),
                      label: const Text("Bluetooth Printer")),
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (BrotherWifiScanner.connector != null && BrotherWifiScanner.outScannedPaths.isNotEmpty) {
      printOutScannedPaths();
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Navigation.buildDrawer(context),
        body: const SafeArea(
          child: Center(
            child: Text("Scanner and printing"),
          ),
        ),
      );
    }
    debugPrint("Home: build: default");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Navigation.buildDrawer(context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("1. Place paper in scanner.", style: TextStyle(fontSize: 22, color: Colors.black),),
              const SizedBox(height: 11,),
              const Text("2. Select scanner.", style: TextStyle(fontSize: 22, color: Colors.black),),
              const SizedBox(height: 11,),
              const Text("3. Watch the magic.", style: TextStyle(fontSize: 22, color: Colors.black),),
              const SizedBox(height: 11,),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  onPressed: () {
                    onPressedScanner();
                  },
                  icon: const Icon(Icons.scanner),
                  label: const Text("Wifi scanner")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadPage() async {
    await permissionCheck();
  }

  Future<void> permissionCheck() async {
    try {
      List<Permission> _permissionList = List.empty(growable: true);
      int index = -99;
      bool doAskForPermission = false;
      if (Platform.isAndroid) {
        index = Permission.values.indexWhere((f) => f.value == Permission.bluetoothScan.value);
        Permission bluetoothScan = Permission.values.elementAt(index);
        if (!await Permission.bluetoothScan.isGranted) {
          doAskForPermission = true;
        }
        index = Permission.values.indexWhere((f) => f.value == Permission.bluetoothConnect.value);
        Permission bluetoothConnect = Permission.values.elementAt(index);
        if (!await Permission.bluetoothConnect.isGranted) {
          doAskForPermission = true;
        }
        index = Permission.values.indexWhere((f) => f.value == Permission.storage.value);
        Permission storage = Permission.values.elementAt(index);
        if (!await Permission.storage.isGranted) {
          doAskForPermission = true;
        }
        debugPrint("Home: Permission: bluetoothScan: ${await Permission.bluetoothScan.isGranted}");
        debugPrint("Home: Permission: bluetoothConnect: ${await Permission.bluetoothConnect.isGranted}");
        debugPrint("Home: Permission: storage ${await Permission.storage.isGranted}");

        _permissionList = <Permission>[bluetoothScan, bluetoothConnect, storage];
        debugPrint("Home: Permission: _permissionList.length: ${_permissionList.length}");
      }
      // if (Platform.isIOS) {
      //   index = Permission.values.indexWhere((f) => f.value == Permission.storage.value);
      //   Permission storage = Permission.values.elementAt(index);
      //   if (!await Permission.storage.isGranted) {
      //     doAskForPermission = true;
      //   }
      //
      //   index = Permission.values.indexWhere((f) => f.value == Permission.bluetoothScan.value);
      //   Permission bluetoothScan = Permission.values.elementAt(index);
      //   if (!await Permission.bluetoothScan.isGranted) {
      //     doAskForPermission = true;
      //   }
      //
      //   index = Permission.values.indexWhere((f) => f.value == Permission.bluetoothAdvertise.value);
      //   Permission bluetoothAdvertise = Permission.values.elementAt(index);
      //   if (!await Permission.bluetoothAdvertise.isGranted) {
      //     doAskForPermission = true;
      //   }
      //
      //   index = Permission.values.indexWhere((f) => f.value == Permission.bluetoothConnect.value);
      //   Permission bluetoothConnect = Permission.values.elementAt(index);
      //   if (!await Permission.bluetoothConnect.isGranted) {
      //     doAskForPermission = true;
      //   }
      //   _permissionList = <Permission>[storage, bluetoothScan, bluetoothAdvertise, bluetoothConnect];
      //   debugPrint("Home: Permission: _permissionList.length: ${_permissionList.length}");
      // }
      if (doAskForPermission) {
        Navigation.openAppPermissions(context, _permissionList);
      }
    } catch (e) {
      debugPrint("Home: loadPage: ERROR $e");
    }
  }

  Future<void> printBrotherWifiPrinter() async {
    debugPrint("PrintImage: printBrotherWifiPrinter: _filesToPrint.length: ${_filesToPrint.length}");

    if (_filesToPrint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              'Select images to print',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent),
      );
      return;
    }
    if (BrotherWifiPrinter.netPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              'Wifi printer has not been selected',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent),
      );
      return;
    }

    // _file = await ImageUtil().rotate(_file!.path, 90);
    //here is the print statement
    setState(() {
      isPrinting = true;
    });

    await BrotherWifiPrinter.print(_filesToPrint.toList(), eventListenerPrintStatus)
        .onError((error, stackTrace) => {debugPrint("PrintImage: BrotherWifiPrinter: error: $error stackTrace: $stackTrace")})
        .catchError((onError) => {debugPrint("PrintImage: BrotherWifiPrinter: onError: $onError ")});
    setState(() {
      isPrinting = false;
    });
  }

  Future<void> printBrotherBluetoothPrinter() async {
    debugPrint("PrintImage: printBrotherBluetoothPrinter: _filesToPrint.length: ${_filesToPrint.length}");
    if (_filesToPrint.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              'Select image first',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent),
      );
      return;
    }
    if (BrotherBluetoothPrinter.bluetoothPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
              'Bluetooth printer has not been selected',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent),
      );
      return;
    }

    // _file = await ImageUtil().rotate(_file!.path, 90);
    //here is the print statement
    setState(() {
      isPrinting = true;
    });

    await BrotherBluetoothPrinter.print(_filesToPrint.toList(), eventListenerPrintStatus).onError((error, stackTrace) {
      debugPrint("PrintImage: printBrotherBluetoothPrinter: onError:  $error stackTrace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              error.toString(),
              style: const TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.amberAccent),
      );
    }).catchError((catchError) {
      debugPrint("PrintImage: printBrotherBluetoothPrinter: catchError:  $catchError");
    });
    setState(() {
      isPrinting = false;
    });
  }

  eventListenerPrintStatus(PrinterStatus printerStatus, PrinterInfo printInfo) async {
    debugPrint("Home: eventListenerPrintStatus: printInfo:labelNameIndex: ${printInfo.labelNameIndex}");
    debugPrint("Home: eventListenerPrintStatus: printInfo:getPaperId: ${printInfo.paperSize.getPaperId()}");
    if (printerStatus.errorCode.getName().compareTo(ErrorCode.ERROR_NONE.getName()) == 0) {
      _filesToPrint.removeAt(0);
    }
    if(_filesToPrint.isEmpty){
      AudioCache player =  AudioCache();
      const alarmAudioPath = "tada-sound.mp3";
      player.play(alarmAudioPath);
    }
    _printInfo = printInfo;
    setState(() {});
  }

  Widget buildBottomSheet() {
    debugPrint("Home: buildBottomSheet");
    double width = (MediaQuery.of(context).size.width);
    return Container(
        color: Colors.blue,
        height: 120,
        width: width,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(":: Checking for the correct label size::", style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6))),
            Text("Checking paper Size ${_printInfo.labelNameIndex}", style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6))),
            Text("Checking paper Type ${_printInfo.paperSize.getName()}", style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.6))),
          ],
        ));
  }

  Future<void> printToBrotherPrinter() async {
    debugPrint("Home: printBrotherToPrinter:");
    if (BrotherWifiPrinter.netPrinter != null) {
      printBrotherWifiPrinter();
      return;
    }
    if (BrotherBluetoothPrinter.bluetoothPrinter != null) {
      printBrotherBluetoothPrinter();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
            'Printer has not been selected',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amberAccent),
    );
  }

  void onPressedWifi() {
    Navigation.openBrotherWifiPrinter(context);
  }

  void onPressedBluetooth() {
    Navigation.openBrotherBluetoothPrinter(context);
  }

  void onPressedScanner() {
    Navigation.openBrotherBrotherWifiScanner(context);
  }

  Future<void> printOutScannedPaths() async {
    debugPrint("printOutScannedPaths: ");
    setState(() {isPrinting = true;});
    for (String scannedPath in BrotherWifiScanner.outScannedPaths) {
      // File f = await ImageUtil.jpegToPng(scannedPath);
      File f = File(scannedPath);
      scannedPath = scannedPath.replaceAll(".jpq", ".jpg");
      f = await f.rename(scannedPath);
      _filesToPrint.add(f);
    }
    //scanned images are no longer needed so set to empty
    BrotherWifiScanner.outScannedPaths = List.empty(growable: true);
    setState(() {_filesToPrint;});

    printToBrotherPrinter();
  }
}
