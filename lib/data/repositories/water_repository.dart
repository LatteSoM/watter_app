// import 'package:water_tracker/core/database_helper.dart';
// import 'package:water_tracker/data/models/water_intake.dart';
import 'package:wasser_app/core/database_helper.dart';
import 'package:wasser_app/data/models/water_intake.dart';


class WaterRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> addWaterIntake(WaterIntake intake) async {
    final db = await _dbHelper.database;
    return await db.insert('water_intakes', intake.toMap());
  }

  Future<List<WaterIntake>> getWaterIntakes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('water_intakes', orderBy: 'date DESC');
    return maps.map((map) => WaterIntake.fromMap(map)).toList();
  }
}