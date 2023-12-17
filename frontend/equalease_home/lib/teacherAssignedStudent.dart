import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:flutter/material.dart';

class TeacherAssignedStudent extends StatefulWidget {
  final String _id;
  final List<String> assignedStudentIds;

  TeacherAssignedStudent(String teacherId, this.assignedStudentIds)
      : _id = teacherId;

  @override
  _TeacherAssignedStudentState createState() => _TeacherAssignedStudentState();
}

class _TeacherAssignedStudentState extends State<TeacherAssignedStudent> {
  final APIController _controller = APIController();
  Teacher? _teacher;
  List<Student> allStudents = [];
  List<String> selectedStudentIds = [];

  @override
  void initState() {
    super.initState();
    _controller.getTeacher(widget._id).then((teach) {
      setState(() {
        _teacher = teach;
        // Inicializar selectedStudentIds con los estudiantes asignados al profesor
        selectedStudentIds = _teacher!.students;
      });
    });
    _controller.getStudents().then((studs) {
      setState(() {
        allStudents = studs;
      });
    });
  }

  void _openTaskSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          assignedStudentIds: _teacher!.students,
          totalStudents: allStudents,
          onStudentsUpdated: (updatedStudentIds) {
            setState(() {
              selectedStudentIds = updatedStudentIds;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          toolbarHeight: 100.0,
          leading: new IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(
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
                        'ESTUDIANTES DE ${_teacher!.name.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      )
                    : const Text(
                        'ESTUDIANTES',
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
      body: _teacher == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            for (Student student in allStudents)
                              CheckboxListTile(
                                title: Row(children: [
                                  Image.network(
                                    student.profilePicture,
                                    width: 75.0,
                                    height: 75.0,
                                  ),
                                  SizedBox(width: 10),
                                  Text('${student.name} ${student.surname}'),
                                ]),
                                value: selectedStudentIds.contains(student.id),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value != null) {
                                      if (value) {
                                        selectedStudentIds.add(student.id);
                                        _controller.addStudentToTeacherList(
                                            _teacher!.id, student.id);
                                      } else {
                                        selectedStudentIds.remove(student.id);
                                        _controller
                                            .removeStudentFromTeacherList(
                                                _teacher!.id, student.id);
                                      }
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save the selected student IDs to the teacher
          _teacher!.students = selectedStudentIds;
          // Update the teacher in the database
          _controller.updateTeacher(_teacher!);
          // Optionally, you can show a confirmation message or perform any other action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('CAMBIOS GUARDADOS CORRECTAMENTE'),
            ),
          );
        },
        child: Icon(Icons.save, color: Colors.white, size: 50),
        backgroundColor: Color.fromARGB(255, 161, 182, 236),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  final List<String> assignedStudentIds;
  final List<Student> totalStudents;
  final Function(List<String>) onStudentsUpdated;

  CustomDialog({
    required this.assignedStudentIds,
    required this.totalStudents,
    required this.onStudentsUpdated,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomDialogState();
  }
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Seleccionar Estudiantes"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (Student student in widget.totalStudents)
              CheckboxListTile(
                title: Row(children: [
                  Image.network(
                    student.profilePicture,
                    width: 75.0,
                    height: 75.0,
                  ),
                  SizedBox(width: 10),
                  Text('${student.name} ${student.surname}'),
                ]),
                value: widget.assignedStudentIds.contains(student.id),
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        widget.assignedStudentIds.add(student.id);
                      } else {
                        widget.assignedStudentIds.remove(student.id);
                      }
                    }
                    widget.onStudentsUpdated(widget.assignedStudentIds);
                  });
                },
              ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Aceptar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
