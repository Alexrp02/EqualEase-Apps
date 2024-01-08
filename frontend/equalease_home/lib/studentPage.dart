import 'package:equalease_home/models/task.dart';
import 'package:flutter/material.dart';
import 'models/student.dart';
import 'models/classroom.dart';
import 'controllers/controller_api.dart';
import 'components/subtasks_widget.dart';
import 'models/subtask.dart';
import 'models/teacher.dart';

class StudentPage extends StatefulWidget {
  final Student student;
  final String representation;

  StudentPage({Key? key, required this.student, required this.representation})
      : super(key: key);

  @override
  _StudentPageState createState() {
    return _StudentPageState();
  }
}

class _StudentPageState extends State<StudentPage> {
  // final ControllerStudent _controller =
  //     ControllerStudent('http://www.google.es');

  APIController controller = APIController();
  Teacher teacher = Teacher(
      email: "",
      id: "",
      isAdmin: false,
      name: "",
      profilePicture: "",
      surname: "",
      students: []);
  Student student = Student(
    id: "",
    name: "",
    surname: "",
    pendingTasks: [],
    doneTasks: [],
    profilePicture: "",
    hasRequest: false,
    hasKitchenOrder: false,
    representation: "text",
  );
  List<Task> doneTasks = [];
  List<Task> pendingTasks = [
    // Task(
    //     id: "alfjn",
    //     title: "Hacer la cama",
    //     description: "En esta tarea, tendrás que hacer la cama solito",
    //     subtasks: [],
    //     type: "FixedType"),
    // Task(
    //     id: "alfjm",
    //     title: "Hacer un sandwich",
    //     description: "Pasos para hacer un sandwich de jamón y queso.",
    //     subtasks: [],
    //     type: "FixedType"),
  ];

  @override
  void initState() {
    super.initState();
    // controller.getStudent("6gsy3HsO0GQLwVcPvySA").then((value) {
    //   setState(() {
    //     student = value;
    //   });
    //   controller.getPendingTasksTodayFromStudent(student.id).then((value) {
    //     setState(() {
    //       pendingTasks = value;
    //     });
    //   });
    //   controller.getDoneTasksFromStudent(student.id).then((value) {
    //     setState(() {
    //       doneTasks = value;
    //     });
    //   });
    // });

    String audioInstructions;
    if (widget.student.representation == "audio") {
      audioInstructions = "Estás en la sección de tareas ." +
          "Aquí podrás ver las tareas que tienes que hacer" +
          "Para meterte en una tarea pulsa la que vaya a hacer";
    } else {
      audioInstructions = "Estás en la sección de tareas.";
    }

    controller.speak(audioInstructions);

    student = widget.student;
    controller.getPendingTasksTodayFromStudent(student.id).then((value) {
      setState(() {
        pendingTasks = value;
      });
    });
    controller.getDoneTasksFromStudent(student.id).then((value) {
      setState(() {
        doneTasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100.0,
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
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
                if (student.representation == "text" ||
                    student.representation == "audio")
                  Flexible(
                    child: Text(
                      'LISTA DE TAREAS DE ${student.name.toUpperCase()} ${student.surname.toUpperCase()}',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        color: Colors
                            .white, // Cambia el color de la fuente a blanco
                        fontWeight:
                            FontWeight.bold, // Hace la fuente más gruesa
                        fontSize: 50.0, // Cambia el tamaño de la fuente
                      ),
                    ),
                  )
                else
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Semantics(
                            label: "Pictograma de tareas",
                            child: Image.asset(
                              'assets/tareas.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ])
              ],
            ),
          ),
          actions: [
            ClipOval(
              child: Container(
                color: const Color.fromARGB(107, 255, 255, 255),
                child: Image.network(
                  widget.student.profilePicture,
                  width: 100.0,
                  height: 100.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          heightFactor: 1.0,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              // height: MediaQuery.of(context).size.height,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    childCount: pendingTasks.length,
                    (context, i) => Container(
                      padding: EdgeInsets.all(16),
                      // height: 80,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        border: Border.all(
                          color: const Color.fromARGB(255, 170, 172, 174),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              value:
                                  false, // Replace with your boolean variable
                              onChanged: (bool? value) {
                                if (value == true) {
                                  setState(() {
                                    controller.markTaskAsCompleted(
                                        student.id, pendingTasks[i].id);
                                    doneTasks.add(pendingTasks[i]);
                                    pendingTasks.removeAt(i);
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(
                              width:
                                  20.0), // Espacio entre el checkbox y el texto (tarea
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SubtasksCarousel(
                                  taskId: pendingTasks[i].id,
                                  student: student,
                                );
                              }));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                if (student.representation == "text" ||
                                    student.representation == "audio")
                                  Text(
                                    '${pendingTasks[i].title}',
                                    style: TextStyle(
                                      fontSize: 40.0,
                                    ),
                                  ),
                                if (student.representation == "text" ||
                                    student.representation ==
                                        "audio") // Primera parte
                                  Text(
                                    pendingTasks[i].description,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )
                                else
                                  Image.network(pendingTasks[i].pictogram)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: doneTasks.length,
                          (context, i) => InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return SubtasksCarousel(
                                      taskId: doneTasks[i].id,
                                      student: student,
                                    );
                                  }));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  // height: 80,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 170, 172, 174),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value:
                                              true, // Replace with your boolean variable
                                          onChanged: (bool? value) {},
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              20.0), // Espacio entre el checkbox y el texto (tarea
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          if (student.representation ==
                                                  "text" ||
                                              student.representation == "audio")
                                            Text(
                                              '${doneTasks[i].title}',
                                              style: TextStyle(
                                                fontSize: 40.0,
                                              ),
                                            ), // Primera parte
                                          if (student.representation ==
                                                  "text" ||
                                              student.representation == "audio")
                                            Text(
                                              doneTasks[i].description,
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            )
                                          else
                                            SizedBox(
                                                height: 100,
                                                width: 100,
                                                child: Semantics(
                                                  label:
                                                      "Pictogtrama representando la tarea. ${doneTasks[i].title}",
                                                  child: Image.asset(
                                                    'assets/${doneTasks[i].title}.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )))
                ],
              )),
        ),
      ),
    );
  }
}
