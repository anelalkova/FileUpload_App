import 'package:flutter/material.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import '../network/api_service.dart';

class EditAccountScreen extends StatefulWidget {
  final DataService dataService;
  final UserResponse userResponse;

  const EditAccountScreen({
    required this.dataService,
    required this.userResponse,
    super.key,
  });

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userResponse.name);
    _emailController = TextEditingController(text: widget.userResponse.email);
    _passwordController = TextEditingController(text: widget.userResponse.password);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updateUser = UpdateUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        active: widget.userResponse.active,
        activation_Code: widget.userResponse.activation_Code,
      );

      try {
        await widget.dataService.updateUser(widget.userResponse.id, updateUser);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User updated successfully')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>
            EditAccountScreen(
                dataService: widget.dataService,
                userResponse: widget.userResponse
            )
        )
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update user: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color.fromRGBO(88, 73, 111, 1), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
       // automaticallyImplyLeading: false,
        /*actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],*/
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 60),
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset("assets/TempProfileImage1.png"),
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: !_passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(88, 73, 111, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Color.fromRGBO(242, 235, 251, 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
