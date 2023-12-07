import 'package:equalease_home/studentLandingPage.dart';
import 'package:equalease_home/studentPage.dart';
import 'package:flutter/material.dart';
import 'tasks.dart';
import 'adminPage.dart';
import 'controllers/controller_api.dart';
import 'selectAvatarPage.dart';
import 'adminLoginPage.dart';

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
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: AppBar(
                toolbarHeight: 100.0,
                backgroundColor: Color.fromARGB(255, 161, 182, 236),
                title: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'EQUALEASE HOME',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Center(
              //child: _buildLandscapeLayout(context),
              child: SelectAvatarPage(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 161, 182, 236);
    Color textColor = Colors.white; // Color blanco para el texto

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                foregroundColor: MaterialStateProperty.all(textColor),
                minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 100)), // Ajusta la altura aquí
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginPage()),
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
                backgroundColor: MaterialStateProperty.all(buttonColor),
                foregroundColor: MaterialStateProperty.all(textColor),
                minimumSize: MaterialStateProperty.all(
                    Size(double.infinity, 100)), // Ajusta la altura aquí
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold, // Texto en negrita
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectAvatarPage()),
                );
              },
              child: const Text('ESTUDIANTE'),
            ),
          ),
        ),
      ],
    );
  }
}
