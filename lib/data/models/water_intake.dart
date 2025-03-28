// class WaterIntake {
//   final int? id;
//   final double amount;
//   final DateTime date;

//   WaterIntake({this.id, required this.amount, required this.date});

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'amount': amount, 'date': date.toIso8601String()};
//   }

//   factory WaterIntake.fromMap(Map<String, dynamic> map) {
//     return WaterIntake(
//       id: map['id'],
//       amount: map['amount'],
//       date: DateTime.parse(map['date']),
//     );
//   }
// }

class WaterIntake {
  final double amount;

  WaterIntake({required this.amount});
}