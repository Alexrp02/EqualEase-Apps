import 'package:equalease_home/StudentsAssignedTask.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/studentData.dart';
import 'package:flutter/material.dart';
import 'createOrder.dart';

class StudentsPage extends StatefulWidget {
  @override
  _StudentsPageState createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final APIController _controller = APIController();
  List<Student> _StudentsAdded = [];

  @override
  void initState() {
    super.initState();
    _controller.getStudents().then((students) {
      setState(() {
        _StudentsAdded = students;
      });
    });
  }

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
                  'ESTUDIANTES',
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
        heightFactor: 1.0,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 170, 172, 174),
              width: 3.0,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < _StudentsAdded.length; i++)
                  Container(
                    padding: EdgeInsets.all(0),
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      border: Border.all(
                        color: const Color.fromARGB(255, 170, 172, 174),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('${_StudentsAdded[i].name}'),
                        Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentsAssignedTask(_StudentsAdded[i].id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color.fromARGB(255, 100, 100, 101), width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Tareas'),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StudentData(_StudentsAdded[i].id),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: const Color.fromARGB(255, 100, 100, 101), width: 2.0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Datos'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => createOrderPage(_StudentsAdded[i].id),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: const Color.fromARGB(255, 100, 100, 101), width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('P'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Acción al presionar el botón "C"
                            // Puedes agregar tu lógica aquí
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: const Color.fromARGB(255, 100, 100, 101), width: 2.0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('C'),
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
