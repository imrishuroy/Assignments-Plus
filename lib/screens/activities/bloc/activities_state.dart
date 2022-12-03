part of 'activities_bloc.dart';

enum ActivityStatus { initial, loading, succuss, error }

class ActivitiesState extends Equatable {
  final List<Activity?> activities;
  final ActivityStatus status;
  final Failure failure;

  const ActivitiesState({
    required this.activities,
    required this.status,
    required this.failure,
  });

  factory ActivitiesState.initial() {
    return ActivitiesState(
      activities: [],
      status: ActivityStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [activities, status, failure];

  ActivitiesState copyWith({
    List<Activity?>? activities,
    ActivityStatus? status,
    Failure? failure,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool get stringify => true;
}
