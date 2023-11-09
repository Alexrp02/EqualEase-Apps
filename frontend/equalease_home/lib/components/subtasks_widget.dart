// Example widget for a subtask item
import 'package:flutter/material.dart';

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
        Center(
            child: Container(
          height: 400,
          width: 400,
          child: Image.network(
            "https://api.arasaac.org/v1/pictograms/11299?download=false",
            fit: BoxFit.cover,
          ),
        )),
        // Add buttons or gestures to play audio and video if they are available
      ],
    );
  }
}

// Main carousel widget
class SubtasksCarousel extends StatefulWidget {
  final String taskId;

  SubtasksCarousel({Key? key, required this.taskId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubtasksCarouselState(taskId: taskId);
  }
}

class _SubtasksCarouselState extends State<SubtasksCarousel> {
  final String taskId;
  List<Subtask> subtasks = [];
  final PageController pageController = PageController();
  APIController controller = APIController();

  _SubtasksCarouselState({required this.taskId});

  @override
  void initState() {
    super.initState();
    controller.getSubtasksFromTaskList(taskId).then((value) {
      setState(() {
        subtasks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subtasks Carousel')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
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
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 200,
                onPressed: () {
                  if (pageController.page! > 0) {
                    pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 200,
                onPressed: () {
                  if (pageController.page! < subtasks.length - 1) {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ],
          ),
        ],
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
