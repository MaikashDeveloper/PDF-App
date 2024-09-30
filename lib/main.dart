import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_test/pages/permission-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDF Reader',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const PermissionRequestScreen(),
    );
  }
}
