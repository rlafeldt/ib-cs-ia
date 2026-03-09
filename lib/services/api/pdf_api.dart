import 'dart:io';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(
      String text, String processID) async {
    // making a pdf document to store a text
    final pdf = Document();

    // Text is added here in center
    pdf.addPage(Page(
      build: (context) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    ));

    return saveDocument(name: 'Contract#$processID.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String? name,
    Document? pdf,
  }) async {
    final bytes = await pdf!.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

// here I am using a package to open the existing file made now.
  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Future openDocuemnt(Document doc) async {
    final url = doc.toString();

    await OpenFile.open(url);
  }
}
