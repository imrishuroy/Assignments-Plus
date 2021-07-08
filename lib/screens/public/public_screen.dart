import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/config/paths.dart';

class PublicScreen extends StatelessWidget {
  PublicScreen({Key? key}) : super(key: key);

  final CollectionReference public =
      FirebaseFirestore.instance.collection(Paths.public);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: public.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data;

        return ListView.builder(
            itemCount: data?.size,
            itemBuilder: (context, index) {
              final DocumentReference todoRef = data?.docs[index]['todos'];
              return FutureBuilder<DocumentSnapshot>(
                  future: todoRef.get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Something went wrong'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListTile(
                      title: Text('${snapshot.data?.data()?['title']}'),
                    );
                  });
            });

        // return ListView.builder(
        //   itemCount: data?.size,
        //   itemBuilder: (context, index) {
        //     final todosRef = data?.docs[index]['todos'];

        //     return
        //   },
        // );
      },
    );
  }
}

// Document Reference
