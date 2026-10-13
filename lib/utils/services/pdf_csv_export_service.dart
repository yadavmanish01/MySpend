import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class PdfCsvExportService {
  /// Helper to get public Download directory or fallback directory
  static Future<Directory> _getExportDirectory() async {
    if (Platform.isAndroid) {
      final downloadDir = Directory('/storage/emulated/0/Download');
      if (await downloadDir.exists()) {
        return downloadDir;
      }
    }
    return await getApplicationDocumentsDirectory();
  }

  /// Opens and/or shares the exported file
  static Future<void> openAndShareFile(File file, String title) async {
    await OpenFilex.open(file.path);
    await Share.shareXFiles([XFile(file.path)], text: title);
  }

  /// Generate & Save Real PDF Statement
  static Future<File> generatePdfReport({
    required String userName,
    required String userEmail,
    required List<QueryDocumentSnapshot> transactions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('MySpend - Expense Report',
                      style: pw.TextStyle(
                          fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateTime.now().toString().split(' ')[0]),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('User: $userName ($userEmail)'),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Title', 'Category', 'Type', 'Amount (₹)'],
              data: transactions.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = data['title'] ?? 'N me';
                final category = data['category'] ?? 'General';
                final isExpense = data['isExpense'] as bool? ?? true;
                final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
                return [
                  title,
                  category,
                  isExpense ? 'Expense' : 'Income',
                  '₹${amount.toStringAsFixed(2)}'
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    final dir = await _getExportDirectory();
    final file = File("${dir.path}/MySpend_Report_${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate & Save Real CSV Statement
  static Future<File> generateCsvReport({
    required List<QueryDocumentSnapshot> transactions,
  }) async {
    List<List<dynamic>> rows = [
      ["Title", "Category", "Type", "Amount"]
    ];

    for (var doc in transactions) {
      final data = doc.data() as Map<String, dynamic>;
      final title = data['title'] ?? 'N/A';
      final category = data['category'] ?? 'General';
      final isExpense = data['isExpense'] as bool? ?? true;
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;

      rows.add([title, category, isExpense ? 'Expense' : 'Income', amount]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final dir = await _getExportDirectory();
    final file = File("${dir.path}/MySpend_Export_${DateTime.now().millisecondsSinceEpoch}.csv");
    await file.writeAsString(csvData);
    return file;
  }
}
