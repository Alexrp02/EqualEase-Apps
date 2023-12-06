import 'package:flutter/material.dart';
import 'studentLandingPage.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterPasswordPage extends StatefulWidget {
  final String studentId;

  EnterPasswordPage({required this.studentId});

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INTRODUCE TU CONTRASEÑA', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize:24)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Introduce tu contraseña',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Realiza la validación de la contraseña aquí
                // Puedes utilizar el controlador de API para verificar la contraseña del estudiante
                // Por ejemplo, _controller.validatePassword(widget.studentId, password);

                // Si la contraseña es válida, puedes navegar a la siguiente página
                // Si no, puedes mostrar un mensaje de error o realizar otra acción

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentLandingPage(
                          idStudent: widget.studentId)),
                );
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
