// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_todo/repositories/todo/todo_repository.dart';

// class SearchBar extends StatelessWidget {
//   const SearchBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final todoRepo = context.read<TodosRepository>();
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 18.0,
//         vertical: 14.0,
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           hintText: 'Search your todos',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           suffixIcon: InkWell(
//             onTap: () {
//               final todos = todoRepo.searchTodos();
//               print('-------------- Todos $todos');
//               todos.forEach((element) {
//                 print(element.first.title);
//               });
//             },
//             child: Icon(
//               Icons.search,
//               color: Colors.green,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
