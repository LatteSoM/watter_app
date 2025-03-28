// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wasser_app/data/models/water_intake.dart';
// import 'package:wasser_app/data/repositories/water_repository.dart';

// part 'water_event.dart';
// part 'water_state.dart';

// class WaterBloc extends Bloc<WaterEvent, WaterState> {
//   final WaterRepository _waterRepository;

//   WaterBloc(this._waterRepository) : super(WaterInitial()) {
//     on<LoadWaterIntakesEvent>((event, emit) async {
//       emit(WaterLoading());
//       try {
//         final intakes = await _waterRepository.getWaterIntakes();
//         final total = intakes.fold<double>(0, (sum, intake) => sum + intake.amount);
//         final goal = await _waterRepository.getDailyGoal();
//         emit(WaterLoaded(intakes, total, goal));
//       } catch (e) {
//         emit(WaterError(e.toString()));
//       }
//     });

//     on<SetDailyGoalEvent>((event, emit) async {
//       await _waterRepository.setDailyGoal(event.goal);
//       add(LoadWaterIntakesEvent());
//     });
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasser_app/data/models/water_intake.dart';
import 'package:wasser_app/data/repositories/water_repository.dart';

part 'water_event.dart';
part 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final WaterRepository _waterRepository;

  WaterBloc(this._waterRepository) : super(WaterInitial()) {
    on<LoadWaterIntakesEvent>((event, emit) async {
      emit(WaterLoading());
      try {
        final intakes = await _waterRepository.getWaterIntakes();
        final total = intakes.fold<double>(0, (sum, intake) => sum + intake.amount);
        final goal = await _waterRepository.getDailyGoal();
        emit(WaterLoaded(intakes, total, goal));
      } catch (e) {
        emit(WaterError(e.toString()));
      }
    });

    on<SetDailyGoalEvent>((event, emit) async {
      await _waterRepository.setDailyGoal(event.goal);
      add(LoadWaterIntakesEvent());
    });

    on<AddWaterIntakeEvent>((event, emit) async {
      await _waterRepository.addWaterIntake(event.amount);
      add(LoadWaterIntakesEvent());
    });
  }
}