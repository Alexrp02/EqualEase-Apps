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
                  'ACCESO DE ADMINISTRADOR',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Introduce la contraseña',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 70),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Realiza la validación de la contraseña
                Map<String, dynamic> loginResult = await _controller.login(
                    widget.adminId, _passwordController.text);

                if (loginResult["token"] != null) {
                  // Contraseña válida, navega a la página de administrador
                  _passwordController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPage(admin: widget.adminId),
                    ),
                  );
                } else {
                  // Contraseña incorrecta, muestra un mensaje o realiza otra acción
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Contraseña Incorrecta'),
                        content:
                            Text('La contraseña introducida no es válida.'),
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
              child: Text('Acceder',
                  style:
                      GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 18)),
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
