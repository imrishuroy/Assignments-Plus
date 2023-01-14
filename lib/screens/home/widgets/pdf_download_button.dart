import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

import '/blocs/filtered-bloc/flitered_bloc.dart';
import '/extensions/extensions.dart';
import '/utils/utils.dart';

class PdfDownloadButton extends StatelessWidget {
  const PdfDownloadButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => download(context),
      icon: Icon(
        Icons.download,
      ),
    );
  }

  void download(BuildContext context) async {
    final todosState = context.read<FilteredTodosBloc>().state;
    if (todosState is FilteredTodosLoaded) {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) {
            return [
              for (int i = 0; i < todosState.filteredTodos.length; i++)
                pw.Padding(
                  padding: pw.EdgeInsets.all(8),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${i + 1}. ${todosState.filteredTodos[i].title}'),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        '${todosState.filteredTodos[i].dateTime.timeAgo()}',
                        style: pw.TextStyle(
                          color: PdfColors.grey,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        '${todosState.filteredTodos[i].todo}',
                        style: pw.TextStyle(color: PdfColors.blue),
                      ),
                    ],
                  ),
                ),
            ];
          },
        ),
      );

      final pdfFile = await pdf.save();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your Todos are Downloading'),
        ),
      );

      await FileDownloaderUtils.downloadFile(
          uint8listFile: pdfFile, fileName: '${Uuid().v4()}.pdf');

      // we can add a local notification to notify the user that the file is saved or downloing

    }
  }
}
