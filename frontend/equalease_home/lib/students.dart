import 'package:equalease_home/controllers/controllerStudent.dart';
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}
class _StudentsPageState extends State<StudentsPage> {
  final ControllerStudent _controller = ControllerStudent('http://www.google.es');
  List<Student> _StudentsAdded = [];

  @override
  void initState() {
    super.initState();
    print("Agregando estudiantes");
    _controller.getAllStudents().then((students) {
      setState(() {
        _StudentsAdded = students;
        print(_StudentsAdded.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 170, 172, 174), // Color del borde
              width: 3.0, // Ancho del borde
            ),
          ), // Color de fondo para mostrar el espacio del SingleChildScrollView
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < _StudentsAdded.length; i++)
                  ElevatedButton(
                    onPressed: () {
                      // Acción a realizar cuando se presione el botón
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0), // Ajusta el relleno a 0 para controlar la altura
                      minimumSize: Size(double.infinity, 80),
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: const Color.fromARGB(255, 170, 172, 174), width: 2.0), // Borde
                        borderRadius: BorderRadius.circular(0), // Borde cuadrado
                      ), // Establece la altura deseada (en este caso, 50 píxeles)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround, // Divide el espacio en tres partes
                      children: <Widget>[
                        Text('${_StudentsAdded[i].name}'), // Primera parte
                        ElevatedButton(
                          onPressed: () {
                            // Acción a realizar cuando se presione el botón "Tareas"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color.fromARGB(255, 100, 100, 101), width: 2.0), // Borde
                                borderRadius: BorderRadius.circular(10), // Borde cuadrado
                              ),
                          ),
                          child: Text('Tareas'), // Segunda parte
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Acción a realizar cuando se presione el botón "Datos"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                             shape: RoundedRectangleBorder(
                                side: BorderSide(color: const Color.fromARGB(255, 100, 100, 101), width: 2.0), // Borde
                                borderRadius: BorderRadius.circular(10), // Borde cuadrado
                              ),
                          ),
                          child: Text('Datos'), // Tercera parte
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
