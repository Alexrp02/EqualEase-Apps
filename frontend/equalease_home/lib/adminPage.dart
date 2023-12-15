import 'package:equalease_home/AdminRolPage.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'tasks.dart';

class AdminPage extends StatefulWidget {
  final String admin;

  const AdminPage({Key? key, required this.admin}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    // Lógica para obtener el estado de administrador al inicializar el estado
    _checkAdminStatus();
  }

  void _checkAdminStatus() {
    APIController controller = APIController();
    controller.getTeacher(widget.admin).then((value) {
      setState(() {
        isAdmin = value.isAdmin;
      });
    });
  }

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
                      'PÁGINA DEL DOCENTE',
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
          floatingActionButton: _buildFloatingActionButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 161, 182, 236);
    Color textColor = Colors.white;

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
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 100)),
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
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
                minimumSize:
                    MaterialStateProperty.all(Size(double.infinity, 100)),
                textStyle: MaterialStateProperty.all(
                  TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
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

  Widget _buildFloatingActionButton() {
    return isAdmin
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MuestraMenu()),
              );
            },
            tooltip: 'Configuración',
            backgroundColor: Color.fromARGB(255, 161, 182, 236),
            heroTag: null,
            child: Icon(
              Icons.settings,
              size: 56,
            ),
            mini: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          )
        : Container(); // Si no tiene el rol, el contenedor es invisible
  }
}
