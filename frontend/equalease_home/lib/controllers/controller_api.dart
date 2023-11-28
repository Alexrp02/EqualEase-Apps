// External packages
import 'package:http/http.dart' as http;
import 'dart:convert';

// Project models
import '../models/classroom.dart';
import '../models/kitchen_order.dart';
import '../models/menu.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/subtask.dart';
import '../models/task.dart';
import '../models/item.dart';
import '../models/request.dart';

/// class containing all operations with API
class APIController {
  // String baseUrl = 'http://localhost:3000/api';
  String baseUrl = "http://10.0.2.2:3000/api";

  //-----------------------------------------------------------------------//
  //Subtask operations

  /// Get subtask by identifier from the database
  ///
  /// Params:
  ///
  ///   -[id]: subtask identifier
  ///
  /// Returns: subtask
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Get all subtasks from the database
  ///
  /// Returns: List of subtasks
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Create subtask and save it in the database
  ///
  /// Params:
  ///
  ///   -[subtask]: Object of type Subtask that is going to be saved
  ///
  /// Returns: String with the subtask identifier if the action was done
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<String> createSubtask(Subtask subtask) async {
    final String apiUrl = '$baseUrl/subtask';

    // Necesitamos convertir el objeto a JSON pero sin su id
    String jsonBody = subtask.toJsonWithoutId();

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
        return subtask.id;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  /// Private method for updating a subtask
  ///
  /// Params:
  ///
  ///   -[subtaskId]: subtask identifier
  ///
  ///   -[jsonString]: subtask in json format
  ///
  /// Returns: Boolean
  ///
  ///   - true if the action has been done
  ///
  ///   - false if the action failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> _putSubtask(String subtaskId, String jsonString) async {
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
        print('Error al actualizar la subtarea: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  /// Public method for updating a subtask in the database
  ///
  /// Params:
  ///
  ///   -[subtask]: Object of type subtask
  ///
  /// Returns: Boolean depending of the result of the _putSubtask action

  Future<bool> updateSubtask(Subtask subtask) async {
    // Crea el JSON con las tareas actualizadas.
    var requestJson = subtask.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putSubtask(subtask.id, requestJson);
    return result;
  }

  /// Delete subtask from the database
  ///
  /// Params:
  ///
  ///   -[subtaskId]: Subtask identifier
  ///
  /// Returns: Boolean depending of the result of the _putSubtask action
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API

  Future<bool> deleteSubtask(String subtaskId) async {
    final String apiUrl = '$baseUrl/subtask/id/$subtaskId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('subtareas eliminadas correctamente');
        return true; // Devuelve true para indicar que la eliminación fue exitosa.
      } else {
        return false; // Devuelve false para indicar que la eliminación falló.
      }
    } catch (e) {
      return false; // Devuelve false en caso de error de red.
    }
  }

  //-----------------------------------------------------------------------//
  // Task operations

  /// Get task by identifier from the database
  ///
  /// Params:
  ///
  ///   -[id]: Task identifier
  ///
  /// Returns: Task
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Get task by identifier from the database
  ///
  /// Params:
  ///
  ///   -[id]: Task identifier
  ///
  /// Returns: Task
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Create task in the database
  ///
  /// Params:
  ///
  ///   -[task]: Task Object we want to save
  ///
  /// Returns: boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> createTask(Task task) async {
    final String apiUrl = '$baseUrl/task';

    // Necesitamos convertir el objeto a JSON pero sin su id
    String jsonBody = task.toJsonWithoutId();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      print(jsonBody);

