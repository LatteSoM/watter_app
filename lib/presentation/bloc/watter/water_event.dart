// part of 'water_bloc.dart';

// abstract class WaterEvent {}

// class LoadWaterIntakesEvent extends WaterEvent {}

// class SetDailyGoalEvent extends WaterEvent {
//   final double goal;
//   SetDailyGoalEvent(this.goal);
// }

part of 'water_bloc.dart';

abstract class WaterEvent {}

class LoadWaterIntakesEvent extends WaterEvent {}

class SetDailyGoalEvent extends WaterEvent {
  final double goal;
  SetDailyGoalEvent(this.goal);
}

class AddWaterIntakeEvent extends WaterEvent {
  final double amount;
  AddWaterIntakeEvent(this.amount);
}