import 'package:file_upload_app_part2/bloc/account/account_bloc.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/login/login.dart';

class AccountPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
        builder: (context, state){
          return Scaffold(
            backgroundColor: const Color.fromRGBO(242, 235, 251, 1),
            appBar: AppBar(
              actions: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Account Settings',
                          style: TextStyle(
                            color: Color.fromRGBO(88, 73, 111, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              backgroundColor: const Color.fromRGBO(233, 216, 243, 1),
              automaticallyImplyLeading: false,
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
                    SizedBox(width: 200),
                    SizedBox(width: 200),
                    const SizedBox(height: 10),
                    const SizedBox(height: 30),
                    const Divider(),
                    Text("Documents Archive cloud storage used: "),
                    ElevatedButton(
                        onPressed: () => {
                        },
                        child: Text("Edit Account")
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final userId = await getUserId();
                          if (userId != null) {
                            BlocProvider.of<AccountBloc>(context).add(
                              DeactivateAccount(id: userId),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Unable to retrieve user ID.')),
                            );
                          }
                        },
                        child: Text("Deactivate Account")
                    ),
                    ElevatedButton(
                        onPressed: () => "",
                        child: Text("Delete Account")
                    ),
                    ElevatedButton(
                        onPressed: () => {
                          BlocProvider.of<AccountBloc>(context).add(
                            LogoutButtonPressed(userWantsToLogout: true)
                          )
                        },
                        child: Text("Log out")
                    ),
                    const SizedBox(height: 10),
                    SizedBox(width: 200),
                    SizedBox(width: 200),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state){
          if (state.logoutSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
            );
          }
          if(state is LogoutButtonPressed){
            if(state.logoutSuccess){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            }
          }
        }
    );
  }

  Future<int?> getUserId() async {
    const storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'user_id');
    return userIdString != null ? int.tryParse(userIdString) : null;
  }
}