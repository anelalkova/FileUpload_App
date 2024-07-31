// register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login/auth_bloc.dart';
import '../bloc/login/auth_event.dart';
import '../bloc/login/auth_state.dart';
import '../network/data_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailControllerRegister = TextEditingController();
  final passwordControllerRegister = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(dataService: DataService()),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushNamed(context, '/login');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: Form(
            key: registerKey,
            child: Column(
              children: [
                const Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 60.0,
                ),
                TextFormField(
                  controller: emailControllerRegister,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email, color: Colors.pink),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.abc, color: Colors.pink),
                    hintText: 'Enter your name',
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: passwordControllerRegister,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock, color: Colors.pink),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: _isObscure
                          ? const Icon(Icons.visibility_off, color: Colors.grey)
                          : const Icon(Icons.visibility, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  obscureText: _isObscure,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: repeatPasswordController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock, color: Colors.pink),
                    hintText: 'Repeat your password',
                    labelText: 'Repeat password',
                    suffixIcon: IconButton(
                      icon: _isObscure
                          ? const Icon(Icons.visibility_off, color: Colors.grey)
                          : const Icon(Icons.visibility, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please repeat your password';
                    } else if (passwordControllerRegister.text != value) {
                      return 'Passwords must match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (registerKey.currentState != null && registerKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(RegisterEvent(
                        email: emailControllerRegister.text,
                        name: nameController.text,
                        password: passwordControllerRegister.text,
                      ));
                    }
                  },
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    if (registerKey.currentState != null && registerKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(ResendVerificationLinkEvent(
                        email: emailControllerRegister.text,
                      ));
                    }
                  },
                  child: const Text('Resend verification link'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
