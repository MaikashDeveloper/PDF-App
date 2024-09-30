import 'dart:io';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfController extends GetxController {
  var pdfFiles = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPdfFiles();
  }

  Future<void> fetchPdfFiles() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
    PermissionStatus permissionStatus;

    if (androidDeviceInfo.version.sdkInt < 30) {
      permissionStatus = await Permission.storage.status;
    } else {
      permissionStatus = await Permission.manageExternalStorage.status;
    }

    if (permissionStatus.isGranted) {
      var rootDirectory = await ExternalPath.getExternalStorageDirectories();
      await getFiles(rootDirectory.first);
    } else {
      Get.snackbar('Permission Denied',
          'Storage permission is required to display PDFs');
    }
  }

  Future<void> getFiles(String directoryPath) async {
    try {
      var rootDirectory = Directory(directoryPath);
      var directories = rootDirectory.list(recursive: false);
      await for (var element in directories) {
        if (element is File) {
          if (element.path.split(".").last == "pdf") {
            if (!pdfFiles.contains(element.path)) {
              pdfFiles.add(element.path);
            }
          }
        } else {
          await getFiles(element.path);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      var file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        pdfFiles.remove(filePath);
        Get.snackbar('Success', 'File deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', 'File not found',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete file: $e',
          snackPosition: SnackPosition.BOTTOM);
      print("Error deleting file: $e");
    }
  }

  Future<void> refreshFiles() async {
    pdfFiles.clear();
    await fetchPdfFiles();
  }
}
