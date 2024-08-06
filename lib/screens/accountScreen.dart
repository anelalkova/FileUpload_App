import 'package:file_upload_app_part2/screens/editAccountScreen.dart';
import 'package:flutter/material.dart';
import '../network/api_service.dart';
import '../network/data_service.dart';
import 'documentPage.dart';
import 'main.dart';

class AccountPage extends StatefulWidget {
  final DataService dataService;
  final UserResponse userResponse;

  const AccountPage({
    required this.dataService,
    required this.userResponse,
    super.key,
  });

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Color.fromRGBO(88, 73, 111, 1), fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
        automaticallyImplyLeading: false,
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset("assets/TempProfileImage1.png"),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromRGBO(220, 201, 250, 1),
                      ),
                      child: const Icon(
                        Icons.add_circle,
                        color:  Color.fromRGBO(88, 73, 111, 1),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 200,
                child: Center(
                  child: Text(
                    widget.userResponse.name,
                    style: const TextStyle(
                      color: Color.fromRGBO(88, 73, 111, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Center(
                  child: Text(
                    widget.userResponse.email,
                    style: const TextStyle(
                      color: Color.fromRGBO(88, 73, 111, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditAccountScreen(
                          dataService: widget.dataService,
                          userResponse: widget.userResponse)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(220, 201, 250, 0.7), side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Edit profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(170, 136, 220, 0.7), side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Deactivate account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(135, 111, 170, 0.7), side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("Delete account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if (index == 0) {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentPage(
                  dataService: widget.dataService,
                  user: widget.userResponse,
                ),
              ),
            );
          } else if (index == 1) {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}
