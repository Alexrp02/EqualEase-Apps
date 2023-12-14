import 'package:equalease_home/menuAdmin.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'tasks.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              toolbarHeight: 100.0,
              backgroundColor: Color.fromARGB(255, 161, 182, 236),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 50.0,
                ),
              ),
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
                        fontSize: 50.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _buildLandscapeLayout(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Coloca aquí el código que deseas ejecutar al presionar el botón de engranaje.
            },
            tooltip: 'Configuración',
            backgroundColor: Color.fromARGB(255, 161, 182, 236),
            heroTag:
                null, // Para evitar advertencias sobre la falta de héroe en la animación
            child: Icon(
              Icons.settings,
              size: 56, // Ajusta el tamaño del ícono aquí
            ),
            mini: false, // Asegúrate de que el botón no sea mini
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0), // Ajusta el radio aquí
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 161, 182, 236);
    Color textColor = Colors.white; // Color blanco para el texto

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
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
                  MaterialPageRoute(builder: (context) => TasksPage()),
                );
              },
              child: const Text('TAREAS'),
            ),
          ),
          Padding(
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
                  MaterialPageRoute(builder: (context) => StudentsPage()),
                );
              },
              child: const Text('ESTUDIANTES'),
            ),
          ),
        ],
      ),
    );
  }
}
