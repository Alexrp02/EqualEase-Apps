// Example widget for a item
import 'package:flutter/material.dart';
import '../models/classroom.dart';
import '../models/teacher.dart';
import '../models/student.dart';
import '../models/item.dart';
import '../controllers/controller_api.dart';

class ItemWidget extends StatefulWidget {
  final Item item;
  final String representation;

  const ItemWidget({Key? key, required this.item, required this.representation}) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool debug = false;
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          widget.item.name,
          style: const TextStyle(fontSize: 60),
        )),

        if(widget.representation == "text" || widget.representation == "audio")
          Center(
              child:Text(
            "TE FALTAN: ${widget.item.quantity}",
            style: const TextStyle(fontSize: 60),
          ))
        
        else

          SizedBox(
            height: 100,
             width: 100,
             child: Semantics(
              label: "Pictogtrama representando el número de items. ${widget.item.quantity}",
              child: Image.asset('assets/${widget.item.quantity}.png',
              fit: BoxFit.cover,),
              )
            ),
          
        if(widget.representation == "text" || widget.representation == "audio")
          Center(
              child: Text(
          widget.item.size,
          style: const TextStyle(fontSize: 40),
        ))
        
        else

          SizedBox(
            height: 100,
             width: 100,
             child: Semantics(
              label: "Pictogtrama representando el tamaño del items. ${widget.item.size}",
              child: Image.asset('assets/${widget.item.size}.png',
              fit: BoxFit.cover,),
              )
            ),

        // Image of the subtask
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.item.pictogram != ''
                  ? Center(
                      child: Image.network(
                        widget.item.pictogram,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container()
                  
            ],
          ),
        ),
      ],
    );
  }
}

// Main carousel widget
class ItemCarousel extends StatefulWidget {
  final String studentId;
  final Classroom classroom;
  final String teacherPic;
  bool quantityChanged = false;
  final String representation;
  final Student student;

  ItemCarousel({Key? key, required this.studentId,required this.student, required this.representation, required this.classroom, required this.teacherPic}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemsCarouselState(classroom: classroom);
  }
}

class _ItemsCarouselState extends State<ItemCarousel> {
  int page = 0;
  final Classroom classroom;
  late String studentId;
  List<Item> items = [];
  Teacher teacher = Teacher(email:"",id:"",isAdmin:false,name:"",profilePicture: "",surname: "",students: []);  
  final PageController pageController = PageController();
  APIController controller = APIController();
  bool changed = false;

  _ItemsCarouselState({required this.classroom});

  @override
  void initState() {
    super.initState();

    String audioInstructions;
     if(widget.student.representation=="audio"){
      audioInstructions="Estás en la clase ${widget.classroom.letter} ."+
     "Para añadir un objeto al pedido pulsa sobre el botón más."+
     "Para quitar un objeto al pedido pulsa sobre el botón menos."+
     "Para pasar al siguiente objeto del pedido pulsa sobre la flecha de avanzar."+
     "Para retroceder al objeto anterior del pedido pulsa sobre la flecha de retroceder en la esquina inferior izquierda.";
     }else{
      audioInstructions="Estás en la clase ${widget.classroom.letter}.";
     }

      controller.speak(audioInstructions);

    pageController.addListener(() {
      setState(() {
        page = pageController.page!.round();
      });
    });

    studentId = widget.studentId;
    controller.getItemsFromStudentRequest(studentId).then((value) {
      setState(() {
        items = value;
      });
    });

    controller.getTeacher(widget.classroom.assignedTeacher).then((value){
      setState(() {
        teacher = value;
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
                if(widget.representation == "text" || widget.representation == "audio")
                  Text(
                    'MATERIALES DE PEDIDO}',
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
                            child: Semantics(
                              label: "Pictograma de comanda",
                              child:Image.asset(
                                'assets/materialEscolar.png',
                                fit: BoxFit.cover,
                              ),
                          )
                        ),
                      ),
                      Container(
                        child: SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Semantics(
                            label: "Pictograma de la clase ${widget.classroom.letter}.",
                            child:Image.asset(
                              'assets/clase${widget.classroom.letter.toUpperCase()}.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                      ),
                      Container(
                        child: Semantics(
                          label: "Foto de perfil de ${teacher.name}",
                          child:Image.network(
                              widget.teacherPic,
                              width: 120.0,
                              height: 120.0,
                          ),
                        )
                      ),
                    ]
                  ),
              ],
            ),
          ),
          actions: [
            ClipOval(
              child: Container(
                color: const Color.fromARGB(107, 255, 255, 255),
                child: Semantics(
                  label: "Foto de perfil de  ${widget.student.name}",
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
 
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (items.isEmpty) {
                    return Container();
                  } else {
                    return ItemWidget(item: items[index], representation: widget.representation,);
                  }
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
                            if (changed) {
                              changed = false;
                              // Update the Item in the database if the item changed
                              controller
                                  .updateItem(items[page])
                                  .then((value) => {
                                        if (value)
                                          {print("Item updated")}
                                        else
                                          {print("Item not updated")}
                                      });
                            }
                            pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      )
                    : Container(
                        width: 136,
                      ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 60,
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (items.isNotEmpty && items[page].quantity > 0) {
                            changed = true;
                            setState(() {
                              items[page].quantity--;
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 64.0),
                      Transform.scale(
                        scale: 4,
                        child: Checkbox(
                          value: items.isNotEmpty && items[page].quantity == 0,
                          onChanged: null,
                        ),
                      ),
                      const SizedBox(width: 64.0),
                      IconButton(
                        iconSize: 60,
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (items.isNotEmpty && items[page].quantity < 10) {
                            changed = true;
                            setState(() {
                              items[page].quantity++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                page < items.length - 1
                    ? IconButton(
                        icon: Icon(Icons.arrow_forward),
                        iconSize: 120,
                        onPressed: () {
                          if (changed) {
                            changed = false;
                            // Update the Item in the database if the item changed
                            controller.updateItem(items[page]).then((value) => {
                                  if (value)
                                    {print("Item updated")}
                                  else
                                    {print("Item not updated")}
                                });
                          }
                          if (pageController.page! < items.length - 1) {
                            pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      )
                    : Container(
                        width: 136,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(title: Text('Subtasks Carousel')),
//       body: SubtasksCarousel(
//         subtasks: [
//           Subtask(
//               id: "nothing",
//               title: 'Subtask 1',
//               description: 'Description of subtask 1',
//               image: '',
//               pictogram: '',
//               audio: '',
//               video: ''),
//           // Add more subtasks here
//         ],
//       ),
//     ),
//   ));
// }
