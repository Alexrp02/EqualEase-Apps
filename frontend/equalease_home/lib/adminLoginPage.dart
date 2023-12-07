import 'package:equalease_home/enterAdminPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equalease_home/adminPage.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'models/teacher.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final APIController _controller = APIController();
  List<Teacher> _teachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    try {
      List<Teacher> teachers = await _controller.getTeachers();
      setState(() {
        _teachers = teachers;
      });
    } catch (error) {
      print('Error al cargar profesores: $error');
      // Puedes manejar el error según tus necesidades
    }
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
                  'INICIO DE SESION DE ADMINISTRADOR',
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
      body: FutureBuilder<List<Teacher>>(
        future: _controller.getTeachers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Teacher> teachers = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Número de columnas en la cuadrícula
                  crossAxisSpacing: 130.0, // Espaciado horizontal entre elementos
                  mainAxisSpacing: 130.0, // Espaciado vertical entre elementos
                ),
                itemCount: teachers.length,
                itemBuilder: (context, index) {
                  Teacher teacher = teachers[index];
                  ImageProvider profilePicture = AssetImage('teacher.profilePicture');
                  return GestureDetector(
                    onTap: () {
                      print('Profesor seleccionado: ${teacher.name}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterAdminPasswordPage(adminId: teacher.id),
                        ),
                      );
                    },
                    child: GridTile(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: profilePicture,
                      ),
                      footer: Container(
                        color: Colors.black.withOpacity(0.7),
                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          '${teacher.name} ${teacher.surname}',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Text('No hay datos');
          }
        },
      ),

    );
  }
}
