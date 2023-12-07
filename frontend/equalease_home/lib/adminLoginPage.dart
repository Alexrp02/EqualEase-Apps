import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equalease_home/adminPage.dart';



class AdminLoginPage extends StatelessWidget {
  // Implementa tu página de inicio de sesión para administradores aquí
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INICIO DE SESION DE ADMINISTRADOR', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 24)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPage(),
                ),
              );
          },
          child: Text('Ingresar como Admin', style: GoogleFonts.notoSansInscriptionalPahlavi(fontSize: 18)),
        ),
      ),
    );
  }
}