import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  late ImagePicker _imagePicker;
  late XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _getImage() async {
    final XFile? imageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery, // Change to ImageSource.camera for camera
    );
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile == null
                ? Text('No image selected')
                : Image.file(File(_imageFile!.path)),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}
