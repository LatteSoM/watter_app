// import 'package:flutter/material.dart' show AppBar, BuildContext, Center, MaterialApp, Scaffold, StatelessWidget, Text, Widget, WidgetsFlutterBinding, WillPopScope, runApp;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:wasser_app/core/notifications.dart'; 
// import 'package:wasser_app/data/repositories/water_repository.dart';
// import 'package:wasser_app/presentation/bloc/watter/water_bloc.dart';
// import 'package:wasser_app/presentation/screens/auth_screen.dart';
// import 'package:wasser_app/presentation/theme/app_theme.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Notifications.init(); // Инициализация уведомлений
//   runApp(const WaterTrackerApp());
// }

// class WaterTrackerApp extends StatelessWidget {
//   const WaterTrackerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Water Tracker',
//       theme: AppTheme.theme, // Используем вашу тему
//       home: const AuthScreen(), // Начинаем с экрана авторизации
//     );
//   }
// }

// // Экран HomeScreen с BLoC
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => WaterBloc(WaterRepository())..add(LoadWaterIntakesEvent()),
//         ),
//       ],
//       child: WillPopScope(
//         onWillPop: () async {
//           final state = context.read<WaterBloc>().state;
//           if (state is WaterLoaded && state.totalWater < state.dailyGoal) {
//             await Notifications.scheduleNotification();
//           }
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(title: const Text('Water Tracker')),
//           body: const Center(child: Text('Домашний экран')),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasser_app/core/notifications.dart';
import 'package:wasser_app/presentation/screens/auth_screen.dart';
// import 'package:wasser_app/presentation/screens/home_screen.dart';
import 'package:wasser_app/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Notifications.init();
  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      theme: AppTheme.theme,
      home: const AuthScreen(),
    );
  }
}