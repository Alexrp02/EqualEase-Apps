import 'package:equalease_home/controllers/controllerSubstask.dart';
import 'package:equalease_home/controllers/controllerTask.dart';
import 'package:equalease_home/models/subtask.dart';


void main() {
  testPrintHelloWorld();
}

void testPrintHelloWorld() async{
  print("Hola mundo");


Subtask subtaskPOST = Subtask(
    id: 'invalid',
    title: 'tarea creada en DART nueva!!',
    description:
        'tarea creada en DART, para volver a crear una nueva cambia el titulo.',
  );

  // print('subtask.id (in main before createSubtask): ${subtaskPOST.id}');
  try {
    await createSubtask(subtaskPOST);
    // print('subtask.id (in main after createSubtask): ${subtaskPOST.id}');
  } catch (e) {
    print(e);
  }

}