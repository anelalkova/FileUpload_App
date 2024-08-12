import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../bloc/login/auth_bloc.dart';
import '../../../network/data_service.dart';
import '../../landing_page/langing_page.dart';
import '../forgot_password/forgot_password.dart';
import '../register/register.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        context.read<AuthBloc>().add(AutoLogin());
        context.read<AuthBloc>().add(RequestPermissions());
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _LoginForm(),
                    const SizedBox(height: 16),
                    _ForgotPasswordButton(),
                    const SizedBox(height: 16),
                    _SignUpPrompt(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AutoLoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  LandingPage()),
                (Route<dynamic> route) => false,
          );
        }
      },
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<_LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an email address.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _authUser(context);
              }
            },
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }

  Future<void> _authUser(BuildContext context) async {
    final loginBloc = BlocProvider.of<AuthBloc>(context);
    final completer = Completer<String?>();

    loginBloc.add(LoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text,
    ));

    final subscription = loginBloc.stream.listen((state) {
      if (state is AuthSuccess) {
        completer.complete(null);
      } else if (state is AuthFailure) {
        completer.complete('Incorrect email or password. Please try again.');
      }
    });

    final result = await completer.future;
    subscription.cancel();

    if (result == null) {
      final FlutterSecureStorage storage = FlutterSecureStorage();
      var result = await DataService().getUserByEmailFromAPI(_emailController.text);
      int user_id = result.result!.id;
      storage.write(key: 'user_id', value: user_id.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPasswordScreen(),
          ),
        );
      },
      child: const Text('Forgot your password?'),
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}



