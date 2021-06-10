import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/leadboard.dart';
import 'package:flutter_todo/repositories/services/firebase_service.dart';

class LeadBoardWidget extends StatelessWidget {
  const LeadBoardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _service =
        RepositoryProvider.of<FirebaseServices>(context, listen: false);

    return FutureBuilder<List<LeadBoard>>(
      future: _service.leadBoardUsers(),
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
        return Flexible(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              print(snapshot.data);

              final data = snapshot.data?[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(data!.imageUrl),
                  ),
                  title: Text('${data.name}'),
                  trailing: CircleAvatar(
                    radius: 15.0,
                    child: Text('${data.position}'),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
