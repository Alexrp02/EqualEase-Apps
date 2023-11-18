import 'package:test/test.dart';

// Controllers
import 'package:api_integration/controllers/controller_api.dart';

// Models
import 'package:api_integration/models/student.dart';
import 'package:api_integration/models/teacher.dart';
import 'package:api_integration/models/subtask.dart';
import 'package:api_integration/models/task.dart';

void main() {
  final apiController = APIController(); // Crea una instancia de APIController.

  test('getTasks works fine', () async {
    final list = await apiController.getTasks();

    // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
    expect(list, isNotNull);
    expect(list, isNotEmpty);

    // Verifica si los elementos de la lista son instancias válidas de Student.
    for (var element in list) {
      expect(element, isA<Task>());
    }
  });
}
