import 'package:flutter/material.dart';
import 'tasks.dart';
import 'adminPage.dart';
import 'controllers/controller_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('EqualEase Home'),
            ),
            body: Center(
              child: _buildLandscapeLayout(context),
            ),
          );
        },
      ),
    );
  }



  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 48),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
              child: const Text('ADMINISTRADOR'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 48),
                ),
              ),
              onPressed: () {
                // Add functionality for Button 2
              },
              child: const Text('ESTUDIANTE'),
            ),
          ),
        ),
      ],
    );
  }
}
