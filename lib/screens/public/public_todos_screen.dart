import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/public_todos.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/public-todos/public_todos_repository.dart';
import 'package:uuid/uuid.dart';

class PublicTodosScreen extends StatelessWidget {
  const PublicTodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _publicTodos = context.read<PublicTodosRepository>();
    final _authRepo = context.read<AuthRepository>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _publicTodos.deleteTodo(
            PublicTodo(
              title: 'Hey Neha !',
              todo: 'I love you',
              authorId: _authRepo.userId,
              todoId: 'c46e835c-cea7-48a3-b0ef-caa8ead8e092',
            ),
          );
          // _publicTodos.addPublicTodo(
          //   PublicTodo(
          //     title: 'Hey Neha !',
          //     todo: 'I love you',
          //     authorId: _authRepo.userId,
          //     todoId: Uuid().v4(),
          //   ),
          // );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}











// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_todo/config/paths.dart';

// class PublicScreen extends StatelessWidget {
//   PublicScreen({Key? key}) : super(key: key);

//   final CollectionReference public =
//       FirebaseFirestore.instance.collection(Paths.public);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: public.snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text('Something went wrong'),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         final data = snapshot.data;

//         return ListView.builder(
//             itemCount: data?.size,
//             itemBuilder: (context, index) {
//               final DocumentReference todoRef = data?.docs[index]['todos'];
//               return FutureBuilder<DocumentSnapshot>(
//                   future: todoRef.get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasError) {
//                       return Center(
//                         child: Text('Something went wrong'),
//                       );
//                     }
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     return ListTile(
//                       title: Text('${snapshot.data?.data()?['title']}'),
//                     );
//                   });
//             });

//         // return ListView.builder(
//         //   itemCount: data?.size,
//         //   itemBuilder: (context, index) {
//         //     final todosRef = data?.docs[index]['todos'];

//         //     return
//         //   },
//         // );
//       },
//     );
//   }
// }

// // Document Reference
