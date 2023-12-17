// Example widget for a subtask item
import 'package:equalease_home/models/classroom.dart';
import 'package:equalease_home/models/kitchen_order.dart';
import 'package:equalease_home/models/menu.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:flutter/material.dart';

import '../models/subtask.dart';
import '../controllers/controller_api.dart';
bool _changed = false;

class MenuWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final String representation;
 

  const MenuWidget({Key? key, required this.order, required this.representation})
      : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  APIController controller = APIController();

  Menu menu = Menu(name:"",image: "",type:"");
  @override
  void initState() {
    super.initState();

    controller.getMenu(widget.order['menu']).then((value) {
      setState(() {
        menu = value;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            menu.name,
            style: TextStyle(fontSize: 60),
          ),
        ),
        // Image of the subtask
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menu.image != ''
                  ? Center(
                      child: Image.network(
                        menu.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              SizedBox(width: 40),
            ],
          ),
        ),
        // Add buttons or gestures to play audio and video if they are available
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (widget.order['quantity'] > 0) {
                    _changed = true;
                  setState(() {
                    
                    widget.order['quantity'] = widget.order['quantity'] - 1;
                  });
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 161, 182,
                      236), // Puedes cambiar el color según tus preferencias
                ),
                child: Center(
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),

            if (widget.representation == "text" || widget.representation =="audio")
              Text(
                '${widget.order['quantity']}',
                style: TextStyle(fontSize: 50),
              )
            else
          
              SizedBox(
                width: 100.0, // Ajusta el ancho deseado
                height: 100.0, // Ajusta la altura deseada
                child: Image.asset(
                  'assets/${widget.order['quantity']}.png', // Reemplaza con la ruta de tu imagen local
                  fit: BoxFit.cover, // Puedes ajustar el modo de ajuste según tus necesidades
                ),
              ),
        
              

            SizedBox(width: 16),
            InkWell(
              
              onTap: () {
              
                if(widget.order['quantity']+1<=10){
                  _changed = true;
                  setState(() {
                  
                   widget.order['quantity'] = widget.order['quantity'] + 1;
                  });
                }
                
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(255, 161, 182,
                      236), // Puedes cambiar el color según tus preferencias
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Main carousel widget
class MenuCarousel extends StatefulWidget {
  final Classroom classroom;
  final String teacherPic;
  bool quantityChanged = false;
  final String representation;

  MenuCarousel({Key? key, required this.classroom, required this.teacherPic, required this.representation}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MenuCarouselState(classroom: classroom);
  }
}

class _MenuCarouselState extends State<MenuCarousel> {
  int page = 0;
  final Classroom classroom;
  List<Subtask> subtasks = [];
  

  KitchenOrder kitchenOrder =
      KitchenOrder(classroom: "", revised: false, orders: [], date: "");

  final PageController pageController = PageController();
  APIController controller = APIController();

  _MenuCarouselState({required this.classroom});
  

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        page = pageController.page!.round();
      });
    });

    controller.getKitchenOrder(classroom.id!).then((value) {
      setState(() {
        kitchenOrder = value;
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
                if(widget.representation == "text" || widget.representation =="audio" )

                
                  Text(
                    'COMANDA DE LA CLASE ${classroom.letter}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          Colors.white, // Cambia el color de la fuente a blanco
                      fontWeight: FontWeight.bold, // Hace la fuente más gruesa
                      fontSize: 50.0, // Cambia el tamaño de la fuente
                    ),
                  )
                else
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset(
                            'assets/comida.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Image.asset(
                            'assets/clase${widget.classroom.letter.toUpperCase()}.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        child: Image.network(
                            widget.teacherPic,
                            width: 120.0,
                            height: 120.0,
                        ),
                      ),
                    ]
                  ),
              ],
            ),
          ),
       ),
          
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: kitchenOrder.id != ""
            ? Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      itemCount: kitchenOrder.orders.length,
                      itemBuilder: (context, index) {
                        return MenuWidget(
                            order: kitchenOrder.orders[index],
                            representation: widget.representation,  
                          );
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
                                if(_changed){
                                  _changed = false;
                                  controller.updateKitchenOrder(kitchenOrder);
                                }
                                if (pageController.page! > 0) {
                                  pageController.previousPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            )
                          : Container(),
                      page < kitchenOrder.orders.length - 1
                          ? IconButton(
                              icon: Icon(Icons.arrow_forward),
                              iconSize: 120,
                              onPressed: () {
                        
                                if(_changed){
                                  controller.updateKitchenOrder(kitchenOrder);
                                  _changed=false;
                                }
                                if (pageController.page! < kitchenOrder.orders.length - 1) {
                                  pageController.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.check),
                              iconSize: 120,
                              onPressed: () {
                                if(_changed){
                                  _changed = false;
                                  controller.updateKitchenOrder(kitchenOrder);
                                }
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        width:
                                            300.0, // Ajusta el ancho según tus necesidades
                                        height:
                                            200.0, // Ajusta la altura según tus necesidades
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '¿Deseas terminar la comanda?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20.0),
                                            ),
                                            SizedBox(height: 20.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    //Aqui se actualizaria el campo de finalizado
                                                    // Acciones si se presiona "OK"
                                                    Navigator.pop(
                                                        context); // Cierra el diálogo
                                                    Navigator.pop(
                                                        context); // Cierra la pantalla actual (MenuCarousel)
                                                  },
                                                  child: Text('Terminar',
                                                      style: TextStyle(
                                                          fontSize: 25.0,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0))),
                                                ),
                                                SizedBox(width: 20.0),
                                                TextButton(
                                                  onPressed: () {
                                                    // Acciones si se presiona "Cancelar"

                                                    Navigator.pop(
                                                        context); // Cierra el diálogo
                                                  },
                                                  child: Text('Cancelar',
                                                      style: TextStyle(
                                                          fontSize: 25.0,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ],
              )
            : Center(
                child: Text("No hay menú disponible"),
              ),
      ),
    );
  }
}
