import 'package:file_upload_app_part2/bloc/account/account_bloc.dart';
import 'package:file_upload_app_part2/bloc/document/document_bloc.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/bloc/login/auth_bloc.dart';
import 'package:file_upload_app_part2/bloc/main/landing_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/login/login.dart';

class AccountPage extends StatelessWidget{
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: const Text("Account Settings"),
              actions: const [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                ),
              ],
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Container(
                width: 400,
                height: 600,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(height: 60),
                    Column(
                      children: [
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
                            child: const Text("Deactivate Account")
                        ),
                        ElevatedButton(
                            onPressed: () => "",
                            child: const Text("Delete Account")
                        ),
                        ElevatedButton(
                            onPressed: () => {
                              BlocProvider.of<AccountBloc>(context).add(
                                  LogoutButtonPressed(userWantsToLogout: true)
                              )
                            },
                            child: const Text("Log out")
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state){
          if (state.logoutSuccess) {
            BlocProvider.of<AuthBloc>(context).add(ReturnAuthInitialState());
            BlocProvider.of<DocumentBloc>(context).add(ReturnDocumentInitialState());
            BlocProvider.of<FileBloc>(context).add(ReturnFileInitialState());
            BlocProvider.of<AccountBloc>(context).add(ReturnAccountInitialState());
            BlocProvider.of<LandingPageBloc>(context).add(ReturnLandingInitialState());
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );
          }
        }
    );
  }

  Future<int?> getUserId() async {
    const storage = FlutterSecureStorage();
    String? userIdString = await storage.read(key: 'user_id');
    return userIdString != null ? int.tryParse(userIdString) : null;
  }

  Future<String?> getEmail()async{
    const storage = FlutterSecureStorage();
    String? userEmail = await storage.read(key: 'email');
    return userEmail;
  }
}