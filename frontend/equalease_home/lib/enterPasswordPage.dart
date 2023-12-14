import 'package:flutter/material.dart';
import 'studentLandingPage.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'components/widget_grid.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterPasswordPage extends StatefulWidget {
  final String studentId;

  EnterPasswordPage({required this.studentId});

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  String password = '';
  final APIController _controller = APIController();
  late TextEditingController _passwordController;

  final GlobalKey<PictogramGridViewState> _passwordGridKey =
      GlobalKey<PictogramGridViewState>();

  void updatePassword(String newPassword) {
    setState(() {
      password = newPassword;
    });
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
            ),
          ),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'ACCESO DE ALUMNO',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Expanded(
              child: PictogramGridView(
                gridKey: _passwordGridKey,
                onPasswordChanged: updatePassword,
                studentId: widget.studentId,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

// Resto del código...
