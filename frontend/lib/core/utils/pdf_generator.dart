import 'package:flutter/services.dart';
import 'package:frontend/data/models/response/transaction_model.dart';
import 'package:frontend/core/utils/currency_rupiah.dart';
import 'package:frontend/core/utils/date_time.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfGenerator {
  static Future<void> generateReceipt(TransactionModel transaction) async {
    final pdf = pw.Document();

    // Use a basic font
    final font = await PdfGoogleFonts.manropeMedium();
    final boldFont = await PdfGoogleFonts.manropeBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80, // Receipt format
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('SYVERDE',
                    style: pw.TextStyle(font: boldFont, fontSize: 18)),
              ),
              pw.Center(
                child: pw.Text('Kasir Digital System',
                    style: pw.TextStyle(font: font, fontSize: 10)),
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Invoice:', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text(transaction.invoiceNumber.toString(),
                      style: pw.TextStyle(font: boldFont, fontSize: 10)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date:', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text(
                    DateTimeUtils.formatDateTime(transaction.createdAt.toString()),
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Payment:', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.Text(
                    transaction.paymentMethod?.toLowerCase() == 'qris'
                        ? 'Non-Tunai'
                        : 'Cash',
                    style: pw.TextStyle(font: font, fontSize: 10),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 0.5),

              // Items Header
              pw.Row(
                children: [
                  pw.Expanded(
                      flex: 5,
                      child: pw.Text('Item',
                          style: pw.TextStyle(font: boldFont, fontSize: 10))),
                  pw.Expanded(
                      flex: 2,
                      child: pw.Text('Qty',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(font: boldFont, fontSize: 10))),
                  pw.Expanded(
                      flex: 3,
                      child: pw.Text('Total',
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: boldFont, fontSize: 10))),
                ],
              ),
              pw.SizedBox(height: 5),

              // Items List
              pw.Column(
                children: (transaction.items ?? []).map((item) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 2),
                    child: pw.Row(
                      children: [
                        pw.Expanded(
                            flex: 5,
                            child: pw.Text(item.product?.name ?? '',
                                style: pw.TextStyle(font: font, fontSize: 9))),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text(item.qty.toString(),
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(font: font, fontSize: 9))),
                        pw.Expanded(
                            flex: 3,
                            child: pw.Text(formatRupiah(item.subtotal),
                                textAlign: pw.TextAlign.right,
                                style: pw.TextStyle(font: font, fontSize: 9))),
                      ],
                    ),
                  );
                }).toList(),
              ),

              pw.Divider(thickness: 0.5),

              // Total
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TOTAL',
                      style: pw.TextStyle(font: boldFont, fontSize: 12)),
                  pw.Text(formatRupiah(transaction.total ?? 0),
                      style: pw.TextStyle(font: boldFont, fontSize: 12)),
                ],
              ),
              
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text('Terima Kasih Atas Kunjungan Anda',
                    style: pw.TextStyle(font: font, fontSize: 8, fontStyle: pw.FontStyle.italic)),
              ),
            ],
          );
        },
      ),
    );

    // Save or Print
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Struk-${transaction.invoiceNumber}.pdf',
    );
  }
}
