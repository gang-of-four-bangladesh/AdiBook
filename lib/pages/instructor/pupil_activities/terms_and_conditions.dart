import 'dart:io';
import 'dart:typed_data';
import 'package:adibook/core/app_data.dart';
import 'package:adibook/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:flutter_pdf_viewer/flutter_pdf_viewer.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  String path;

  Future<String>get getfilePath async {
    final filename = 'exemplo.pdf';
    var bytes = await rootBundle.load("assets/exemplo.pdf");
    String dir = (await getApplicationDocumentsDirectory()).path;
    return dir;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    //final path = await _localPath;
    final path = await getfilePath;
    return File('$path/exemplo.pdf');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost() async {
    final response = await http.get(
        'https://firebasestorage.googleapis.com/v0/b/gofbd-adibook.appspot.com/o/app_docs%2Fpupils%2Fpc_configuration.pdf?alt=media&token=3c4f8489-d3e7-42e2-914c-0d5a38721724');
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  

  loadPdf() async {
   // writeCounter(await fetchPost());
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadPdf();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            if (path != null)
              Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 3, color: AppTheme.appThemeColor)),
                height: MediaQuery.of(context).size.height / 1.32,
                width: MediaQuery.of(context).size.width,
                // child: PdfViewer(
                //   filePath: path,
                // ),
              )
          ],
        ),
      ),
    );
  }
}
