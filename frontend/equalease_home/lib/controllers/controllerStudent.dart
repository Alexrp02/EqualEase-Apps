import 'package:equalease_home/models/subtask.dart';
import 'package:equalease_home/models/task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equalease_home/models/student.dart';

class ControllerStudent {
  String _apiUrl;

  ControllerStudent(this._apiUrl);

  /// Obtiene de la API el estudiante con el identificador especificado
  ///
  /// Parámetros:
  ///  -[id]: String que representa el identificador del estudiante
  ///
  /// Return:
  ///  -Lanza un error si no puede conectar con la API
  ///  -Estudiante del tipo Student (en caso de que exista)
  
  Future<Student> getStudent(String id) async {
    final String apiUrl =
        '$_apiUrl/student/id/$id'; // Construye la URL específica para obtener un estudiante por ID.

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

  /// Obtiene de la API todos los estudiantes
  ///
  /// Return:
  ///  -Lanza un error si no puede conectar con la API
  ///  -Lista de estudiantes almacenados del tipo Future<List<Student>> (en caso de que exista)
  ///
  Future<List<Student>> getStudents() async {
    final String apiUrl =
        '$_apiUrl/student'; // Construye la URL específica para obtener un estudiante por ID.
    
    List<Student> students = [];
    final response = await http.get(Uri.parse(apiUrl));
    
    if (response.statusCode == 200) {
      // Analizar la respuesta JSON
      final List<dynamic> list = json.decode(response.body);
      for (var element in list) {
        students.add(Student.fromMap(element));
      }
    } else {
      throw Exception(
          'Error al obtener los estudiantes: ${response.statusCode}');
    }

    return students;
  }
  //Temporal
  Future<Task> getTask(String id) async {
    final String apiUrl = '$_apiUrl/task/id/$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Task task = Task.fromJson(response.body);
        return task;
      } else {
        throw Exception(
            'Error al obtener la tarea con id $id: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  /// Obtiene las tareas pendientes asignadas a un estudiante
  ///
  /// Return:
  ///  -Lanza un error si no puede conectar con la API
  ///  -Lista de estudiantes almacenados del tipo Future<List<Student>> (en caso de que exista)
  ///
  Future<List<Task>> getPendingTasksFromStudent(String studentId) async {
      try {
        // Obtener student
        Student student = await getStudent(studentId);

        List<Task> list = [];

        
        for (String taskId in student.pendingTasks) {
          try {
            Task task = await getTask(taskId);
            list.add(task);
          } catch (e) {
            print('Error al obtener la tarea $taskId: $e');
          }

        }
        
        return list;
      } catch (e) {
        print('Error al obtener el estudiante con id $studentId: $e');
        throw Exception(
            'No se pudo obtener la lista de tareas pendientes del estudiante con id $studentId.');
      }
  }
}