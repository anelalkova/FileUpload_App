import 'package:file_upload_app_part2/network/api_service.dart';
import 'package:file_upload_app_part2/network/data_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageToPdfScreen extends StatefulWidget{
  final DataService dataService;
  final UserResponse userResponse;

  const ImageToPdfScreen({
    required this.dataService,
    required this.userResponse,
    super.key,
  });

  @override
  _ImageToPdfScreenState createState() => _ImageToPdfScreenState();
}

class _ImageToPdfScreenState extends State<ImageToPdfScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Hello"),
    );
  }

}