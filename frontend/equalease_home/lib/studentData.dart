import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class StudentData extends StatefulWidget {
  final String _id;

  StudentData(String studentId) : _id = studentId;

  @override
  _StudentDataState createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Student? _student;
  APIController _controller = APIController();
  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    _student = null;

    _controller.getStudent(widget._id).then((student) {
      setState(() {
        _student = student;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
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
                _student != null
                    ? Text(
                        'DATOS DE ${_student!.name.toUpperCase()}',
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
      body: TabBarView(controller: tabController, children: [
        Center(
          child: _student != null
              ? buildStudentInfo()
              : Text('No se encontraron datos del estudiante'),
        ),
        Center(
          child: _student != null
              ? Text('Estadísticas del estudiante')
              : Text('No se encontraron datos del estudiante'),
        ),
      ]),
      bottomNavigationBar: GFTabBar(
        length: 2,
        controller: tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.person),
            child: Text(
              "Datos",
            ),
          ),
          Tab(
            icon: Icon(Icons.bar_chart),
            child: Text(
              "Estadísticas",
            ),
          ),
        ],
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
          _student!.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Apellidos:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _student!.surname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Acción a realizar al presionar el botón de editar
                print('Editar');
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Editar'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Acción a realizar al presionar el botón de eliminar
                print('Eliminar');
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Eliminar'),
            ),
          ],
        ),
      ],
    );
  }
}