      if (response.statusCode == 201) {
        // La solicitud POST fue exitosa.
        // La respuesta incluye los datos de la tarea recién creada,
        // Tenemos que extraer de esta el id y asignarselo al objeto parámetro
        // Como en dart los parametros se pasan por referencia, los cambios perdurarán.
        final body = json.decode(response.body);
        task.id = body['id'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  /// Get subtask from a task
  ///
  /// Params:
  ///
  ///   -[taskId]: Task identifier
  ///
  /// Returns: List of subtasks
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// private method for updating a task in the database
  ///
  /// Params:
  ///
  ///   -[taskId]: Task identifier
  ///
  ///   -[jsonString]: Task in json format
  ///
  /// Returns: Boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> _putTask(String taskId, String jsonString) async {
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
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  /// add subtask to a task
  ///
  /// Params:
  ///
  ///   -[taskId]: Task identifier
  ///
  ///   -[subtaskId]: Subtask identifier
  ///
  ///
  /// Returns: boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed

  Future<bool> addSubtaskToTaskList(String taskId, String subtaskId) async {
    // Obtiene la tarea
    Task task = await getTask(taskId);

    // Comprueba que la subtarea existe
    // Implementar

    if (!task.subtasks.contains(subtaskId)) {
      // Modifica el array de subtasks añadiendo la nueva
      task.subtasks.add(subtaskId);
      // Crea el JSON con las tareas actualizadas.
      Map<String, dynamic> requestJson = {
        "subtasks": task.subtasks,
      };

      // Realiza la operacion de actualizacion en la BD
      var result = await _putTask(taskId, json.encode(requestJson));

      return result;
    } else {
      return false;
    }
  }

  /// Remove a subtask
  ///
  /// Params:
  ///
  ///   -[taskId]: Task identifier
  ///
  ///   -[subtaskId]: Subtask identifier
  ///
  /// Returns: boolean
  ///
  ///   - true if the operation has been done
  ///
  ///   - false if the operation has failed

  Future<bool> removeSubtaskFromTaskList(
      String taskId, String subtaskId) async {
    // Obtiene la tarea
    Task task = await getTask(taskId);

    // Comprueba que la subtarea existe
    // Implementar

    if (task.subtasks.contains(subtaskId)) {
      // Modifica elimina la subtarea del array.
      task.subtasks.remove(subtaskId);
      // Crea el JSON con las tareas actualizadas.
      Map<String, dynamic> requestJson = {
        "subtasks": task.subtasks,
      };

      // Realiza la operacion de actualizacion en la BD
      var result = await _putTask(taskId, json.encode(requestJson));

      return result;
    } else {
      return false;
    }
  }

  /// Update task in the database
  ///
  /// Params:
  ///
  ///   -[task]: Object task that is going to be updated
  ///
  /// Returns: boolean dependeing on the result of the _putTask operation

  Future<bool> updateTask(Task task) async {
    // Crea el JSON con las tareas actualizadas.
    String requestJson = task.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putTask(task.id, requestJson);
    return result;
  }

  /// Delete tasks from the database
  ///
  /// Params:
  ///
  ///   -[taskId]: Task identifier
  ///
  /// Returns: Boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> deleteTask(String taskId) async {
    final String apiUrl = '$baseUrl/task/id/$taskId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        //tarea eliminada
        return true; // Devuelve true para indicar que la eliminación fue exitosa.
      } else {
        return false; // Devuelve false para indicar que la eliminación falló.
      }
    } catch (e) {
      return false; // Devuelve false en caso de error de red.
    }
  }

  //-----------------------------------------------------------------------//
  // Student operations

  /// Get a student from the database using the identifier
  ///
  /// Params:
  ///
  ///   -[id]: student identifier
  ///
  /// Returns: Student
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Get all the students from the database
  ///
  /// Returns: List of students
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<List<Student>> getStudents() async {
    final String apiUrl =
        '$baseUrl/student'; // Construye la URL específica para obtener un estudiante por ID.

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

  /// Get all the pending tasks of a student from the data base
  ///
  /// Params:
  ///
  ///   -[studentId]: student identifier
  ///
  /// Returns: List of tasks
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<List<Task>> getPendingTasksFromStudent(String studentId) async {
    try {
      // Obtener student
      Student student = await getStudent(studentId);

      List<Task> list = [];

      for (Map<String, dynamic> taskID in student.pendingTasks) {
        try {
          Task task = await getTask(taskID['id']);
          list.add(task);
        } catch (e) {
          print('Error al obtener la tarea ${taskID["id"]}: $e');
        }
      }

      return list;
    } catch (e) {
      print('Error al obtener el estudiante con id $studentId: $e');
      throw Exception(
          'No se pudo obtener la lista de tareas pendientes del estudiante con id $studentId.');
    }
  }

  Future<List<Task>> getPendingTasksTodayFromStudent(String studentId) async {
    final String apiUrl =
        '$baseUrl/student/tasks/$studentId'; // Construye la URL específica para obtener un estudiante por ID.

    try {
      final response = await http.get(Uri.parse(
          apiUrl)); // Realiza una solicitud HTTP GET para obtener el estudiante.

      if (response.statusCode == 200) {
        List<Task> pendingTasks = [];
        List<String> taskIds = List<String>.from(json.decode(response.body));
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        for (String taskId in taskIds) {
          try {
            Task task = await getTask(taskId);
            pendingTasks.add(task);
          } catch (e) {
            print('Error al obtener la tarea $taskId: $e');
          }
        }
        return pendingTasks;
      } else {
        throw Exception(
            'Error al obtener el estudiante: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  /// Get all the done tasks of a student from the data base
  ///
  /// Params:
  ///
  ///   -[studentId]: student identifier
  ///
  /// Returns: List of tasks
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Private method to update a student in the database
  ///
  /// Params:
  ///
  ///   -[studentId]: student identifier
  ///
  ///   -[jsonString]: student in json format
  ///
  /// Returns: boolean
  ///
  ///   -true: if the operation has been done
  ///
  ///   -flase: if the operation failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> _putStudent(String studentId, String jsonString) async {
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
        print('Error al actualizar el estudiante: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  /// Mark as done a student task
  ///
  /// Params:
  ///
  ///   -[studentId]: student identifier
  ///
  ///   -[taskId]: task identifier
  ///
  /// Returns: boolean with the result after doing _putStudent operation

  Future<dynamic> markTaskAsCompleted(String studentId, String taskId) async {
    // Obtiene el estudiante.
    Student student = await getStudent(studentId);

    // Modifica el array de pending tasks -> elimina la tarea con id = taskId.
    student.pendingTasks.removeWhere((task) => taskId == task['id']);

    // Modifica el array de done tasks -> inserta el id de la tarea taskId.
    student.doneTasks.add(taskId);

    // Crea el JSON con las tareas actualizadas.
    Map<String, dynamic> requestJson = {
      "pendingTasks": student.pendingTasks,
      "doneTasks": student.doneTasks,
    };

    // Realiza la operacion de actualizacion en la BD
    var result = await _putStudent(studentId, json.encode(requestJson));

    return result;
  }

  /// Assing a task to a student
  ///
  /// Params:
  ///
  ///   -[studentId]: student identifier
  ///
  ///   -[taskId]: task identifier
  ///
  /// Returns: Boolean with the result after doing _putStudent operation
  Future<dynamic> assignTaskToStudent(String studentId, String taskId) async {
    // Obtiene el estudiante.
    Student student = await getStudent(studentId);

    // Comprobar si existen tarea y alumno (?)

    // Verifica si la tarea ya está en las tareas pendientes del estudiante.
    if (!student.pendingTasks.contains(taskId)) {
      Map<String, dynamic> task = {
        "id": taskId,
      };
      // Agrega la tarea solo si no está en la lista.
      student.pendingTasks.add(task);

      // Crea el JSON con las tareas actualizadas.
      Map<String, dynamic> requestJson = {
        "pendingTasks": student.pendingTasks,
      };

      // Realiza la operación de actualización en la BD
      var result = await _putStudent(studentId, json.encode(requestJson));

      return result;
    } else {
      throw Exception('Task is already assigned to the student');
    }
  }

  /// Update the student information in the data base
  ///
  /// Params:
  ///
  ///   -[student]: Object of type student
  ///
  /// Returns: Boolean with the result after doing _putStudent operation

  Future<bool> updateStudent(Student student) async {
    // Crea el JSON con las tareas actualizadas.
    var jsonBody = student.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putStudent(student.id, jsonBody);
    return result;
  }

  /// Delete a student from the data base
  ///
  /// Params:
  ///
  ///   -[id]: student identifier
  ///
  /// Returns: boolean
  ///
  ///   -true if the student has been deleted
  ///
  ///   -false if the setudent hasn't been deleted
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> deleteStudent(String studentId) async {
    final String apiUrl = '$baseUrl/student/id/$studentId';

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 204) {
        return true; // Devuelve true para indicar que la eliminación fue exitosa.
      } else {
        print('Error al eliminar el estudiante: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  //-----------------------------------------------------------------------//
  // Teacher operations

  /// Get teacher by identifier from the database
  ///
  /// Params:
  ///
  ///   -[id]: Teacher identifier
  ///
  /// Returns: Teaches
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API

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

  /// Get students associated to a teacher
  ///
  /// Params:
  ///
  ///   -[teacherId]: Teacher identifier
  ///
  /// Returns: List of students
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
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

  /// Private method to update a teacher in the database
  ///
  /// Params:
  ///
  ///   -[teacherId]: Teacher identifier
  ///
  ///   -[jsonString]: Teacher in json format
  ///
  /// Returns: boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed
  ///
  /// Exceptions: throws exceptions if problems are detected while trying to connect with the API
  Future<bool> _putTeacher(String teacherId, String jsonString) async {
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
        print('Error al actualizar el profesor: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  /// Update a teacher in the database
  ///
  /// Params:
  ///
  ///   -[teacher]: teacher object that is going to be updated
  ///
  /// Returns: boolean depending on the result of the _putTeacher operation

  Future<bool> updateTeacher(Teacher teacher) async {
    // Crea el JSON con las tareas actualizadas.
    String requestJson = teacher.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putTeacher(teacher.id, requestJson);
    return result;
  }

  /// Assing a student to a teacher
  ///
  /// Params:
  ///
  ///   -[teacherId]: Teacher identifier
  ///
  ///   -[studentId]: Student identifier
  ///
  /// Returns: Boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed
  Future<bool> addStudentToTeacherList(
      String teacherId, String studentId) async {
    // Obtiene al profesor
    Teacher teacher = await getTeacher(teacherId);

    // Si no tiene ya al alumno, lo añade
    if (!teacher.students.contains(studentId)) {
      teacher.students.add(studentId);
      var result = updateTeacher(teacher);
      return result;
    } else {
      return false;
    }
  }

  /// Unassign student from a teacher
  ///
  /// Params:
  ///
  ///   -[teacherId]: Teacher identifier
  ///
  ///   -[studentId]: Student identifier
  ///
  /// Returns: boolean
  ///
  ///   -true if the operation has been done
  ///
  ///   -false if the operation has failed

  Future<bool> removeStudentFromTeacherList(
      String teacherId, String studentId) async {
    // Obtiene al profesor
    Teacher teacher = await getTeacher(teacherId);

    // Si tiene al alumno, lo elimina
    if (teacher.students.contains(studentId)) {
      teacher.students.remove(studentId);
      var result = updateTeacher(teacher);
      return result;
    } else {
      return false;
    }
  }

  /// 2a iteracion

  // devuelve una lista de request del estudiante
  Future<List<Request>> getRequestsFromStudent(String studentId) async {
    final String apiUrl = '$baseUrl/request/student/$studentId';

    try {
      List<Request> list = [];
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        final List<dynamic> requestsJson = json.decode(response.body);
        for (var requestJson in requestsJson) {
          list.add(Request.fromMap(requestJson));
        }
      } else {
        throw Exception(
            'Error al obtener los request del estudiante(id=$studentId): ${response.statusCode}');
      }

      return list;
    } catch (e) {
      print('Error al obtener todos los request: $e');
      throw Exception('No se pudo obtener la lista de request del usuario');
    }
  }

  // devuelve el objeto de tipo request con ese id
  Future<Request> getRequest(String id) async {
    final String apiUrl = '$baseUrl/request/id/$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Request req = Request.fromJson(response.body);
        return req;
      } else {
        throw Exception(
            'Error al obtener el peticion: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // devuelve el objeto de tipo request con ese id
  Future<Item> getItem(String id) async {
    final String apiUrl = '$baseUrl/item/$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        Item obj = Item.fromJson(response.body);
        return obj;
      } else {
        throw Exception('Error al obtener item: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  Future<List<Item>> getItemsFromRequest(String requestId) async {
    try {
      // Obtiene el request
      Request req = await getRequest(requestId);

      List<Item> list = [];

      // Va recorriendo el array de items y añadiendolos al array
      for (String itemId in req.items) {
        try {
          Item item = await getItem(itemId);
          list.add(item);
        } catch (e) {
          print('Error al obtener el item $itemId: $e');
        }
      }

      // Devolver el array de items
      return list;
    } catch (e) {
      print('Error al obtener el request con id $requestId: $e');
      throw Exception(
          'No se pudo obtener la lista de items para la peticion de material con id=$requestId');
    }
  }

  Future<bool> updateItem(Item item) async {
    // Crea el JSON con las tareas actualizadas.
    var requestJson = item.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putItem(item.id, requestJson);
    return result;
  }

  Future<bool> _putItem(String id, String jsonString) async {
    final String apiUrl = '$baseUrl/item/$id';

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
        print('Error al actualizar la item: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  Future<String> createItem(Item item) async {
    final String apiUrl = '$baseUrl/item';

    // Necesitamos convertir el objeto a JSON pero sin su id
    String jsonBody = item.toJsonWithoutId();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      print(jsonBody);

      if (response.statusCode == 201) {
        // La solicitud POST fue exitosa.
        // La respuesta incluye los datos de la tarea recién creada,
        // Tenemos que extraer de esta el id y asignarselo al objeto parámetro
        // Como en dart los parametros se pasan por referencia, los cambios perdurarán.
        final body = json.decode(response.body);
        item.id = body['id'];

        // Se debe cambiar también el nombre, puesto que se pasó a mayúsculas en la BD
        item.name = body['name'];
        return body['id'];
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<String> createRequest(Request req) async {
    final String apiUrl = '$baseUrl/request';

    // Necesitamos convertir el objeto a JSON pero sin su id
    String jsonBody = req.toJsonWithoutId();

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      print(jsonBody);

      if (response.statusCode == 201) {
        // La solicitud POST fue exitosa.
        // La respuesta incluye los datos de la tarea recién creada,
        // Tenemos que extraer de esta el id y asignarselo al objeto parámetro
        // Como en dart los parametros se pasan por referencia, los cambios perdurarán.
        final body = json.decode(response.body);
        req.id = body['id'];
        return body['id'];
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<bool> updateRequest(Request req) async {
    // Crea el JSON con las tareas actualizadas.
    var requestJson = req.toJsonWithoutId();

    // Realiza la operacion de actualizacion en la BD
    var result = await _putRequest(req.id, requestJson);
    return result;
  }

  Future<bool> _putRequest(String id, String jsonString) async {
    final String apiUrl = '$baseUrl/request/$id';

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
        print('Error al actualizar la request: ${response.reasonPhrase}');
        return false;
      }
    } catch (e) {
      print('Error de red: $e');
      return false;
    }
  }

  // Add item to request??

  // Get every menu from the database and return a list of Menu
  Future<List<Menu>> getMenus() async {
    final String apiUrl = '$baseUrl/api/menu';

    try {
      List<Menu> list = [];
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        final List<dynamic> menusJson = json.decode(response.body);
        for (var menuJson in menusJson) {
          list.add(Menu.fromMap(menuJson));
        }
      } else {
        throw Exception('Error al obtener los menus: ${response.statusCode}');
      }

      return list;
    } catch (e) {
      print('Error al obtener todos los menus: $e');
      throw Exception('No se pudo obtener la lista de menus del sistema');
    }
  }

  // Get the KitchenOrder from a class id
  Future<KitchenOrder> getKitchenOrder(String classId) async {
    final String apiUrl = '$baseUrl/kitchen-order/classroom/$classId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud se completó con éxito (código de respuesta 200), analiza la respuesta JSON.
        KitchenOrder kitchenOrder = KitchenOrder.fromJson(response.body);
        return kitchenOrder;
      } else {
        print(response.statusCode);
        throw Exception(
            'Error al obtener el KitchenOrder: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // Get all the classrooms from the database
  Future<List<Classroom>> getClassrooms() async {
    final String apiUrl = '$baseUrl/classroom';

    try {
      List<Classroom> list = [];
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Analizar la respuesta JSON
        final List<dynamic> classroomsJson = json.decode(response.body);
        for (var classroomJson in classroomsJson) {
          list.add(Classroom.fromMap(classroomJson));
        }
      } else {
        throw Exception('Error al obtener las aulas: ${response.statusCode}');
      }

      return list;
    } catch (e) {
      print('Error al obtener todas las aulas: $e');
      throw Exception('No se pudo obtener la lista de aulas del sistema');
    }
  }
}
