import 'package:file_upload_app_part2/bloc/document/document_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../bloc/login/auth_bloc.dart';
import '../../landing_page/langing_page.dart';
import '../forgot_password/forgot_password.dart';
import '../register/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AutoLogin());
    context.read<AuthBloc>().add(RequestPermissions());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
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
      listener: (context, state) async {
        if (state.isAutoLoginSuccess || state.loginIsValid) {
          FlutterSecureStorage storage = const FlutterSecureStorage();
          String? idString = await storage.read(key: 'user_id');

          if (idString != null) {
            int id = int.parse(idString);
            BlocProvider.of<DocumentBloc>(context).add(GetDocuments(user_id: id));
            BlocProvider.of<DocumentBloc>(context).add(GetDocumentType());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
                  (Route<dynamic> route) => false,
            );
          }
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  errorText: state.loginErrorMessage?.contains('email') == true
                      ? state.loginErrorMessage
                      : null,
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
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  errorText: state.loginErrorMessage?.contains('password') == true
                      ? state.loginErrorMessage
                      : null,
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
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<AuthBloc>(context).add(LoginButtonPressed(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }
                },
                child: const Text('Log in'),
              ),
              if (state.loginErrorMessage != null &&
                  !state.loginErrorMessage!.contains('email') &&
                  !state.loginErrorMessage!.contains('password'))
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    state.loginErrorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
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
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterScreen(),
              ),
            );
          },
          child: const Text('Sign up'),
        ),
      ],
    );
  }
}
