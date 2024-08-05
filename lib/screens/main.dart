import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../network/api_service.dart';
import '../network/data_service.dart';
import 'documentPage.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final loginKey = GlobalKey<FormState>();
  final registerKey = GlobalKey<FormState>();
  final emailControllerLogin = TextEditingController();
  final emailControllerRegister = TextEditingController();
  final passwordControllerLogin = TextEditingController();
  final passwordControllerRegister = TextEditingController();
  final nameController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final DataService dataService = DataService();
  bool _isObscure = true;
  final FocusNode emailLoginFocusNode = FocusNode();
  final FocusNode emailRegisterFocusNode = FocusNode();
  final FocusNode passwordLoginFocusNode = FocusNode();
  final FocusNode passwordRegisterFocusNode = FocusNode();
  final FocusNode repeatPasswordFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    emailControllerLogin.dispose();
    emailControllerRegister.dispose();
    passwordControllerLogin.dispose();
    passwordControllerRegister.dispose();
    nameController.dispose();
    repeatPasswordController.dispose();
    emailLoginFocusNode.dispose();
    emailRegisterFocusNode.dispose();
    passwordLoginFocusNode.dispose();
    passwordRegisterFocusNode.dispose();
    repeatPasswordFocusNode.dispose();
    nameFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 10.0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Register'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildLoginForm(),
          buildRegisterForm(),
        ],
      ),
    );
  }

  Widget buildLoginForm() {
    return Form(
      key: loginKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.person,
              color: Colors.pink,
              size: 80.0,
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: emailControllerLogin,
              focusNode: emailLoginFocusNode,
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
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordLoginFocusNode);
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: _isObscure,
              enableSuggestions: false,
              autocorrect: false,
              controller: passwordControllerLogin,
              focusNode: passwordLoginFocusNode,
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
                  return 'Please enter your password';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (loginKey.currentState != null && loginKey.currentState!.validate()) {
                  var email = emailControllerLogin.text;
                  var password = passwordControllerLogin.text;
                  var userLogin = UserLogin(email: email, password: password);

                  var response = await dataService.userLogin(userLogin);
                  if (response.success) {
                    int? userId = response.result;
                    if (userId != null) {
                      var userResponse = await dataService.getUserByEmailFromAPI(email);
                      if (userResponse.success && userResponse.result != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DocumentPage(
                              user: userResponse.result!,
                              dataService: dataService,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to fetch user details')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid user ID')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Incorrect password')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email not found')),
                  );
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    return Form(
      key: registerKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.person,
              color: Colors.blue,
              size: 60.0,
            ),
            TextFormField(
              controller: emailControllerRegister,
              focusNode: emailRegisterFocusNode,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.pink,
                  size: 20.0,
                ),
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
              focusNode: nameFocusNode,
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.abc,
                  color: Colors.pink,
                  size: 20.0,
                ),
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
              focusNode: passwordRegisterFocusNode,
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
              focusNode: repeatPasswordFocusNode,
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
                  return 'Password must match';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (registerKey.currentState != null && registerKey.currentState!.validate()) {
                  var registerUserRequest = RegisterUserRequest(
                    email: emailControllerRegister.text,
                    name: nameController.text,
                    password: passwordControllerRegister.text,
                  );

                  try {
                    final result = await dataService.registerUser(registerUserRequest);

                    if (result.success) {
                      showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    const Text('An email with a verification code has been sent to your email address. Please verify your account!'),
                                    const SizedBox(height: 20.0),
                                    const Text('Didn\'t get a verification link?'),
                                    TextButton(
                                      onPressed: () async {
                                        var result = await dataService.resendVerificationLink(emailControllerRegister.text);
                                        if (result.success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Verification link resent!')),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Failed to resend verification link.')),
                                          );
                                        }
                                      },
                                      child: const Text('Click to resend.'),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to create user: ${result.error}'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create user: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}