part of 'water_bloc.dart';

abstract class WaterState {}

class WaterInitial extends WaterState {}

class WaterLoading extends WaterState {}

class WaterLoaded extends WaterState {
  final List<WaterIntake> waterIntakes;
  final double totalWater;
  final double dailyGoal;

  WaterLoaded(this.waterIntakes, this.totalWater, this.dailyGoal);
}

class WaterError extends WaterState {
  final String message;
  WaterError(this.message);
}