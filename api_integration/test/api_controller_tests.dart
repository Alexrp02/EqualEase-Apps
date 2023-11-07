import 'package:test/test.dart';

// Controllers
import 'package:api_integration/controllers/api_controller.dart';

// Models
import 'package:api_integration/models/student.dart';
import 'package:api_integration/models/teacher.dart';

void main() {
  final apiController = APIController(); // Crea una instancia de APIController.

  // test('getStudent returns a valid Student object', () async {
  //   final studentId = 'AOe1OeoaREbyyI5s5HW8';

  //   final student = await apiController.getStudent(studentId);

  //   // Verifica si el resultado es una instancia válida de Student.
  //   expect(student, isA<Student>());
  //   expect(student.id, studentId);
  //   expect(student.name, "Marta");
  // });

  // test('student mark task as completed test', () async {
  //   final studentId = 'AOe1OeoaREbyyI5s5HW8';

  //   var student = await apiController.getStudent(studentId);

  //   print("Stop me here to check variables!");

  //   final completedTaskId = "opqrst";

  //   var result =
  //       await apiController.markTaskAsCompleted(studentId, completedTaskId);

  //   print(result);

  //   if (result) {
  //     student = await apiController.getStudent(studentId);
  //   }

  //   print("Stop me here to check variables!");

  //   expect(student.pendingTasks.contains(completedTaskId), false);
  //   expect(student.doneTasks.contains(completedTaskId), true);
  // });

  // test('getTeacher returns a valid Teacher object', () async {
  //   final teacherId = 'qr1R8TuRGO5TlmICuxpt';

  //   final teacher = await apiController.getTeacher(teacherId);

  //   print("Stop me here!");

  //   // Verifica si el resultado es una instancia válida de Student.
  //   expect(teacher, isA<Teacher>());
  //   expect(teacher.id, teacherId);
  //   expect(teacher.name, "Alicia");
  // });

  test('getStudentsFromTeacherList works fine', () async {
    final teacherId = 'qr1R8TuRGO5TlmICuxpt';

    final studentsList =
        await apiController.getStudentsFromTeacherList(teacherId);

    print("Stop me here!");

    // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
    expect(studentsList, isNotNull);
    expect(studentsList, isNotEmpty);

    // Verifica si los elementos de la lista son instancias válidas de Student.
    for (var student in studentsList) {
      expect(student, isA<Student>());
    }
  });
}
