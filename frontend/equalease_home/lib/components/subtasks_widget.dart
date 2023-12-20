// Example widget for a subtask item
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../models/subtask.dart';
import '../controllers/controller_api.dart';

class SubtaskWidget extends StatelessWidget {
  final Subtask subtask;

  const SubtaskWidget({Key? key, required this.subtask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          subtask.title,
          style: TextStyle(fontSize: 60),
        )),
        Center(
            child: Text(
          subtask.description,
          style: TextStyle(fontSize: 40),
        )),
        // Image of the subtask
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              subtask.image != ''
                  ? Center(
                      child: Image.network(
                        subtask.image,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              SizedBox(width: 40),
              subtask.pictogram != ''
                  ? Center(
                      child: Image.network(
                        subtask.pictogram,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        // Add buttons or gestures to play audio and video if they are available
      ],
    );
  }
}

// Main carousel widget
class SubtasksCarousel extends StatefulWidget {
  final String taskId;
  final Student student;

  const SubtasksCarousel(
      {Key? key, required this.taskId, required this.student})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubtasksCarouselState(taskId: taskId);
  }
}

class _SubtasksCarouselState extends State<SubtasksCarousel> {
  int page = 0;
  final String taskId;
  List<Subtask> subtasks = [];
  final PageController pageController = PageController();
  APIController controller = APIController();

  _SubtasksCarouselState({required this.taskId});

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
                  'PASOS PARA REALIZAR LA TAREA',
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
        padding: const EdgeInsets.only(top: 32.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                itemCount: subtasks.length,
                itemBuilder: (context, index) {
                  return SubtaskWidget(subtask: subtasks[index]);
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
                Expanded(
                  child: GFProgressBar(
                      percentage: (page + 1) / subtasks.length,
                      backgroundColor: Colors.black26,
                      lineHeight: 50,
                      progressBarColor: GFColors.SUCCESS),
                ),
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
                    : Container(width: 136),
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
