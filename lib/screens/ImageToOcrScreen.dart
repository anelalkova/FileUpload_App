import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/material.dart';

class ImageToOcrScreen extends StatefulWidget{
  final DataService dataService;
  final UserResponse userResponse;

  const ImageToOcrScreen({
    required this.dataService,
    required this.userResponse,
    super.key
  });

  @override
  _ImageToOcrScreenState createState() => _ImageToOcrScreenState();
}

class _ImageToOcrScreenState extends State<ImageToOcrScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello"),
    );
  }
}