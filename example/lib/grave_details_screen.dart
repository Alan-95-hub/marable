import 'dart:io';

import 'package:flutter/material.dart';

class GraveDetailsScreen extends StatefulWidget {
  final String name;
  final String dob;
  final String dod;
  final String bio;
  final String? imageUrl;

  const GraveDetailsScreen({
    Key? key,
    required this.name,
    required this.dob,
    required this.dod,
    required this.bio,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _GraveDetailsScreenState createState() => _GraveDetailsScreenState();
}

class _GraveDetailsScreenState extends State<GraveDetailsScreen> {
  File? _imageFile;
  bool _isImageLoading = false;
  String? imageUrl;

  Future<void> _uploadImage() async {
    setState(() {
      _isImageLoading = true;
    });

    // Simulate uploading image to a server with a delay of 2 seconds
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isImageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О памятнике'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
              )
            else if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                height: 200,
              )
            else
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: double.infinity,
              ),
            SizedBox(height: 10),
            if (_isImageLoading)
              CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.photo),
                label: Text('Выбрать фото'),
              ),
            SizedBox(height: 20),
            Text(
              '${widget.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.dob}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.dod}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '${widget.bio}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
