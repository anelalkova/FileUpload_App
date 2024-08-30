import 'package:file_upload_app_part2/bloc/login/auth_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/auth/verify_account/verify_account.dart';
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
            }
          },
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 70),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text('Cancel')
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AuthBloc>(context).add(SetEmail(email: emailController.text));
                            BlocProvider.of<AuthBloc>(context).add(
                              RegisterAndSendVerificationCode(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => VerifyAccountScreen()),
                            );
                          },
                          child: const Text('Sign up'),
                        ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
