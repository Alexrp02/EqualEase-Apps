import 'package:equalease_home/StudentsAssignedTask.dart';
import 'package:equalease_home/components/item_widget.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/classroom.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/studentData.dart';
import 'package:flutter/material.dart';

import 'models/student.dart';
//import 'createRequest.dart';


class StudentOrderPage extends StatefulWidget {
  final String representation;
  final Student student;
  final String studentId;
  const StudentOrderPage({Key? key,required this.representation,required this.studentId, required this.student}): super(key: key);


  @override
  _StudentOrderPageState createState() => _StudentOrderPageState();
}

class _StudentOrderPageState extends State<StudentOrderPage> {
  final APIController _controller = APIController();
  List<Classroom> _classrooms = [];
  List<Teacher> _teachers = [];
  int estilo = 0;

  @override
  void initState() {
    super.initState();
    

    String audioInstructions;
    if(widget.student.representation=="audio"){
      audioInstructions="Estás en la página de pedido."+
      " Selecciona una clase para comenzar el pedido.";
    }else{
       audioInstructions="Estás en la página del pedido.";
    }

    _controller.speak(audioInstructions);

    _controller.getClassrooms().then((classrooms) {
      setState(() {
        _classrooms = classrooms;

        for (int i = 0; i < _classrooms.length; i++) {
          _controller
              .getTeacher(_classrooms[i].assignedTeacher)
              .then((teacher) {
            setState(() {
              _teachers.add(teacher);
            });
          });
        }
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
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 50.0,
                )),
            backgroundColor: Color.fromARGB(255, 161, 182, 236),
            title:  Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if(widget.representation == "text" || widget.representation == "audio" )
                    Text(
                      'PEDIDOS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50.0,
                      ),
                    )
                  else 
                  SizedBox(
                    width: 100.0, // Ajusta el ancho deseado
                    height: 100.0, // Ajusta la altura deseada
                    child: Semantics(
                      label: 'Pictograma de pedidos',
                      child: Image.asset(
                        'assets/materialEscolar.png', // Reemplaza con la ruta de tu imagen local
                        fit: BoxFit.cover, // Puedes ajustar el modo de ajuste según tus necesidades
                      ),
                    )
                  ),
                    
                ],
              ),
            ),
            actions: [
              ClipOval(
                child: Container(
                  color: const Color.fromARGB(107, 255, 255, 255),
                  child: Semantics(
                    label: "Foto de perfil de ${widget.student.name}",
                    child: Image.network(
                      widget.student.profilePicture,
                      width: 100.0,
                      height: 100.0,
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
        body: _teachers.isNotEmpty
            ?
          

            ListView.builder(
                itemCount: _classrooms.length,
                itemBuilder: (context, i) {
                  final Classroom classroomAdded = _classrooms[i];
                  int currentIndex = i + 1;
                  return Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Row(
                        children: [
                          // Mostrar la imagen del pedido
                          Semantics(
                            label: "Foto de perfil de ${_teachers[i].name}",
                            child: Image.network(
                              _teachers[i].profilePicture,
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Mostrar el título del pedido con manejo de desbordamiento
                          Expanded(
                            child: Text(
                              _teachers[i].name,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Mostrar la cantidad de items en el listado
                         if(widget.representation == "text" || widget.representation=="audio")
                            Text(
                              "${classroomAdded.letter}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24.0,
                              ),
                            )
                          else
                            SizedBox(
                              width: 100.0, // Ajusta el ancho deseado
                              height: 100.0, // Ajusta la altura deseada
                                child: Semantics(
                                  label: "Pictograma de la clase ${classroomAdded.letter}",
                                  child: Image.asset(
                                    'assets/clase${classroomAdded.letter}.png', // Reemplaza con la ruta de tu imagen local
                                    fit: BoxFit.cover, // Puedes ajustar el modo de ajuste según tus necesidades
                                  ),
                                ),
                            ),

                          SizedBox(width: 300),

                          if(widget.representation == "text" || widget.representation=="audio")
                            Text(
                              "COMPLETADO",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24.0,
                              ),
                            )
                          else
                            SizedBox(
                              width: 100.0, // Ajusta el ancho deseado
                              height: 100.0, // Ajusta la altura deseada
                              child: Semantics(
                                label: "Pictograma representando pedido de la clase completado",
                                child: Image.asset(
                                  'assets/bien.png', // Reemplaza con la ruta de tu imagen local
                                  fit: BoxFit.cover, // Puedes ajustar el modo de ajuste según tus necesidades
                                ),
                              )
                            )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ItemCarousel(
                            classroom: _classrooms[i],
                            teacherPic: _teachers[i].profilePicture,
                            representation: widget.representation,
                            studentId: widget.studentId,
                            student: widget.student,
                          );
                        }));
                      },
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  'No hay profesores disponibles.',
                  style: TextStyle(fontSize: 18),
                ),
              ));
  }
}
