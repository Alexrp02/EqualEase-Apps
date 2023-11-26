import 'package:equalease_home/addMenu.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/menu.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoading = true;
  final controller = APIController();

  //duda aqui ve kitchen order o menu?
  List<Menu> _MenuAgregadas = [
    // Task(
    //     id: "prueba",
    //     title: "Tarea de prueba",
    //     description: "Esta es una tarea de prueba para probar el carrusel",
    //     subtasks: [
    //       Subtask(
    //           id: "Prueba",
    //           title: "Coger las sabanas",
    //           description: "Acercate al armario y coge las sabanas"),
    //       Subtask(
    //           id: "afad",
    //           title: "Extender las sábanas",
    //           description: "Extiende las sábanas en algún lado plano.")
    //     ],
    //     type: "FixedType")
  ]; // Cambiar la lista a una lista de Tasks

  @override
  void initState() {
    super.initState();

    controller.getTasks().then((value) {
      setState(() {
        //_MenuAgregadas = value;
        //isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'LISTA DE MENUS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 70.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
                child: ListView.builder(
                  itemCount: _MenuAgregadas.length,
                  itemBuilder: (context, i) {
                    final Menu TaskAgregada = _MenuAgregadas[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesTaskPage(
                              task: TaskAgregada,
                              controller: controller,
                            ),
                          ),
                        );*/
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 170, 172, 174),
                            width: 3.0,
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Text(
                                'TAREA $currentIndex: ${TaskAgregada.title}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 30.0, // Ajusta el tamaño del texto
                                ),
                              ),*/
                              Row(
                                children: [
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                    /*  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTaskPage(task: TaskAgregada),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          TaskAgregada.title = value;
                                        });
                                      });*/
                                    },
                                  ),
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                    /*  _showDeleteConfirmationDialog(
                                          TaskAgregada);*/
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color.fromARGB(255, 170, 172, 174),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMenuForm()),
        );
         /* Navigator.push(
            context,
            MaterialPageRoute(
                /*builder: (context) => AgregarTaskPage(
                onTaskSaved: (task) {
                  // Ajusta el parámetro para que sea de tipo Task
                },
              ),*/
                ),
          ).then((value) {
            setState(() {
              _TasksAgregadas.add(value);
            });
          });*/
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
