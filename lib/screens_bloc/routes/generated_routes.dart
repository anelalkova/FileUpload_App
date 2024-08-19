import 'package:file_upload_app_part2/bloc/account/account_bloc.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/bloc/login/auth_bloc.dart';
import 'package:file_upload_app_part2/bloc/main/landing_page_bloc.dart';
import 'package:file_upload_app_part2/screens_bloc/account_page/account_page.dart';
import 'package:file_upload_app_part2/screens_bloc/auth/login/login.dart';
import 'package:file_upload_app_part2/screens_bloc/documents_page/documents_page.dart';
import 'package:file_upload_app_part2/screens_bloc/landing_page/langing_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/document/document_bloc.dart';
import '../files_page/files_page.dart';

class RouteGenerator{
  final landingPageBLoc = LandingPageBloc();
  final loginPageBloc = AuthBloc();
  final documentsPageBloc = DocumentBloc();
  final accountPageBloc = AccountBloc();
  final filePageBloc = FileBloc();

  Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<LandingPageBloc>.value(
              value: landingPageBLoc,
              child: LandingPage(),
            )
        );
      case '/login':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AuthBloc>.value(
                value: loginPageBloc,
                child: const LoginScreen(),
            ),
        );
      case '/documents_page':
          return MaterialPageRoute(
              builder: (_) => BlocProvider<DocumentBloc>.value(
                  value: documentsPageBloc,
                  child: const DocumentsPage(),
              )
          );
      case '/account_page':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<AccountBloc>.value(
                value: accountPageBloc,
                child: AccountPage(),
            )
        );
      case '/file_page':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<FileBloc>.value(
              value: filePageBloc,
              child: FilePage(),
            )
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}