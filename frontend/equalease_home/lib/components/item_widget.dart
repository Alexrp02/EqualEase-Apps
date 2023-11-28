// Example widget for a item
import 'package:flutter/material.dart';

import '../models/request.dart';
import '../models/item.dart';
import '../controllers/controller_api.dart';

class ItemWidget extends StatefulWidget {
  final Item item;

  const ItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
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
        Center(
            child: Text(
          "TE FALTAN: ${widget.item.quantity}",
          style: const TextStyle(fontSize: 60),
        )),
        Center(
            child: Text(
          widget.item.size,
          style: const TextStyle(fontSize: 40),
        )),
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

  ItemCarousel({Key? key, required this.studentId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemsCarouselState();
  }
}

class _ItemsCarouselState extends State<ItemCarousel> {
  int page = 0;
  late String studentId;
  List<Item> items = [];
  final PageController pageController = PageController();
  APIController controller = APIController();

  _ItemsCarouselState();

  @override
  void initState() {
    super.initState();
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
          title: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MATERIALES DE PEDIDO',
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
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  if (items.isEmpty) {
                    return Container();
                  } else {
                    return ItemWidget(item: items[index]);
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
                          if (items.isNotEmpty) {
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
