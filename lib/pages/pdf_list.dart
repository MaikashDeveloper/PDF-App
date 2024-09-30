import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:pdf_test/backend/pdf_control.dart';
import 'package:pdf_test/pages/pf_view.dart';

class PdfListScreen extends StatelessWidget {
  const PdfListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PdfController pdfController = Get.put(PdfController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PDF Reader',
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: pdfController.refreshFiles,
          child: ListView.builder(
            itemCount: pdfController.pdfFiles.length,
            itemBuilder: (context, index) {
              String filePath = pdfController.pdfFiles[index];
              String fileName = path.basename(filePath);
              return Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red[600],
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFViewerScreen(
                          pdfPath: filePath,
                          pdfName: fileName,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    fileName,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onPressed: () async {
                      await pdfController.deleteFile(filePath);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
