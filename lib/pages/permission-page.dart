import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pdf_test/pages/pdf_list.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  _PermissionRequestScreenState createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  Future<bool> requestPermission() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    PermissionStatus permissionStatus;

    if (androidDeviceInfo.version.sdkInt < 30) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.manageExternalStorage.request();
    }

    return permissionStatus.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: requestPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return const PdfListScreen();
        } else {
          return Scaffold(
            body: Container(
              color: Colors.red[800],
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 90),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 47,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset('images/permission.png'),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Permission Required",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 37,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Padding(
                    padding: EdgeInsets.all(17.5),
                    child: Text(
                      'This app needs your phone storage permission to access your "PDF" files to list them.\nClick "Continue" to allow permission.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () async {
                      bool granted = await requestPermission();
                      if (granted) {
                        Get.off(() => const PdfListScreen());
                      } else {
                        Get.snackbar('Permission Denied',
                            'Storage permission is required to display PDFs');
                      }
                    },
                    child: Container(
                      height: 60,
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Center(
                        child: Text(
                          'Countanie',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
