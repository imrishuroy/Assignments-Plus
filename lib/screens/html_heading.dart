import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart' as dom;
import 'package:metadata_fetch/metadata_fetch.dart';

// import 'package:html/dom.dart';

// import 'package:html/parser.dart';

class HtmlHeading extends StatefulWidget {
  const HtmlHeading({Key? key}) : super(key: key);

  @override
  _HtmlHeadingState createState() => _HtmlHeadingState();
}

class _HtmlHeadingState extends State<HtmlHeading> {
  @override
  void initState() {
    super.initState();
    // _getWebsite();
  }

  _getWebsite() async {
    final response = await http.get(Uri.parse(
        'https://www.freecodecamp.org/news/how-to-create-a-great-technical-course/'));
    // print(response.statusCode);
    // print(response.body);
    // print(response.body.runtimeType);
    // print(response.body.contains('h1'));

    //var document = parse(response.body);

    var data = await MetadataFetch.extract(
        'https://www.freecodecamp.org/news/how-to-create-a-great-technical-course/');
    print(data?.title);

    // print('I am header 1 ${document.body?.getElementsByTagName('title')}');
  }

  // _getH1() async {}

  // _getTitle() {
  //   var document = parse(Uri.parse(
  //           'https://www.freecodecamp.org/news/how-to-create-a-great-technical-course/')
  //       .toString());

  //   print(document);

  //   print('I am header 1 ${document.body?.getElementsByTagName('title')}');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _getTitle();
          _getWebsite();
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Text(''),
      ),
    );
  }
}
