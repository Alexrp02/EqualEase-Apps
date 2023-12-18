import 'package:flutter/material.dart';
import 'studentLandingPage.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'components/widget_grid.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterPasswordPage extends StatefulWidget {
  final String studentId;
  String representation= "";

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
  
  @override
  void initState() {
    super.initState();
    _controller.getStudent(widget.studentId).then((value) {
      setState((){
        widget.representation = value.representation;
        
        String audioHelp="";
        if(value.representation =="audio" ){
          audioHelp = "Estás en la página de introducir contraseña de ${value.name} ." +
          "Pulsa sobre las imágenes en el orden correcto para entrar en la aplicación.";
        }
        else{
          audioHelp = "Estás en la página de introducir contraseña de ${value.name} .";
        }
        _controller.speak(audioHelp);
      });
    });
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  if(widget.representation =="text" || widget.representation =="audio")
                      Text(
                        'ACCESO DE ALUMNO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      ),
                    if(widget.representation =="image") 
                      Semantics(
                          label: "Pictograma de contraseña",
                          child:Image.asset(
                            "assets/contraseña.png",
                            width: 100.0,
                            height: 100.0,
                        ),
                      )
                  ],)
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
