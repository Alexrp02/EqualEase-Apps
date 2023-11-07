// Example widget for a subtask item
import 'package:flutter/material.dart';

import '../models/subtask.dart';

class SubtaskWidget extends StatelessWidget {
  final Subtask subtask;

  const SubtaskWidget({Key? key, required this.subtask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add Audio and Video players based on the URLs
        Center(child: Text(subtask.title)),
        Center(child: Text(subtask.description)),
        // Add buttons or gestures to play audio and video if they are available
      ],
    );
  }
}

// Main carousel widget
class SubtasksCarousel extends StatelessWidget {
  final List<Subtask> subtasks;
  final PageController pageController = PageController();

  SubtasksCarousel({Key? key, required this.subtasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
    ));
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Subtasks Carousel')),
      body: SubtasksCarousel(
        subtasks: [
          Subtask(
              id: "nothing",
              title: 'Subtask 1',
              description: 'Description of subtask 1'),
          // Add more subtasks here
        ],
      ),
    ),
  ));
}
