
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equalease_home/models/student.dart';

class ControllerStudent{
  String _apiUrl;

  ControllerStudent( this._apiUrl);

  /// Obtiene de la API el estudiante con el identificador especificado
  /// 
  /// Parámetros:
  ///  -[id]: String que representa el identificador del estudiante
  /// 
  /// Return:
  ///  -Lanza un error si no puede conectar con la API
  ///  -Estudiante del tipo Student (en caso de que exista) 

  Future<Student> getStudentById(String id) async {

    var url = Uri.parse('$_apiUrl/id/$id');

    final response = await http.get(url);
    bool debug=true;
    
    if (response.statusCode == 200 || debug) {
      //final student = Student.fromJson(response.body);
      final student = Student(id: '123',name:'estudiante1');
      return student; // Devolver el objeto Subtask en caso de éxito
    } else {
      throw Exception(
          "No se pudo obtener el estudiante con id = $id"); // Lanzar una excepción en caso de error
    }
  }

  /// Obtiene de la API todos los estudiantes
  ///  
  /// Return:
  ///  -Lanza un error si no puede conectar con la API
  ///  -Lista de estudiantes almacenados del tipo Future<List<Student>> (en caso de que exista) 
  /// 
  Future<List<Student>> getAllStudents() async {
  var url = Uri.parse(_apiUrl);

  String jsonRaw = '''
    {
      "students": [
        {
          "id": "asdfg",
          "name": "Estudiante 1"
        }
      ]
    }
  ''';

  final response = await http.get(url);
  bool debug = true;

  if (response.statusCode == 200 || debug) {
    // final List<dynamic> studentsListData =
    //     json.decode(response.body)['students'];

    // List<Task> students = studentsListData.map((data) {
    //   return Task.fromMap(data);
    // }).toList();

    final List<dynamic> studentsListData = 
      json.decode(jsonRaw)['students'];
    
    List<Student> students = studentsListData.map((data){
        return Student.fromMap(data);
    }).toList();

    return students; // Devolver la lista de objetos Subtask en caso de éxito
  } else {
    throw Exception("No se pudieron obtener las tasks");
  }
}

}