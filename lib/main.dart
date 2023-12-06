import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Tarea'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _file;
  XFile? _filetoshare;
  final picker = ImagePicker();
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _filetoshare = pickedFile;
        _file = File(pickedFile.path);
      } else {
        log('No image selected.');
      }
    });
  }

  Future shareImage() async {
    if (_filetoshare != null) {
      final result =
          await Share.shareXFiles([_filetoshare!], text: 'Great picture');

      if (result.status == ShareResultStatus.success) {
        log('Thank you for sharing the picture!');
      }
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text('No tienes una imagen seleccionada')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _file == null
                        ? const SizedBox(
                            height: 500.0,
                            width: 300.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.no_photography,
                                  size: 50.0,
                                ),
                                Text('No haz capturado una foto'),
                              ],
                            ))
                        : SizedBox(
                            height: 500.0,
                            width: 300.0,
                            child: Image(
                              image: FileImage(_file!),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 80.0,
            child: FloatingActionButton(
              onPressed: getImageFromCamera,
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: shareImage,
              child: const Icon(Icons.share),
            ),
          )
        ],
      ),
    );
  }
}
