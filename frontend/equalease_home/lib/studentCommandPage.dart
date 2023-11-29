import 'package:equalease_home/StudentsAssignedTask.dart';
import 'package:equalease_home/components/menu_widget.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/classroom.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/studentData.dart';
import 'package:flutter/material.dart';
//import 'createRequest.dart';

class StudentCommandPage extends StatefulWidget {
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
            leading: new IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: new Icon(
                  Icons.arrow_back,
                  size: 50.0,
                )),
            backgroundColor: Color.fromARGB(255, 161, 182, 236),
            title: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'COMANDAS',
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
                          Image.network(
                            _teachers[i].profilePicture,
                            width: 120.0,
                            height: 120.0,
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
                          Text(
                            "${classroomAdded.letter}",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24.0,
                            ),
                          ),
                          SizedBox(width: 300),
                          Text(
                            "COMPLETADO",
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24.0,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MenuCarousel(
                            classroom: _classrooms[i],
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
