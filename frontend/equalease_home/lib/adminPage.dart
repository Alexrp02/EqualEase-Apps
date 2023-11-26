import 'package:equalease_home/menuAdmin.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'tasks.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              backgroundColor: Color.fromARGB(255, 161, 182, 236),
              title: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'PÁGINA DEL ADMINISTRADOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Center(
            child: _buildLandscapeLayout(context),
          ),
        );
      },
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
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 100)), // Ajusta la altura aquí
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
                  MaterialPageRoute(builder: (context) => TasksPage()),
                );
              },
              child: const Text('TAREAS'),
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
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 100)), // Ajusta la altura aquí
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
                  MaterialPageRoute(builder: (context) => MenuPage()),
                );
              },
              child: const Text('MENUS'),
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
                minimumSize: MaterialStateProperty.all(Size(double.infinity, 100)), // Ajusta la altura aquí
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
                  MaterialPageRoute(builder: (context) => StudentsPage()),
                );
              },
              child: const Text('ESTUDIANTES'),
            ),
          ),
        ),
      ],
    );

  }
}
