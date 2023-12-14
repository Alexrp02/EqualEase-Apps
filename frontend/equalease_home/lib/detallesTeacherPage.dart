import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:equalease_home/editStudentDataPage.dart';

class DetallesTeacherPage extends StatefulWidget {
  final Teacher teacher;

  DetallesTeacherPage({required this.teacher});

  @override
  _DetallesTeacherPage createState() => _DetallesTeacherPage();
}

class _DetallesTeacherPage extends State<DetallesTeacherPage>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Teacher? _teacher;
  APIController controller = APIController();
  //late TabController tabController;

  @override
  void initState() {
    super.initState();

    //tabController = TabController(length: 2, vsync: this);

    _teacher = null;

    controller.getTeacher(widget.teacher.id).then((teacher) {
      setState(() {
        _teacher = teacher;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100.0,
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          leading: new IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: new Icon(
                Icons.arrow_back,
                size: 50.0,
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _teacher != null
                    ? Text(
                        'DATOS DE ${_teacher!.name.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      )
                    :
                    // Si no se ha obtenido el estudiante, se muestra un texto genérico
                    const Text(
                        'DATOS',
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
        child: _teacher != null
            ? buildStudentInfo()
            : const Text('No se encontraron datos del estudiante'),
      ),
    );
  }

  Widget buildStudentInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nombre:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _teacher!.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Apellidos:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _teacher!.surname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Correo Electronico:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _teacher!.email,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Image.network(
          _teacher!.profilePicture,
          width: 150.0,
          height: 150.0,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditStudentDataPage(
                            student: _student!,
                          )),
                ).then((value) {
                  setState(() {
                    _student = value;
                  });
                });*/
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 182, 236),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Editar'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
               // _showDeleteConfirmationDialog(_student);

                print('Eliminar');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 182, 236),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Eliminar'),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(Student? student) {
    bool isDeleted = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "ELIMINAR ESTUDIANTE",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "¿ESTA SEGURO?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "CANCELAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "ACEPTAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await controller.deleteStudent(student!.id);
                isDeleted = true;
                setState(() {
                  //_TasksAgregadas.remove(task);

                  // Llamar al controlador de eliminación
                });
                //Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        );
      },
    ).then((value) => Navigator.pop(context, isDeleted));
  }
}
