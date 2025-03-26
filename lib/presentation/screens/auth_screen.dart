import 'package:flutter/material.dart';
import 'package:wasser_app/data/repositories/auth_repository.dart';
import 'package:wasser_app/presentation/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();
  bool _isLogin = true;

  void _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    bool success = _isLogin
        ? await _authRepository.signIn(email, password)
        : await _authRepository.signUp(email, password);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка авторизации')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Water Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
            ),
            TextButton(
              onPressed: () => setState(() => _isLogin = !_isLogin),
              child: Text(_isLogin
                  ? 'Создать аккаунт'
                  : 'Уже есть аккаунт? Войти'),
            ),
          ],
        ),
      ),
    );
  }
}