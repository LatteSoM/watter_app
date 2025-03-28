// import 'package:flutter/material.dart';
// import 'package:wasser_app/data/models/water_intake.dart';
// import 'package:wasser_app/data/repositories/water_repository.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _amountController = TextEditingController();
//   final _waterRepository = WaterRepository();

//   void _addIntake() async {
//     final amount = double.tryParse(_amountController.text);
//     if (amount == null || amount <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Введите корректное количество воды')),
//       );
//       return;
//     }
//     final intake = WaterIntake(amount: amount, date: DateTime.now());
//     await _waterRepository.addWaterIntake(intake);
//     _amountController.clear();
//     setState(() {});
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Запись добавлена')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Water Tracker')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _amountController,
//                     decoration: const InputDecoration(labelText: 'Объем (мл)'),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: _addIntake,
//                   child: const Text('Добавить'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<List<WaterIntake>>(
//               future: _waterRepository.getWaterIntakes(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text('Нет записей'));
//                 }
//                 final intakes = snapshot.data!;
//                 return ListView.builder(
//                   itemCount: intakes.length,
//                   itemBuilder: (context, index) {
//                     final intake = intakes[index];
//                     return ListTile(
//                       title: Text('${intake.amount} мл'),
//                       subtitle: Text(intake.date.toString()),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasser_app/core/notifications.dart';
import 'package:wasser_app/data/repositories/water_repository.dart';
import 'package:wasser_app/presentation/bloc/watter/water_bloc.dart';
import 'package:wasser_app/presentation/screens/statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const WaterIntakeScreen(), // Экран для записи воды
    const StatisticsScreen(),  // Экран статистики
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WaterBloc(WaterRepository())..add(LoadWaterIntakesEvent()),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          final state = context.read<WaterBloc>().state;
          if (state is WaterLoaded && state.totalWater < state.dailyGoal) {
            await Notifications.scheduleNotification();
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Water Tracker'),
          ),
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.local_drink),
                label: 'Записи',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Статистика',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

// Экран для записи воды
class WaterIntakeScreen extends StatelessWidget {
  const WaterIntakeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _amountController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Объем воды (мл)'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                context.read<WaterBloc>().add(AddWaterIntakeEvent(amount));
                _amountController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Добавлено $amount мл')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Введите корректное значение')),
                );
              }
            },
            child: const Text('Добавить'),
          ),
          BlocBuilder<WaterBloc, WaterState>(
            builder: (context, state) {
              if (state is WaterLoaded) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.waterIntakes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${state.waterIntakes[index].amount} мл'),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}