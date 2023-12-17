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
  Student student = Student(
    id: 'id',
    name: 'name',
    surname: 'surname',
    pendingTasks: [],
    doneTasks: [],
    profilePicture: 'profilePicture',
    hasRequest: false,
    hasKitchenOrder: false,
    representation: "text",
  );

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
            preferredSize: const Size.fromHeight(100.0),
            child: AppBar(
              backgroundColor: const Color.fromARGB(255, 161, 182, 236),
              toolbarHeight: 100.0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 50.0,
                  )),
              title: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '${student.name.toUpperCase()} ${student.surname.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ClipOval(
                  child: Container(
                    color: const Color.fromARGB(107, 255, 255, 255),
                    child: student.profilePicture == 'profilePicture'
                        ? Container()
                        : Image.network(
                            student.profilePicture,
                            width: 100.0,
                            height: 100.0,
                          ),
                  ),
                ),
              ],
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemCarousel(
                          studentId: student.id,
                          student: student,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/materialEscolar.png',
                        height: 300,
                        width: 300,
                        //fit: BoxFit.contain,
                      ),
                      SizedBox(height: 50.0),
                      Text(
                        'PEDIDO',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(buttonColor),
                    foregroundColor: MaterialStateProperty.all(textColor),
                    //minimumSize: MaterialStateProperty.all(Size(double.infinity, 100)),
                  )
                   
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
                            builder: (context) => StudentCommandPage(
                                student: student,
                                representation: student.representation)),
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/comida.png',
                          height: 300,
                          width: 300,
                          //fit: BoxFit.contain,
                        ),
                        SizedBox(height: 50.0),
                        Text(
                          'COMANDA',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 50.0),
                      ],
                    ),
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
                  MaterialPageRoute(
                      builder: (context) => StudentPage(
                            student: student,
                          )),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/tareas.png',
                    height: 300,
                    width: 300,
                    //fit: BoxFit.contain,
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'TAREAS',
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
