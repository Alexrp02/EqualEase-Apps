import 'package:test/test.dart';

// Controllers
import 'package:api_integration/controllers/api_controller.dart';

// Models
import 'package:api_integration/models/student.dart';
import 'package:api_integration/models/teacher.dart';
import 'package:api_integration/models/subtask.dart';
import 'package:api_integration/models/task.dart';

void main() {
  final apiController = APIController(); // Crea una instancia de APIController.

  // Crea una instancia de APIController.
  print(apiController.baseUrl);
  // test('getStudents works fine', () async {
  //   final studentsList = await apiController.getStudents();

  //   print("Stop me here!");

  //   // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
  //   expect(studentsList, isNotNull);
  //   expect(studentsList, isNotEmpty);

  //   // Verifica si los elementos de la lista son instancias válidas de Student.
  //   for (var student in studentsList) {
  //     expect(student, isA<Student>());
  //   }
  // });

  // test('create a valid subtask', () async {
  //   // Prueba de crear una subtarea
  //   Subtask subtask = Subtask(
  //       id: 'invalid',
  //       title: 'leer libro',
  //       description: 'Esta es mi descripción.',
  //       image: '',
  //       pictogram: '',
  //       audio: '',
  //       video: '');

  //   try {
  //     var result = await apiController.createSubtask(subtask);
  //     print(result);
  //     print("Stop me here!!");
  //   } catch (e) {
  //     print(e);
  //   }
  // });
}
