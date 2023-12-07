import 'package:flutter/material.dart';
import 'package:equalease_home/controllers/controller_api.dart'; // Importa tu controlador de API
import 'package:equalease_home/models/student.dart'; // Importa tu modelo Student
import 'package:equalease_home/enterPasswordPage.dart'; // Importa la página EnterPasswordPage
import 'package:google_fonts/google_fonts.dart';
import 'adminLoginPage.dart';


class SelectAvatarPage extends StatelessWidget {
  final APIController _controller = APIController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¿QUIEN ERES?', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize:24)),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Navega a la página de inicio de sesión para administradores
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminLoginPage(),
                ),
              );
            },
            child: Text('ADMINISTRADOR', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 18)),
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _controller.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Student> students = snapshot.data!;
            ImageProvider profilePicture = AssetImage('assets/images/avatar.png');

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Número de columnas en la cuadrícula
                crossAxisSpacing: 130.0, // Espaciado horizontal entre los elementos
                mainAxisSpacing: 130.0, // Espaciado vertical entre los elementos
              ),
              itemCount: students.length,
              itemBuilder: (context, index) {
                Student student = students[index];
                profilePicture = AssetImage('student.profilePicture');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterPasswordPage(studentId: student.id),
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
                        '${student.name} ${student.surname}',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('No hay datos');
          }
        },
      ),
    );
  }
}
