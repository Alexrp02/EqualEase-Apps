import 'package:flutter/material.dart';
import 'package:equalease_home/controllers/controller_api.dart'; // Importa tu controlador de API
import 'package:google_fonts/google_fonts.dart';
import 'adminPage.dart'; // Importa la página AdminPage

class EnterAdminPasswordPage extends StatefulWidget {
  final String adminId;

  EnterAdminPasswordPage({required this.adminId});

  @override
  _EnterAdminPasswordPageState createState() => _EnterAdminPasswordPageState();
}

class _EnterAdminPasswordPageState extends State<EnterAdminPasswordPage> {
  final APIController _controller = APIController();
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduce la Contraseña', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 24)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realiza la validación de la contraseña
                bool isValid = await _controller.login(widget.adminId, _passwordController.text);

                if (isValid) {
                  // Contraseña válida, navega a la página de administrador
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPage(),
                    ),
                  );
                } else {
                  // Contraseña incorrecta, muestra un mensaje o realiza otra acción
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Contraseña Incorrecta'),
                        content: Text('La contraseña introducida no es válida.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Ingresar', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
