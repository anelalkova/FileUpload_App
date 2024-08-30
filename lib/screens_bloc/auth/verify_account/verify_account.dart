import 'package:file_upload_app_part2/screens_bloc/auth/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_upload_app_part2/bloc/login/auth_bloc.dart';

class VerifyAccountScreen extends StatelessWidget {
  VerifyAccountScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final List<TextEditingController> digitControllers = List.generate(
      6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            builder: (context, state) {
              return Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/hello_icon.png', width: 60, height: 60, color: const Color.fromRGBO(88, 73, 111, 1)),
                      const SizedBox(height: 10),
                      const Text('Enter verification code', style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromRGBO(88, 73, 111, 1))),
                      const SizedBox(height: 10),
                      Text(
                        'We\'ve sent a verification code to ${state.email}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color.fromRGBO(88, 73, 111, 0.8)),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            height: 60,
                            width: 40,
                            child: TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: digitControllers[index],
                              focusNode: focusNodes[index],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              onChanged: (value) {
                                if (value.length == 1 && index < 5) {
                                  FocusScope.of(context).requestFocus(
                                      focusNodes[index + 1]);
                                } else if (value.isEmpty && index > 0) {
                                  FocusScope.of(context).requestFocus(
                                      focusNodes[index - 1]);
                                }
                              },
                              onSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Didn\'t recieve a code? ', style: TextStyle(color: Color.fromRGBO(88, 73, 111, 0.8))),
                          Text('Click to resend', style: TextStyle(color: Color.fromRGBO(88, 73, 111, 1), fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel', style: TextStyle(
                                      color: Color.fromRGBO(88, 73, 111, 1)))
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: ElevatedButton(
                                onPressed: () {
                                  String code = digitControllers.map((c) =>
                                  c.text).join();
                                  print("Verification code: $code");
                                  BlocProvider.of<AuthBloc>(context).add(VerifyAccount(code: code));
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    const Color.fromRGBO(88, 73, 111, 0.7),
                                  ),
                                ),
                                child: const Text('Submit', style: TextStyle(color: Colors.white)),
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            listener: (context, state) {
              if (state.accountVerificationSuccess) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
