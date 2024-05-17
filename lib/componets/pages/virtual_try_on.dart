import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VirtualTryOnPage extends StatefulWidget {
  @override
  _VirtualTryOnPageState createState() => _VirtualTryOnPageState();
}

class _VirtualTryOnPageState extends State<VirtualTryOnPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    return _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Try-On'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image =
                await _controller.takePicture(); // Capture the picture
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Show3DModelPage(
                  capturedImage: image,
                ),
              ),
            );
          } catch (e) {
            print('Error: $e');
          }
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}

class Show3DModelPage extends StatelessWidget {
  final XFile capturedImage;

  Show3DModelPage({required this.capturedImage});

  @override
  Widget build(BuildContext context) {
    // Implement the 3D model rendering logic using the captured image data
    return Scaffold(
      appBar: AppBar(
        title: Text('3D Model Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show 3D Model Here',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Image.file(File(capturedImage.path)), // Display captured image
            // Implement 3D model rendering using captured image data
          ],
        ),
      ),
    );
  }
}
