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

  group(
      "API controller get operations",
      () => {
            test('getStudent returns a valid Student object', () async {
              final studentId = 'AOe1OeoaREbyyI5s5HW8';

              final student = await apiController.getStudent(studentId);

              // Verifica si el resultado es una instancia válida de Student.
              expect(student, isA<Student>());
              expect(student.id, studentId);
              expect(student.name, "Marta");
            }),
            test('getTeacher returns a valid Teacher object', () async {
              final teacherId = 'qr1R8TuRGO5TlmICuxpt';

              final teacher = await apiController.getTeacher(teacherId);

              print("Stop me here!");

              // Verifica si el resultado es una instancia válida de Student.
              expect(teacher, isA<Teacher>());
              expect(teacher.id, teacherId);
              expect(teacher.name, "Alicia");
            }),
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
            }),
            test('getTask works correctly', () async {
              final id = 'OEteTVKogQSqYFTJpw5p';

              final task = await apiController.getTask(id);

              print('Stop me here');

              // Verifica si el resultado es una instancia válida de Student.
              expect(task, isA<Task>());
              expect(task.id, id);
              expect(task.title, "VER EL FUTBOL");
              expect(task.type, "FixedType");
            }),
            test('getTasks works fine', () async {
              final list = await apiController.getTasks();

              print("Stop me here!");

              // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
              expect(list, isNotNull);
              expect(list, isNotEmpty);

              // Verifica si los elementos de la lista son instancias válidas de Student.
              for (var element in list) {
                expect(element, isA<Task>());
              }
            }),
            test('getSubtask works correctly', () async {
              final id = '2KctyeXEVQd0sQfnxNbu';

              final subtask = await apiController.getSubtask(id);

              print('Stop me here');

              // Verifica si el resultado es una instancia válida de Student.
              expect(subtask, isA<Subtask>());
              expect(subtask.id, id);
              expect(subtask.title, "COGER MANDO");
            }),
            test('getSubtasks works fine', () async {
              final list = await apiController.getSubtasks();

              print("Stop me here!");

              // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
              expect(list, isNotNull);
              expect(list, isNotEmpty);

              // Verifica si los elementos de la lista son instancias válidas de Student.
              for (var element in list) {
                expect(element, isA<Subtask>());
              }
            }),
            test('getSubtasksFromTaskList works fine', () async {
              final taskId = 'OEteTVKogQSqYFTJpw5p';

              final list = await apiController.getSubtasksFromTaskList(taskId);

              print("Stop me here!");

              // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
              expect(list, isNotNull);
              expect(list, isNotEmpty);

              // Verifica si los elementos de la lista son instancias válidas de Student.
              for (var element in list) {
                expect(element, isA<Subtask>());
              }
            }),
            test('getPendingTasksFromStudent works fine', () async {
              final studentId = 'BzeOSKjQKDhh2Da3JHYC';

              final list =
                  await apiController.getPendingTasksFromStudent(studentId);

              print("Stop me here!");

              // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
              expect(list, isNotNull);
              expect(list, isNotEmpty);

              // Verifica si los elementos de la lista son instancias válidas de Student.
              for (var element in list) {
                expect(element, isA<Task>());
              }
            }),
            test('getDoneTasksFromStudent works fine', () async {
              final studentId = 'BzeOSKjQKDhh2Da3JHYC';

              final list =
                  await apiController.getDoneTasksFromStudent(studentId);

              print("Stop me here!");

              // Asegúrate de que la lista de estudiantes no sea nula y que contenga al menos un estudiante.
              expect(list, isNotNull);
              expect(list, isNotEmpty);

              // Verifica si los elementos de la lista son instancias válidas de Student.
              for (var element in list) {
                expect(element, isA<Task>());
              }
            })
          });

  group(
      "API controller put operations",
      () => {
            test('student mark task as completed test', () async {
              final studentId = 'AOe1OeoaREbyyI5s5HW8';

              var student = await apiController.getStudent(studentId);

              print("Stop me here to check variables!");

              final completedTaskId = "opqrst";

              var result = await apiController.markTaskAsCompleted(
                  studentId, completedTaskId);

              print(result);

              if (result) {
                student = await apiController.getStudent(studentId);
              }

              print("Stop me here to check variables!");

              expect(student.pendingTasks.contains(completedTaskId), false);
              expect(student.doneTasks.contains(completedTaskId), true);
            }),
            test('assign task to student', () async {
              // Comprobar casos de error
              final studentId = 'AOe1OeoaREbyyI5s5HW8';

              final taskId = "xIr34RJdf4uO4lXCLsbP";

              var result =
                  await apiController.assignTaskToStudent(studentId, taskId);

              print(result);

              Student student = await apiController.getStudent(studentId);

              print("Stop me here to check variables!");

              expect(student.pendingTasks.contains(taskId), false);
              expect(student.doneTasks.contains(taskId), true);
            }),
          });

  group("API controller post operations", () => {});

  group("API controller delete operations", () => {});
}
