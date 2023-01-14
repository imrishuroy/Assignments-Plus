import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '/blocs/filtered-bloc/flitered_bloc.dart';
import '/extensions/extensions.dart';

class PdfDownloader extends StatelessWidget {
  const PdfDownloader({super.key});

  Future<void> saveFile({
    required Uint8List uint8listFile,
    required String fileName,
  }) async {
    var file = File('');

    try {
      // Platform.isIOS comes from dart:io
      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        file = File('${dir.path}/$fileName');
      } else if (Platform.isAndroid) {
        var status = await Permission.storage.status;

        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }
        if (status.isGranted) {
          const downloadsFolderPath = '/storage/emulated/0/Download/';
          Directory dir = Directory(downloadsFolderPath);
          file = File('${dir.path}$fileName');

          // if (await file.exists()) {
          //   file = File('${dir.path}/${fileName}');
          // }

          // load file that you want to save on user's phone
          // it can be loaded from whenever you want, e.g. some API.
          //final byteData = await rootBundle.load(key)

          ByteData byteData = ByteData.view(uint8listFile.buffer);

          await file.writeAsBytes(byteData.buffer
              .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

          print('File path 11: ${file.path}');
        }
      }
    } on FileSystemException catch (error) {
      print('Error in saving file: ${error.toString()}');
    } catch (error) {
      print('Error in saving file: ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            final pdf = pw.Document();

            pdf.addPage(
              pw.MultiPage(
                build: (context) {
                  return [
                    for (int i = 0; i < 53; i++)
                      pw.Padding(
                        padding: pw.EdgeInsets.all(10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('${i + 1}. Hello World '),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              'https://stackoverflow.com/questions/50124355/flutter-navigator-not-working',
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

            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => ViewPdf(
            //       pdfPath: File.fromRawPath(pdfFile).path,
            //     ),
            //   ),
            // );

            await saveFile(uint8listFile: pdfFile, fileName: 'test11.pdf');
          } catch (error) {
            print('Error in getting pdf: ${error.toString()}');
          }
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Download Your All Todos'),
          onPressed: () async {
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
                              pw.Text(
                                  '${i + 1}. ${todosState.filteredTodos[i].title}'),
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

              await saveFile(
                  uint8listFile: pdfFile, fileName: 'assignmet-todos.pdf');

              // TODO: add a local notification to notify the user that the file is saved or downloing
            }
          },
        ),
      ),
    );
  }
}

class ViewPdf extends StatelessWidget {
  final String pdfPath;

  const ViewPdf({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PDFView(
        filePath: pdfPath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onRender: (_pages) {},
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {},
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
