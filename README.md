# 4SITE Inc Brother Quick Start
## Brother Flutter Quick Start Font
### brother hack 2022 Micro Challenge 
[Youtube video](https://youtu.be/1aQoBwpqSw8)

[https://brotherhackathon.com/](https://brotherhackathon.com/)

A Flutter project to demo 'how to print' to mobile Brother printers using flutter.  
This provides a project for bootstraping mobile printing.

supports **Android** and **IOS** and only Brother mobile printers.

in a nutshell, all you have to do to print an image is ...

- await BrotherWifiPrinter.print(imageFile);
- await BrotherBluetoothPrinter.print(imageFile);

to scan using a wifi brother mobile scanner
- Navigation().openBrotherBrotherWifiScanner(BuildContext);  
  -- select the scanner

## Getting Started
This project is a starting point for a Flutter application.
- [another_brother: ^0.0.25](https://pub.dev/packages/another_brother)
- [air_brother: ^0.1.3](https://pub.dev/packages/air_brother)
- file_picker: ^4.5.1
- path_provider: ^2.0.9
- permission_handler: ^9.2.0
- image: ^3.1.3
- gallery_saver: ^2.3.2
- google_fonts: ^2.3.2
- flutter_native_splash: ^2.1.6
- audioplayers: ^0.20.1



## core key files

- lib/brother/brother_bluetooth_printer.dart  
  -- find bluetooth printers  
  -- print the file to the selected printer
- lib/brother/brother_wifi_printer.dart  
  -- find wifi printers  
  -- print the file to the selected printer
- lib/brother/brother_wifi_scanner.dart  
  -- find wifi scanners  
  -- select the scanner to start the scan
  -- will automatically print the scanned page


- lib/util/printable_widget.dart
  -- class to convert widget to image

- lib/util/image_util.dart
  -- standard image methods

- lib/util/permission_util.dart
  -- Grrr stupid permissions
- lib/util/app_permissions_page.dart
  -- Grrr stupid permissions

- lib/util/navigation.dart
  -- static methods to switch screens
  
- lib/home.dart
  -- implementation of most classes of the above.
  

## Manual updates
### Android app/src/main/AndroidManifest.xml

```  

	<uses-feature android:name="android.hardware.bluetooth_le" android:required="false"/>
	<uses-feature android:name="android.hardware.bluetooth" android:required="false"/>
	<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
	<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />	
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
	<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
	<uses-permission android:name="android.permission.BLUETOOTH_ADMIN"  android:maxSdkVersion="30" />
	<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
	<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
	<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
	<uses-permission android:name="android.permission.BLUETOOTH"  android:maxSdkVersion="30" />
	<uses-permission android:name="android.permission.CAMERA" />
	<uses-permission android:name="android.permission.INTERNET" />
	<uses-permission android:name="android.permission.QUERY_ALL_PACKAGES" />
	<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
	<uses-permission android:name="android.permission.RECORD_AUDIO" />
	<uses-permission android:name="android.permission.VIBRATE" />
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />


 ```  

### IOS ios/Runner/Info.plist

```  
    <!-- Another Brother Section -->

        <key>NSLocalNetworkUsageDescription</key>
            <string>Looking for local tcp Bonjour service</string>
            <key>NSBonjourServices</key>
            <array>
                <string>_ipp._tcp</string>
                <string>_printer._tcp</string>
                <string>_pdl-datastream._tcp</string>
                <string>_dartobservatory._tcp</string>
            </array>
            <key>UIBackgroundModes</key>
            <array>
                <string>fetch</string>
                <string>remote-notifications</string>
            </array>
            <key>NSBluetoothAlwaysUsageDescription</key>
            <string>Need BLE permission</string>
            <key>NSBluetoothPeripheralUsageDescription</key>
            <string>Need BLE permission</string>
            <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
            <string>Need Location permission</string>
            <key>NSLocationAlwaysUsageDescription</key>
            <string>Need Location permission</string>
            <key>NSLocationWhenInUseUsageDescription</key>
            <string>Need Location permission</string>
            <key>UISupportedExternalAccessoryProtocols</key>
            <array>
                <string>com.brother.ptcbp</string>
                <string>com.issc.datapath</string>
            </array>

    <!-- End Another Brother Section --> 

```


## development env

flutter doctor -v
[✓] Flutter (Channel stable, 2.10.5, on macOS 12.3.1 21E258 darwin-x64, locale en-US)
    • Flutter version 2.10.5 at /usr/local/Caskroom/flutter/2.10.3/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision 5464c5bac7 (3 weeks ago), 2022-04-18 09:55:37 -0700
    • Engine revision 57d3bac3dd
    • Dart version 2.16.2
    • DevTools version 2.9.2

[✓] Android toolchain - develop for Android devices (Android SDK version 32.1.0-rc1)
    • Android SDK at /Users/jwyatt/Library/Android/sdk
    • Platform android-32, build-tools 32.1.0-rc1
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7590822)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 13.3.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • CocoaPods version 1.11.3

[✓] Android Studio (version 2021.1)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7590822)

[✓] Connected device (1 available)
    • Chrome (web) • chrome • web-javascript • Google Chrome 101.0.4951.54

[✓] HTTP Host Availability
    • All required HTTP hosts are available

• No issues found!



## notes
Will not run on simulators  
currently we are not branching to code and supply all changes in the main branch

## compile and run
### Android: do what you normally do.
### IOS: [watch ios 'how to compile and run' video](https://www.youtube.com/watch?v=4zQGC4YvxAM)


## history
| date | comment |
|--|--|
| 2022/05/06 | initial commit |
