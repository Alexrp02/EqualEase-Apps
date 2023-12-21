import 'package:flutter/material.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/editStudentDataPage.dart';
import 'package:equalease_home/editTeacherPage.dart';

class DetallesTeacherPage extends StatefulWidget {
  final Teacher teacher;

  DetallesTeacherPage({required this.teacher});

  @override
  _DetallesTeacherPage createState() => _DetallesTeacherPage();
}

class _DetallesTeacherPage extends State<DetallesTeacherPage>
    with TickerProviderStateMixin {
  Teacher? _teacher;
  List<Student> _assignedStudents = [];
  APIController controller = APIController();

  @override
  void initState() {
    super.initState();

    _teacher = null;

    controller.getTeacher(widget.teacher.id).then((teacher) {
      setState(() {
        _teacher = teacher;
      });

      // Obtener detalles de estudiantes asignados
      if (_teacher != null) {
        _loadAssignedStudentsDetails();
      }
    });
  }

  void _loadAssignedStudentsDetails() async {
    List<Student> assignedStudents = [];

    // Obtener detalles de cada estudiante asignado
    for (String studentId in _teacher!.students) {
      Student student = await controller.getStudent(studentId);
      assignedStudents.add(student);
    }

    setState(() {
      _assignedStudents = assignedStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          actions: [
            // Agrega el botón de cerrar sesión en el AppBar
            IconButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              icon: Icon(
                Icons.exit_to_app,
                size: 70.0,
              ),
            ),
          ],
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
                    : const Text(
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
            ? buildTeacherInfo()
            : const Text('No se encontraron datos del profesor'),
      ),
    );
  }

  Widget buildTeacherInfo() {
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
        Text(
          'Administrador:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _teacher!.isAdmin ? 'Sí' : 'No',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          'Estudiantes Asignados:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        _assignedStudents.isNotEmpty
            ? Column(
                children: _assignedStudents
                    .map((student) => ListTile(
                          title: Center(
                            child: Text(
                              '${student.name} ${student.surname}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // Puedes agregar más información del estudiante aquí
                        ))
                    .toList(),
              )
            : Text('No hay estudiantes asignados'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTeacherDataPage(
                            teacher: _teacher!,
                          )),
                ).then((value) {
                  setState(() {
                    _teacher = value;
                    _loadAssignedStudentsDetails();
                  });
                });
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
                _showDeleteConfirmationDialog(_teacher);
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

  void _showDeleteConfirmationDialog(Teacher? teacher) {
    bool isDeleted = false;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "ELIMINAR DOCENTE",
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
                  "¿ESTÁ SEGURO?",
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
                await controller.deleteTeacher(teacher!.id);
                isDeleted = true;
                setState(() {});
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
