import 'package:flutter/material.dart';
import 'tasks.dart';

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
              child: (orientation == Orientation.portrait)
                  ? _buildPortraitLayout(context)
                  : _buildLandscapeLayout(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
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
                // Add functionality for Button 1
              },
              child: const Text('ALUMNOS'),
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
              child: const Text('ESTUDIANTES'),
            ),
          ),
        ),
      ],
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
                  MaterialPageRoute(builder: (context) => TasksPage()),
                );
              },
              child: const Text('ALUMNOS'),
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
              child: const Text('ESTUDIANTES'),
            ),
          ),
        ),
      ],
    );
  }
}
