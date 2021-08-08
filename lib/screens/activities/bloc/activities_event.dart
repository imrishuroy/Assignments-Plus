part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class LoadActivities extends ActivitiesEvent {
  final List<Activity?> activities;

  LoadActivities({required this.activities});
  @override
  List<Object> get props => [activities];
}
