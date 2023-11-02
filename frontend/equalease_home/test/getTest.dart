import 'package:equalease_home/controllers/controllerSubstask.dart';
import 'package:equalease_home/controllers/controllerTask.dart';
import 'package:equalease_home/models/subtask.dart';


void main() {
  testPrintHelloWorld();
}

void testPrintHelloWorld() async{
  print("Hola mundo");


Subtask? subtaskById;
  try {
    subtaskById = await getSubtaskByTitle("Ver la Champions");
  } catch (e) {
    print(e);
  }

  // Puedes utilizar 'subtask' fuera del bloque try
  if (subtaskById != null) {
    // Realizar acciones con 'subtask' aquí
    print(subtaskById.id);
    print(subtaskById.title);
  }
}