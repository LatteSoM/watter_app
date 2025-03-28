// import 'package:wasser_app/core/database_helper.dart';
// import 'package:wasser_app/data/models/water_intake.dart';
// import 'package:shared_preferences/shared_preferences.dart';


// class WaterRepository {
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;

//   Future<int> addWaterIntake(WaterIntake intake) async {
//     final db = await _dbHelper.database;
//     return await db.insert('water_intakes', intake.toMap());
//   }

//   Future<List<WaterIntake>> getWaterIntakes() async {
//     final db = await _dbHelper.database;
//     final maps = await db.query('water_intakes', orderBy: 'date DESC');
//     return maps.map((map) => WaterIntake.fromMap(map)).toList();
//   }

//   Future<void> setDailyGoal(double goal) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setDouble('daily_goal', goal);
//   }

//   Future<double> getDailyGoal() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getDouble('daily_goal') ?? 2000;
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasser_app/data/models/water_intake.dart';

class WaterRepository {
  Future<List<WaterIntake>> getWaterIntakes() async {
    final prefs = await SharedPreferences.getInstance();
    final intakes = prefs.getStringList('water_intakes') ?? [];
    return intakes.map((e) => WaterIntake(amount: double.parse(e))).toList();
  }

  Future<void> addWaterIntake(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final intakes = prefs.getStringList('water_intakes') ?? [];
    intakes.add(amount.toString());
    await prefs.setStringList('water_intakes', intakes);
  }

  Future<void> setDailyGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('daily_goal', goal);
  }

  Future<double> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('daily_goal') ?? 2000;
  }
}