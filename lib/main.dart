import 'package:file_upload_app_part2/bloc/account/account_bloc.dart';
import 'package:file_upload_app_part2/bloc/file/file_bloc.dart';
import 'package:file_upload_app_part2/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/document/document_bloc.dart';
import 'bloc/login/auth_bloc.dart';
import 'bloc/main/landing_page_bloc.dart';
import 'screens_bloc/routes/generated_routes.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark, // Dark icons on status bar
    statusBarBrightness: Brightness.light, // Status bar brightness
    systemNavigationBarIconBrightness: Brightness.dark, // Dark icons on navigation bar
    systemNavigationBarColor: Colors.white, // Navigation bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LandingPageBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => DocumentBloc()),
        BlocProvider(create: (_) => AccountBloc()),
        BlocProvider(create: (_) => FileBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        initialRoute: '/login',
        onGenerateRoute: RouteGenerator().generateRoute,
      ),
    );
  }
}