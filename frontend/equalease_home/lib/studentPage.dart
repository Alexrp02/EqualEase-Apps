import 'package:equalease_home/models/task.dart';
import 'package:flutter/material.dart';
import 'models/student.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  // final ControllerStudent _controller =
  //     ControllerStudent('http://www.google.es');
  List<Task> pendingTasks = [
    Task(
        id: "alfjn",
        title: "Hacer la cama",
        description: "En esta tarea, tendrás que hacer la cama solito",
        subtasks: [],
        type: "FixedType"),
    Task(
        id: "alfjn",
        title: "Hacer un sandwich",
        description: "Pasos para hacer un sandwich de jamón y queso.",
        subtasks: [],
        type: "FixedType"),
  ];

  @override
  Widget build(BuildContext context) {
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
                  'LISTA DE TAREAS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.white, // Cambia el color de la fuente a blanco
                    fontWeight: FontWeight.bold, // Hace la fuente más gruesa
                    fontSize: 24.0, // Cambia el tamaño de la fuente
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          heightFactor: 1.0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromARGB(255, 170, 172, 174), // Color del borde
                width: 3.0, // Ancho del borde
              ),
            ), // Color de fondo para mostrar el espacio del SingleChildScrollView
            width: MediaQuery.of(context).size.width * 0.8,
            // height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  for (int i = 0; i < pendingTasks.length; i++)
                    InkWell(
                      onTap: () => print('Tarea pulsada'),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        // height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(
                            color: const Color.fromARGB(255, 170, 172, 174),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value:
                                    false, // Replace with your boolean variable
                                onChanged: (bool? value) {
                                  // Handle change
                                },
                              ),
                            ),
                            SizedBox(
                                width:
                                    20.0), // Espacio entre el checkbox y el texto (tarea
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${pendingTasks[i].title}',
                                  style: TextStyle(
                                    fontSize: 40.0,
                                  ),
                                ), // Primera parte
                                Text(
                                  pendingTasks[i].description,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}