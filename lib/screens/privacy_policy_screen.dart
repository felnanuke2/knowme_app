import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late PdfController _pdfController;

  int counter = 0;

  var pageCountStreamController = StreamController<int>.broadcast();

  @override
  void dispose() {
    pageCountStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Política de Privacidade',
        ),
        actions: [
          StreamBuilder<int>(
              stream: pageCountStreamController.stream,
              builder: (context, snapshotCount) {
                return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      '${snapshotCount.data ?? 1}/$counter',
                      style: Get.textTheme.headline6?.copyWith(color: Colors.white),
                    ));
              })
        ],
      ),
      body: FutureBuilder<ByteData>(
          future: rootBundle.load('assets/politica de privacidade.pdf'),
          builder: (context, snapshotPdfDocument) {
            if (snapshotPdfDocument.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            _pdfController = PdfController(
                document: PdfDocument.openData(snapshotPdfDocument.data!.buffer.asUint8List()));
            return PdfView(
                onPageChanged: (page) => pageCountStreamController.add(page),
                onDocumentLoaded: (document) {
                  counter = _pdfController.pagesCount;
                  pageCountStreamController.add(_pdfController.initialPage);
                },
                controller: _pdfController);
          }),
    );
  }
}
