import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasser_app/presentation/bloc/watter/water_bloc.dart';
import 'package:wasser_app/presentation/widgets/water_glass.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<WaterBloc, WaterState>(
          builder: (context, state) {
            if (state is WaterLoaded) {
              final progress = state.totalWater / (state.dailyGoal > 0 ? state.dailyGoal : 1);
              return Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Дневная норма (мл)'),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      final goal = double.tryParse(value) ?? 2000;
                      context.read<WaterBloc>().add(SetDailyGoalEvent(goal));
                    },
                  ),
                  const SizedBox(height: 20),
                  WaterGlass(progress: progress.clamp(0.0, 1.0)),
                  const SizedBox(height: 20),
                  Text('Выпито: ${state.totalWater} мл из ${state.dailyGoal} мл'),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}