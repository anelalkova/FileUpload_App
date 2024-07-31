
import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';

class AccountPage extends StatefulWidget{
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

class _AccountPageState extends State<AccountPage>{

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
        appBar: AppBar(
          title: const Text('Documents Archive'),
          backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Text("Name: "+widget.userResponse.name),
            )
          ],
        ),
      );
  }
}