
import 'package:equalease_home/StudentsAssignedTask.dart';
import 'package:equalease_home/components/menu_widget.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/classroom.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/studentData.dart';
import 'package:flutter/material.dart';

import 'models/student.dart';
//import 'createRequest.dart';


class StudentCommandPage extends StatefulWidget {
  final String representation;
  final Student student;
  const StudentCommandPage({Key? key,required this.representation, required this.student}): super(key: key);


  @override
  _StudentCommandPageState createState() => _StudentCommandPageState();
}

class _StudentCommandPageState extends State<StudentCommandPage> {
  final APIController _controller = APIController();
  List<Classroom> _classrooms = [];
  List<Teacher> _teachers = [];
  int estilo = 0;

  @override
  void initState() {
    super.initState();
    

    String audioInstructions;
    if(widget.student.representation=="audio"){
      audioInstructions="Estás en la página de comanda."+
      " Selecciona una clase para comenzar la comanda.";
    }else{
       audioInstructions="Estás en la página de comanda.";
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
                      'COMANDAS',
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
                      label: 'Pictograma de comanda',
                      child: Image.asset(
                        'assets/comida.png', // Reemplaza con la ruta de tu imagen local
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
            //   Center(
            //   heightFactor: 1.0,
            //   child: Container(
            //     decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Color.fromARGB(255, 170, 172, 174),
            //         width: 3.0,
            //       ),
            //     ),
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     child: SingleChildScrollView(
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: <Widget>[
            //           for (int i = 0; i < _classrooms.length; i++)
            //             InkWell(
            //               onTap: () {
            //                         Navigator.push(context,
            //                             MaterialPageRoute(builder: (context) {
            //                           return MenuCarousel(
            //                             classroom: _classrooms[i],
            //                           );
            //                         }));

            //                       },
            //               child:
            //               Container(
            //               padding: EdgeInsets.all(0),
            //               height: 80,
            //               decoration: BoxDecoration(
            //                 color: Color.fromARGB(255, 255, 255, 255),
            //                 border: Border.all(
            //                   color: const Color.fromARGB(255, 170, 172, 174),
            //                   width: 2.0,
            //                 ),
            //                 borderRadius: BorderRadius.circular(0),
            //               ),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: <Widget>[
            //                   Text('${_teachers[i].name}'),
            //                   Container(
            //                     width: 200,
            //                     height: 50,
            //                     child: Container(

            //                       padding: EdgeInsets.all(0), // Puedes ajustar esto según tus necesidades
            //                       child: Center(
            //                         child: Text(
            //                           _classrooms[i].letter,
            //                           // Puedes ajustar el estilo del texto según tus necesidades
            //                           style: TextStyle(
            //                             // Añade aquí las propiedades de estilo del texto
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     width: 200,
            //                     height: 50,
            //                     child: Container(

            //                       padding: EdgeInsets.all(0), // Puedes ajustar esto según tus necesidades
            //                       child: Center(
            //                         child: Image.network(
            //                         _teachers[i].profilePicture,
            //                         fit: BoxFit.cover,
            //                         height: 200, // Ajusta la altura según tus necesidades
            //                         width: 200,
            //                       ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     width: 200,
            //                     height: 50,
            //                     child: ElevatedButton(
            //                       onPressed: () {
            //                         Navigator.push(
            //                           context,
            //                           MaterialPageRoute(
            //                             builder: (context) => StudentData(_classrooms[i].assignedTeacher),
            //                           ),
            //                         );
            //                       },
            //                       style: ElevatedButton.styleFrom(
            //                         backgroundColor: Colors.white,
            //                         padding: EdgeInsets.all(0),
            //                         shape: RoundedRectangleBorder(
            //                           side: BorderSide(color: const Color.fromARGB(255, 100, 100, 101), width: 2.0),
            //                           borderRadius: BorderRadius.circular(10),
            //                         ),
            //                       ),
            //                       child: Text('Completado'),
            //                     ),
            //                   ),

            //                 ],
            //               ),
            //             ),

            //             )
            //         ],
            //       ),
            //     ),
            //   ),
            // )

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
                          // Mostrar la imagen del menú
                          Semantics(
                            label: "Foto de perfil de ${_teachers[i].name}",
                            child: Image.network(
                              _teachers[i].profilePicture,
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                          SizedBox(width: 16.0),
                          // Mostrar el título del menú con manejo de desbordamiento
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
                          // Mostrar la cantidad de KitchenOrders en el listado
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
                                label: "Pictograma representando menú de la clase completado",
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
                          return MenuCarousel(
                            classroom: _classrooms[i],
                            teacherPic: _teachers[i].profilePicture,
                            representation: widget.representation,
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
