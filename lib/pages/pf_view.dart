import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;
  final String pdfName;

  const PDFViewerScreen(
      {super.key, required this.pdfPath, required this.pdfName});

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  int totalPages = 0;
  int currentPage = 0;
  // late RxBool verticalSwip = false.obs;
  // bool _vertical() {
  //   bool swip = verticalSwip as bool;
  //   setState(() {
  //     swip = !swip;
  //   });
  //   return swip;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pdfName)),
      body: PDFView(
        // swipeHorizontal: _vertical(),
        filePath: widget.pdfPath,
        onRender: (pages) {
          setState(() {
            totalPages = pages!;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            currentPage = page!;
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _vertical();
      //     });
      //     print(verticalSwip);
      //   },
      //   child: _vertical()
      //        Icon(
      //           Icons.swap_vert_circle_outlined,
      //         )
      //       : Icon(
      //           Icons.swap_vert_circle,
      //         ),
      // ),
    );
  }
}
