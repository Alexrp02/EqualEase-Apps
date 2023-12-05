import 'package:flutter/material.dart';
import 'package:equalease_home/components/item_widget.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/studentCommandPage.dart';
import 'package:equalease_home/studentPage.dart';

class StudentLandingPage extends StatefulWidget {
  final String idStudent;

  const StudentLandingPage({Key? key, required this.idStudent})
      : super(key: key);

  @override
  _StudentLandingPageState createState() => _StudentLandingPageState();
}

class _StudentLandingPageState extends State<StudentLandingPage> {
  Student student = new Student(
      id: 'id',
      name: 'name',
      surname: 'surname',
      pendingTasks: [],
      doneTasks: [],
      profilePicture: 'profilePicture',
      hasRequest: false,
      hasKitchenOrder: false);

  APIController controller = APIController();
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    controller.getStudent(widget.idStudent).then((value) {
      setState(() {
        student = value;
      });
      _speakStudentName();
    });
  }

  Future<void> _speakStudentName() async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak("Hola ${student.name}");
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
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
                      'ESTUDIANTE',
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
            child: _buildLandscapeLayout(context),
          ),
        );
      },
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    Color buttonColor = Color.fromARGB(255, 161, 182, 236);
    Color textColor = Colors.white; // Color blanco para el texto

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: student.hasRequest
                ? ElevatedButton(
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
                        MaterialPageRoute(
                            builder: (context) => (ItemCarousel(
                                  studentId: "6gsy3HsO0GQLwVcPvySA",
                                ))),
                      );
                    },
                    child: const Text('PEDIDO'),
                  )
                : Container(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: student.hasKitchenOrder
                ? ElevatedButton(
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
                        MaterialPageRoute(
                            builder: (context) => StudentCommandPage()),
                      );
                    },
                    child: const Text('COMANDA'),
                  )
                : Container(),
          ),
        ),
        Expanded(
          child: Padding(
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
                  MaterialPageRoute(builder: (context) => StudentPage()),
                );
              },
              child: const Text('TAREAS'),
            ),
          ),
        ),
      ],
    );
  }
}
