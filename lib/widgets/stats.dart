import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/stats/stats_bloc.dart';

class Stats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        if (state is StatsInitial) {
          return Center(
            child: Text('No Todos Updated'),
          );
        } else if (state is StatsLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is StatsLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Completed Todos',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '${state.numCompleted}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Active Todos',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "${state.numActive}",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_todo/blocs/stats/stats_bloc.dart';

// class Stats extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<StatsBloc, StatsState>(
//       builder: (context, state) {
//         if (state is StatsLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is StatsLoaded) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     'Completed Todos',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 24.0),
//                   child: Text(
//                     '${state.numCompleted}',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     'Active Todos',
//                     style: Theme.of(context).textTheme.headline6,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 24.0),
//                   child: Text(
//                     "${state.numActive}",
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                 )
//               ],
//             ),
//           );
//         }
//         return Container();
//       },
//     );
//   }
// }
