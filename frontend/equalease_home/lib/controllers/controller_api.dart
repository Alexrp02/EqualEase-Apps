// External packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// Project models
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/models/teacher.dart';
import 'package:equalease_home/models/task.dart'; 
import 'package:equalease_home/models/subtask.dart';

// class containing all operations with API
class APIController {
  //final String baseUrl = 'http://localhost:3000/api';
  final String baseUrl = "http://10.0.2.2:3000/api";
  //-----------------------------------------------------------------------//
  /// Subtask operations

  // get subtask by id
  Future<Subtask> getSubtask(String id) async {
    final String apiUrl = '$baseUrl/subtask/id/$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Subtask st = Subtask.fromJson(response.body);
        return st;
      } else {
        throw Exception(
            'Error al obtener la subtarea con id $id: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // get all subtasks
  Future<List<Subtask>> getSubtasks() async {
    final String apiUrl = '$baseUrl/subtask';

    try {
      List<Subtask> subtasks = [];
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        final List<dynamic> list = json.decode(response.body);
        for (var element in list) {
          subtasks.add(Subtask.fromMap(element));
        }
      } else {
        throw Exception('Error al obtener subtareas: ${response.statusCode}');
      }

      return subtasks;
    } catch (e) {
      print('Error al obtener todas las subtareas: $e');
      throw Exception('No se pudo obtener la lista de subtareas del sistema');
    }
  }

  // create subtask
  Future<bool> createSubtask(Subtask subtask) async {
    final String apiUrl = '$baseUrl/subtask';

    // Necesitamos convertir el objeto a JSON pero sin su id
    Map<String, dynamic> mapBody = {
      'title': subtask.title,
      'description': subtask.description,
      'image': subtask.image,
      'pictogram': subtask.pictogram,
      'audio': subtask.audio,
      'video': subtask.video
    };

    // Convertimos a string (formato JSON)
    String jsonBody = json.encode(mapBody);

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      if (response.statusCode == 201) {
        // La solicitud POST fue exitosa.
        // La respuesta incluye los datos de la tarea recién creada,
        // Tenemos que extraer de esta el id y asignarselo al objeto parámetro
        // Como en dart los parametros se pasan por referencia, los cambios perdurarán.
        final body = json.decode(response.body);
        subtask.id = body['id'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // subtask put operation (private)
  Future<bool> _updateSubtask(String subtaskId, String jsonString) async {
    final String apiUrl = '$baseUrl/subtask/id/$subtaskId';

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
            'Error al actualizar la subtarea: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // change title
  Future<dynamic> changeSubtaskTitle(String subtaskId, String title) async {
    // Crea el JSON con el cuerpo de la petición.
    Map<String, dynamic> requestJson = {
      "title": title,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _updateSubtask(subtaskId, json.encode(requestJson));

    return result;
  }

  // change description
  Future<dynamic> changeSubtaskDescription(
      String subtaskId, String description) async {
    // Crea el JSON con el cuerpo de la petición.
    Map<String, dynamic> requestJson = {
      "description": description,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _updateSubtask(subtaskId, json.encode(requestJson));

    return result;
  }

  // change other fields... (image, pictogram, audio, video)
  // ...

  // subtask delete operation
  Future<bool> deleteSubtask(String subtaskId) async {
    final String apiUrl = '$baseUrl/subtask/id/$subtaskId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        return true; // Devuelve true para indicar que la eliminación fue exitosa.
      } else {
        return false; // Devuelve false para indicar que la eliminación falló.
      }
    } catch (e) {
      return false; // Devuelve false en caso de error de red.
    }
  }

  //-----------------------------------------------------------------------//
  /// Task operations

  // get task by id
  Future<Task> getTask(String id) async {
    final String apiUrl = '$baseUrl/task/id/$id';

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

  // get all tasks
  Future<List<Task>> getTasks() async {
    final String apiUrl = '$baseUrl/task';

    try {
      List<Task> tasks = [];
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        final List<dynamic> jsonTasks = json.decode(response.body);
        for (var jsonTask in jsonTasks) {
          tasks.add(Task.fromMap(jsonTask));
        }
      } else {
        throw Exception('Error al obtener tareas: ${response.statusCode}');
      }

      return tasks;
    } catch (e) {
      print('Error al obtener todas las tareas: $e');
      throw Exception('No se pudo obtener la lista de tareas del sistema');
    }
  }

  // create task
  Future<void> createTask(Task task) async {
  var url = Uri.parse("$baseUrl/api/task");

  // Convierte el objeto Subtask a una cadena JSON (sin meter el id).
  String jsonBody = task.toJson();

  // Petición tipo post
  var response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonBody,
  );

  if (response.statusCode == 201) {
    // La solicitud POST fue exitosa.
    print("task creada con éxito.");
    // La respuesta incluye los datos de la tarea recién creada,
    // Tenemos que extraer de esta el id y asignarselo al objeto parámetro
    // Como en dart los parametros se pasan por referencia, los cambios perdurarán.
    final body = json.decode(response.body);
    // print('id: ${body['id']}');
    task.id = body['id'];
    // print('subtask.id (createSubtask): ${subtask.id}');
  } else {
    // Manejar errores u otra lógica en caso de que la solicitud no sea exitosa.
    print("Error al crear la task [${response.statusCode}: ${response.body}]");
  }
}

  // get subtasks from task list (taskId)
  Future<List<Subtask>> getSubtasksFromTaskList(String taskId) async {
    try {
      // Obtener task
      Task task = await getTask(taskId);

      List<Subtask> subtaskList = [];

      for (String subtaskId in task.subtasks) {
        try {
          Subtask subtask = await getSubtask(subtaskId);
          subtaskList.add(subtask);
        } catch (e) {
          print('Error al obtener subtarea $subtaskId: $e');
        }
      }

      return subtaskList;
    } catch (e) {
      print('Error al obtener tarea con id $taskId: $e');
      throw Exception(
          'No se pudo obtener la lista de subtareas de la tarea con id $taskId.');
    }
  }

  // task put operation (private)
  Future<bool> _updateTask(String taskId, String jsonString) async {
    final String apiUrl = '$baseUrl/task/id/$taskId';

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
            'Error al actualizar la tarea: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // add subtask to task list

  // remove subtask from task list

  // change task title (taskId)
  Future<dynamic> changeTaskTitle(String taskId, String title) async {
    // Crea el JSON con el cuerpo de la petición.
    Map<String, dynamic> requestJson = {
      "title": title,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _updateTask(taskId, json.encode(requestJson));

    return result;
  }

  // change task description (taskId)
  Future<dynamic> changeTaskDescription(
      String taskId, String description) async {
    // Crea el JSON con el cuerpo de la petición.
    Map<String, dynamic> requestJson = {
      "description": description,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _updateTask(taskId, json.encode(requestJson));

    return result;
  }

  // change other fields/media (taskId)
  // ...

  // delete task operation
  Future<bool> deleteTask(String taskId) async {
    final String apiUrl = '$baseUrl/task/id/$taskId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        return true; // Devuelve true para indicar que la eliminación fue exitosa.
      } else {
        return false; // Devuelve false para indicar que la eliminación falló.
      }
    } catch (e) {
      return false; // Devuelve false en caso de error de red.
    }
  }

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

  // get done tasks from student (studentId)
  Future<List<Task>> getDoneTasksFromStudent(String studentId) async {
    try {
      // Obtener student
      Student student = await getStudent(studentId);

      List<Task> list = [];

      for (String taskId in student.doneTasks) {
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
          'No se pudo obtener la lista de tareas completadas del estudiante con id $studentId.');
    }
  }

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
  //  mark a pending task as completed
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

  // assigning a task to a student (studentId, taskId)
  Future<dynamic> assignTaskToStudent(String studentId, String taskId) async {
    // Obtiene el estudiante.
    Student student = await getStudent(studentId);

    if (student == null) {
      throw Exception('Student not found');
    }

    // Verifica si la tarea existe.
    Task task = await getTask(taskId);
    if (task == null) {
      throw Exception('Task not found');
    }

    // Verifica si la tarea ya está en las tareas pendientes del estudiante.
    if (!student.pendingTasks.contains(taskId)) {
      // Agrega la tarea solo si no está en la lista.
      student.pendingTasks.add(taskId);

      // Crea el JSON con las tareas actualizadas.
      Map<String, dynamic> requestJson = {
        "pendingTasks": student.pendingTasks,
      };

      // Realiza la operación de actualización en la BD
      var result = await _updateStudent(studentId, json.encode(requestJson));

      return result;
    } else {
      throw Exception('Task is already assigned to the student');
    }
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

  // teacher put operation (private)
  Future<bool> _updateTeacher(String teacherId, String jsonString) async {
    final String apiUrl = '$baseUrl/teacher/id/$teacherId';

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
            'Error al actualizar el profesor: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // teacher modify operations
  //  - add student to teacher's list
  //  - remove student from teacher's list
  //  - change profilePicture

  //-----------------------------------------------------------------------//
  /// Other operations

  // ...
}
