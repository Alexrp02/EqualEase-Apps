// Example widget for a subtask item
import 'package:equalease_home/models/classroom.dart';
import 'package:equalease_home/models/menu.dart';
import 'package:flutter/material.dart';

import '../models/subtask.dart';
import '../controllers/controller_api.dart';

class MenuWidget extends StatelessWidget {
  final Map<String,dynamic> order;
  final Menu menu;
  final int quantity;

  const MenuWidget({Key? key, required this.menu, required this.quantity, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          menu.name,
          style: TextStyle(fontSize: 60),
        )),
        Center(
            child: Text(
          "subtask.description",
          style: TextStyle(fontSize: 40),
        )),
        // Image of the subtask
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // subtask.image != ''
              //     ? Center(
              //         child: Image.network(
              //           subtask.image,
              //           fit: BoxFit.cover,
              //         ),
              //       )
              //     : Container(),
              // SizedBox(width: 40),
              // subtask.pictogram != ''
              //     ? Center(
              //         child: Image.network(
              //           subtask.pictogram,
              //           fit: BoxFit.cover,
              //         ),
              //       )
              //     : Container(),
            ],
          ),
        ),
        // Add buttons or gestures to play audio and video if they are available
      ],
    );
  }
}

// Main carousel widget
class MenuCarousel extends StatefulWidget {
  final String taskId;
  final Classroom classroom;

  MenuCarousel({Key? key, required this.taskId, required this.classroom}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuCarouselState(taskId: taskId, classroom: classroom);
  }
}

class _MenuCarouselState extends State<MenuCarousel> {
  int page = 0;
  final String taskId;
  final Classroom classroom;
  List<Subtask> subtasks = [];
  List<Map<String, dynamic>> orders = [];
  
  final PageController pageController = PageController();
  APIController controller = APIController();

  _MenuCarouselState({required this.taskId, required this.classroom});

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        page = pageController.page!.round();
      });
    });
    controller.getSubtasksFromTaskList(taskId).then((value) {
      setState(() {
        subtasks = value;
      });
    });

    controller.getKitchenOrder(classroom.id!).then((value){
      setState((){
        orders = value.orders;
      });
    });

    
  }

  @override
  void dispose() {
    pageController.removeListener(() {});
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          toolbarHeight: 100.0,
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
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
                  'COMANDA DE LA CLASE ${classroom.letter}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        Colors.white, // Cambia el color de la fuente a blanco
                    fontWeight: FontWeight.bold, // Hace la fuente más gruesa
                    fontSize: 50.0, // Cambia el tamaño de la fuente
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: orders.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return MenuWidget(order: orders[index]);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      page > 0
                          ? IconButton(
                              icon: Icon(Icons.arrow_back),
                              iconSize: 120,
                              onPressed: () {
                                if (pageController.page! > 0) {
                                  pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            )
                          : Container(),
                      page < subtasks.length - 1
                          ? IconButton(
                              icon: Icon(Icons.arrow_forward),
                              iconSize: 120,
                              onPressed: () {
                                if (pageController.page! < subtasks.length - 1) {
                                  pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                ],
              )
            : Center(
                child: Text("No hay menú disponible"),
              ),
      )
      ,
    );
  }
}

