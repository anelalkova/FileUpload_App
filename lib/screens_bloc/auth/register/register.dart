import 'package:file_upload_app_part2/bloc/login/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../landing_page/langing_page.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.isUserRegistered && state.isUserAccountActive) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
                    (Route<dynamic> route) => false,
              );
            } else if (state.isUserRegistered) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("We've sent an email to ${emailController.text} please verify your account!")),
              );
            }
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.registrationErrorMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      RegisterAndSendVerificationCode(
                        email: emailController.text,
                        password: passwordController.text,
                        name: nameController.text,
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
