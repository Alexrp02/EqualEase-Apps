import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equalease_home/models/task.dart';

// Ejemplo de formato de respuesta de peticion GET: http://localhost:3000/api/subtask/id/$id
// {
//     "id": "aAmlJnXo785HjgTrdewX",
//     "title": "Poner mantel",
//     "description": "Abrir y extender el mantel, colocarlo encima de la mesa y quitar arrugas. Además he modificado esto con PUT.",
//     "images": [],
//     "pictograms": []
// }
Future<Task> getTaskById(String id) async {
  var url = Uri.parse("http://localhost:3000/api/task/id/$id");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final task = Task.fromJson(response.body);
    return task; // Devolver el objeto Subtask en caso de éxito
  } else {
    throw Exception(
        "No se pudo obtener la task con id = $id"); // Lanzar una excepción en caso de error
  }
}

// Ejemplo de formato de respuesta de peticion GET: http://localhost:3000/api/subtask/title/$title
// {
//     "id": "aAmlJnXo785HjgTrdewX",
//     "title": "Poner mantel",
//     "description": "Abrir y extender el mantel, colocarlo encima de la mesa y quitar arrugas. Además he modificado esto con PUT.",
//     "images": [],
//     "pictograms": []
// }
Future<Task> getTaskByTitle(String title) async {
  String encodedTitle = Uri.encodeComponent(title);
  var url = Uri.parse("http://localhost:3000/api/task/title/$encodedTitle");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final task = Task.fromJson(response.body);
    return task; // Devolver el objeto Subtask en caso de éxito
  } else {
    throw Exception(
        "No se pudo obtener la task con titulo = $title"); // Lanzar una excepción en caso de error
  }
}

// Ejemplo de formato de respuesta de peticion GET: http://localhost:3000/api/subtask
// {
//     "subtasks": [
//         {
//             "id": "6MUeuSXiDuVadZo6sSGd",
//             "title": "tarea nueva x2",
//             "description": "nueva tarea, sirve para pruebas",
//             "images": [],
//             "pictograms": []
//         },
//         {
//             "id": "Rv1KWcrhhKNHKpWDxB2E",
//             "title": "tarea nueva",
//             "description": "nueva tarea, sirve para pruebas",
//             "images": [],
//             "pictograms": []
//         }
//     ]
// }
Future<List<Task>> getAllTasks() async {
  var url = Uri.parse("http://localhost:3000/api/task");

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final List<dynamic> tasksListData =
        json.decode(response.body)['tasks'];

    List<Task> tasks = tasksListData.map((data) {
      return Task.fromMap(data);
    }).toList();

    return tasks; // Devolver la lista de objetos Subtask en caso de éxito
  } else {
    throw Exception("No se pudieron obtener las tasks");
  }
}

// Ejemplo de formato de respuesta de peticion POST: http://localhost:3000/api/subtask
// {
//     "id": "aAmlJnXo785HjgTrdewX",
//     "title": "Poner mantel",
//     "description": "Abrir y extender el mantel, colocarlo encima de la mesa y quitar arrugas. Además he modificado esto con PUT.",
//     "images": [],
//     "pictograms": []
// }
Future<void> createTask(Task task) async {
  var url = Uri.parse("http://localhost:3000/api/task");

  // Convierte el objeto Subtask a una cadena JSON (sin meter el id).
  String jsonBody = task.toJsonWithoutId();

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
    print(
        "Error al crear la task [${response.statusCode}: ${response.body}]");
  }
}

// Ejemplo de formato de respuesta de peticion PUT: http://localhost:3000/api/subtask/id/aAmlJnXo785HjgTrdewX
// {
//     "message": "Subtarea actualizada con éxito"
// }
Future<void> updateTask(Task task) async {
  var url = Uri.parse("http://localhost:3000/api/task/id/${task.id}");

  // Se debe tener cuidado porque el id no debe modificarse
  // Por ello no se pasa nunca como argumento json
  String jsonBody = task.toJsonWithoutId();

  var response = await http.put(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    // La solicitud PUT fue exitosa.
    print("Task actualizada con éxito.");
  } else {
    // Manejar errores u otra lógica en caso de que la solicitud no sea exitosa.
    print(
        "Error al actualizar la task [${response.statusCode}: ${response.body}]");
  }
}

// Sería interesante hacer métodos como añadir imagenes o pictogramas al array.

// ¿Cómo hacer el delete? En la API no deja eliminar, arreglar eso antes de probar esta función
// Future<void> deleteSubtask(String id) async {
//   var url = Uri.parse("http://localhost:3000/api/subtask/$id");

//   var response = await http.delete(url);

//   if (response.statusCode == 200) {
//     // La solicitud DELETE fue exitosa.
//     print("Subtask eliminada con éxito.");
//   } else {
//     // Manejar errores u otra lógica en caso de que la solicitud no sea exitosa.
//     print("Error al eliminar la subtask: ${response.statusCode}");
//   }
// }
