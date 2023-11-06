// External packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// Project models
import 'package:api_integration/models/student.dart';
import 'package:api_integration/models/teacher.dart';

// class containing all operations with API
class APIController {
  final String baseUrl = 'http://localhost:3000/api';

  //-----------------------------------------------------------------------//
  /// Subtask operations

  // get subtask by id

  // create subtask

  // subtask put operation (private)

  // change title

  // change description

  // change other fields... (image, pictogram, audio, video)

  // subtask delete operation

  //-----------------------------------------------------------------------//
  /// Task operations

  // get task by id

  // task put operation (private)

  //-----------------------------------------------------------------------//
  /// Student operations

  // get student by id
  Future<Student> getStudent(String id) async {
    final String apiUrl =
        '$baseUrl/student/id/$id'; // Construye la URL específica para obtener un estudiante por ID.

    try {
      final response = await http.get(Uri.parse(
          apiUrl)); // Realiza una solicitud HTTP GET para obtener el estudiante.

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Student st = Student.fromJson(response.body);
        return st;
      } else {
        throw Exception(
            'Error al obtener el estudiante: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // get student(s) by name

  // get pending tasks from student (studentId)

  // get done tasks from student

  // student put operation (private)
  Future<bool> _updateStudent(String studentId, String jsonString) async {
    final String apiUrl = '$baseUrl/student/id/$studentId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonString, // El JSON en formato de cadena se envía directamente en el cuerpo de la solicitud.
      );

      if (response.statusCode == 200) {
        return true; // Devuelve true para indicar que la actualización se realizó con éxito.
      } else {
        throw Exception(
            'Error al actualizar el estudiante: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // student modify operations (they all generate a json, and then call _updateStudent. if the operation is succesfull, then return the new student updated, else return false)
  //  - mark a pending task as completed
  Future<dynamic> markTaskAsCompleted(String studentId, String taskId) async {
    // Obtiene el estudiante.
    Student student = await getStudent(studentId);

    // Modifica el array de pending tasks -> elimina la tarea con id = taskId.
    student.pendingTasks.remove(taskId);

    // Modifica el array de done tasks -> inserta el id de la tarea taskId.
    student.doneTasks.add(taskId);

    // Crea el JSON con las tareas actualizadas.
    Map<String, dynamic> requestJson = {
      "pendingTasks": student.pendingTasks,
      "doneTasks": student.doneTasks,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _updateStudent(studentId, json.encode(requestJson));

    return result;
  }

  // student delete operation (not implemented yet)
  Future<bool> deleteStudent(String studentId) async {
    final String apiUrl = '$baseUrl/student/id/$studentId';

    return true;
    // try {
    //   final response = await http.delete(Uri.parse(apiUrl));

    //   if (response.statusCode == 204) {
    //     return true; // Devuelve true para indicar que la eliminación fue exitosa.
    //   } else {
    //     throw Exception(
    //         'Error al eliminar el estudiante: ${response.reasonPhrase}');
    //   }
    // } catch (e) {
    //   throw Exception('Error de red: $e');
    // }
  }

  //-----------------------------------------------------------------------//
  /// Teacher operations

  // get teacher by id
  Future<Teacher> getTeacher(String id) async {
    final String apiUrl =
        '$baseUrl/teacher/id/$id'; // Construye la URL específica para obtener un estudiante por ID.

    try {
      final response = await http.get(Uri.parse(
          apiUrl)); // Realiza una solicitud HTTP GET para obtener el estudiante.

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Teacher teacher = Teacher.fromJson(response.body);
        return teacher;
      } else {
        throw Exception(
            'Error al obtener el profesor: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // get students from teacher's list (teacherId)
  Future<List<Student>> getStudentsFromTeacherList(String teacherId) async {
    try {
      // Obtener el profesor
      Teacher teacher = await getTeacher(teacherId);

      List<Student> studentsList = [];

      for (String studentId in teacher.students) {
        try {
          Student student = await getStudent(studentId);
          studentsList.add(student);
        } catch (e) {
          print('Error al obtener estudiante $studentId: $e');
          // Puedes optar por manejar el error de alguna otra manera
        }
      }

      return studentsList;
    } catch (e) {
      print('Error al obtener profesor $teacherId: $e');
      throw Exception(
          'No se pudo obtener la lista de estudiantes del profesor.');
    }
  }

  // create teacher

  // teacher modify operations
  //  - add student to teacher's list
  //  - remove student from teacher's list
  //  - change profilePicture

  //-----------------------------------------------------------------------//
  /// Other operations

  // assignig a task to a student (studentId, taskId)

  // ...
}
