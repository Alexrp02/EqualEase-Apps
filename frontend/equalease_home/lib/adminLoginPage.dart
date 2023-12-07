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
  // void initState() {
  //   super.initState();
  //   _loadTeachers();
  // }

  Future<void> _loadTeachers() async {
    try {
      //List<Teacher> teachers = await _controller.getTeachers();
      setState(() {
        //_teachers = teachers;
      });
    } catch (error) {
      print('Error al cargar profesores: $error');
      // Puedes manejar el error según tus necesidades
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INICIO DE SESION DE ADMINISTRADOR',
          style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPage(),
                ),
              );
            },
            child: Text(
              'Ingresar como Admin',
              style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 18),
            ),
          ),
          SizedBox(height: 20), // Espaciado entre el botón y la cuadrícula de profesores
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Número de columnas en la cuadrícula
                crossAxisSpacing: 8.0, // Espaciado horizontal entre elementos
                mainAxisSpacing: 8.0, // Espaciado vertical entre elementos
              ),
              itemCount: _teachers.length,
              itemBuilder: (context, index) {
                Teacher teacher = _teachers[index];
                return InkWell(
                  onTap: () {
                    // Lógica para manejar el toque en un profesor específico
                    print('Profesor seleccionado: ${teacher.name}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Puedes agregar una imagen del profesor aquí si es necesario
                        Text(
                          teacher.name,
                          style: TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
