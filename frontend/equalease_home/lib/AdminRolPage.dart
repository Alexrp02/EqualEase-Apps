import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/teacherAssignedStudent.dart';
import 'package:flutter/material.dart';
import 'package:equalease_home/addStudent.dart';
import 'package:equalease_home/addTeacher.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'detallesStudentPage.dart';
import 'detallesTeacherPage.dart';

class MuestraMenu extends StatefulWidget {
  @override
  _MuestraMenuState createState() => _MuestraMenuState();
}

class _MuestraMenuState extends State<MuestraMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    StudentAdministrationPage(),
    TeacherAdministrationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Muestra Menú'),
      ),*/
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ESTUDIANTES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'DOCENTES',
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página 1'),
    );
  }
}

class StudentAdministrationPage extends StatefulWidget {
  StudentAdministrationPage();

  @override
  _StudentAdministrationPage createState() => _StudentAdministrationPage();
}

class _StudentAdministrationPage extends State<StudentAdministrationPage>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Student? _student;
  APIController _controller = APIController();
  //late TabController tabController;
  late Map<String, dynamic> data;
  bool isLoading = true;

  List<Student> _StudentsAdded = []; //para obtener los alumnos

  @override
  void initState() {
    super.initState();

    //tabController = TabController(length: 2, vsync: this);

    _controller.getStudents().then((students) {
      setState(() {
        _StudentsAdded = students;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    //tabController.dispose();
    super.dispose();
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
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MENU ADMINISTRADOR ESTUDIANTES',
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
      body: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Dos elementos por fila
                    crossAxisSpacing: 10.0, // Espacio entre elementos
                    mainAxisSpacing: 10.0, // Espacio entre filas
                  ),
                  itemCount: _StudentsAdded.length,
                  itemBuilder: (context, i) {
                    final Student StudentAgregada = _StudentsAdded[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesStudentPage(
                              student: StudentAgregada,
                            ),
                          ),
                        ).then((value) {
                          setState(() {
                            if (value) {
                              _StudentsAdded.remove(StudentAgregada);
                            }
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 170, 172, 174),
                            width: 3.0,
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'ESTUDIANTE $currentIndex: ${StudentAgregada.name} ${StudentAgregada.surname}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize:
                                        30.0, // Ajusta el tamaño del texto
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(children: [
                            Expanded(
                              child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                    StudentAgregada.profilePicture,
                                    fit: BoxFit.contain,
                                  )),
                            )
                          ]),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color.fromARGB(255, 170, 172, 174),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddStudentForm()),
            ).then((value) {
              setState(() {
                _StudentsAdded.add(value);
              });
            });
          },
          child: Icon(
            Icons.add,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

class TeacherAdministrationPage extends StatefulWidget {
  TeacherAdministrationPage();

  @override
  _TeacherAdministrationPage createState() => _TeacherAdministrationPage();
}

class _TeacherAdministrationPage extends State<TeacherAdministrationPage>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Student? _student;
  APIController _controller = APIController();
  //late TabController tabController;
  late Map<String, dynamic> data;
  bool isLoading = true;

  List<Teacher> _TeachersAdded = []; //para obtener los alumnos

  @override
  void initState() {
    super.initState();

    //tabController = TabController(length: 2, vsync: this);

    _controller.getTeachers().then((teachers) {
      setState(() {
        _TeachersAdded = teachers;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    //tabController.dispose();
    super.dispose();
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
              )),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MENU ADMINISTRADOR DOCENTES',
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
      body: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Dos elementos por fila
                    crossAxisSpacing: 10.0, // Espacio entre elementos
                    mainAxisSpacing: 10.0, // Espacio entre filas
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _TeachersAdded.length,
                  itemBuilder: (context, i) {
                    final Teacher TeacherAgregada = _TeachersAdded[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesTeacherPage(
                              teacher: TeacherAgregada,
                            ),
                          ),
                        ).then((value) {
                          setState(() {
                            if (value) {
                              _TeachersAdded.remove(TeacherAgregada);
                            }
                          });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 170, 172, 174),
                            width: 3.0,
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'DOCENTE $currentIndex: ${TeacherAgregada.name} ${TeacherAgregada.surname}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize:
                                        30.0, // Ajusta el tamaño del texto
                                  ),
                                ),
                              ),
                              // Icono person_add al lado del profesor
                              IconButton(
                                icon: Icon(Icons.person_add),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TeacherAssignedStudent(
                                              TeacherAgregada.id,
                                              TeacherAgregada.students),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          subtitle: Row(children: [
                            Expanded(
                              child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                    TeacherAgregada.profilePicture,
                                    fit: BoxFit.contain,
                                  )),
                            )
                          ]),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color.fromARGB(255, 170, 172, 174),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTeacherForm()),
            ).then((value) {
              setState(() {
                _TeachersAdded.add(value);
              });
            });
          },
          child: Icon(
            Icons.add,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Página 2'),
    );
  }
}
