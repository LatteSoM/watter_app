import 'package:flutter/material.dart';
import 'package:wasser_app/data/models/water_intake.dart';
import 'package:wasser_app/data/repositories/water_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _amountController = TextEditingController();
  final _waterRepository = WaterRepository();

  void _addIntake() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректное количество воды')),
      );
      return;
    }
    final intake = WaterIntake(amount: amount, date: DateTime.now());
    await _waterRepository.addWaterIntake(intake);
    _amountController.clear();
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Запись добавлена')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Объем (мл)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addIntake,
                  child: const Text('Добавить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<WaterIntake>>(
              future: _waterRepository.getWaterIntakes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Нет записей'));
                }
                final intakes = snapshot.data!;
                return ListView.builder(
                  itemCount: intakes.length,
                  itemBuilder: (context, index) {
                    final intake = intakes[index];
                    return ListTile(
                      title: Text('${intake.amount} мл'),
                      subtitle: Text(intake.date.toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}