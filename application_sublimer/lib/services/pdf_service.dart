import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFService {
  static Future<void> generateReport(String reportType) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Rapport $reportType',
            style: pw.TextStyle(fontSize: 24),
          ),
        ),
      ),
    );

    // Save or print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}