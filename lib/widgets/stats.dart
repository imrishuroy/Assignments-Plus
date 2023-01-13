import 'package:assignments/models/todo_model.dart';
import 'package:assignments/repositories/todo/todo_repository.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _PieData {
  // ignore: unused_element
  _PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String? text;
}

class WeeklyData {
  WeeklyData(this.year, this.sales);

  final String year;
  final double sales;
}

class Stats extends StatelessWidget {
  final String userId;

  const Stats({Key? key, required this.userId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _todos = context.read<TodosRepository>();
    int completed = 0;
    List<WeeklyData> weeklyData = [];
    return StreamBuilder<List<Todo>>(
      stream: _todos.todos(userId),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return LoadingIndicator();
        }

        List<Todo>? todos = snapshots.data;

        todos?.forEach((element) {
          if (element.completed) {
            completed++;
          }
          final dateTime = element.dateTime;
          final String day = DateFormat('EEEE').format(dateTime);
          print(day);
          weeklyData.add(WeeklyData(day, completed.toDouble()));
        });

        List<_PieData> pieData = [
          _PieData('Completed', completed),
          _PieData('Total Todos', todos!.length),
        ];

        // List<WeeklyData> weeklyData = [
        //   WeeklyData('Jan', 35),
        //   WeeklyData('Feb', 28),
        //   WeeklyData('Mar', 34),
        //   WeeklyData('Apr', 32),
        //   WeeklyData('May', 40)
        // ];

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5.0),
            Center(
              child: SfCircularChart(
                // title: ChartTitle(text: 'Your Todos Data'),
                legend: Legend(isVisible: true),
                series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                    explode: true,
                    explodeIndex: 0,
                    dataSource: pieData,
                    xValueMapper: (_PieData data, _) => data.xData,
                    yValueMapper: (_PieData data, _) => data.yData,
                    dataLabelMapper: (_PieData data, _) => data.text,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: 100),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   //Initialize the spark charts widget
            //   child: SfSparkLineChart.custom(
            //     //Enable the trackball
            //     trackball: SparkChartTrackball(
            //         activationMode: SparkChartActivationMode.tap),
            //     //Enable marker
            //     marker: SparkChartMarker(
            //         displayMode: SparkChartMarkerDisplayMode.all),
            //     //Enable data label
            //     labelDisplayMode: SparkChartLabelDisplayMode.all,
            //     xValueMapper: (int index) => weeklyData[index].year,
            //     yValueMapper: (int index) => weeklyData[index].sales,

            //     dataCount: weeklyData.length,
            //   ),
            // )
          ],
        );
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
//         if (state is StatsInitial) {
//           return Center(
//             child: Text('No Todos Updated'),
//           );
//         } else if (state is StatsLoading) {
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
