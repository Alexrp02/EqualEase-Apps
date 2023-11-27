import 'package:flutter/material.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/item.dart';
import 'package:equalease_home/createItem.dart';


class CreateRequestPage extends StatefulWidget {
  final String studentId;

  CreateRequestPage(this.studentId);

  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final APIController _controller = APIController();
  late Student _student;
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _student = Student(
      id: '',
      name: '',
      surname: '',
      pendingTasks: [],
      doneTasks: [],
      profilePicture: '',
      hasRequest: false,
      hasKitchenOrder: false,
    );
    
    // Utilizando then para realizar la operación de obtención de manera asincrónica
    _controller.getStudent(widget.studentId).then((student) {
      setState(() {
        _student = student;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creación de pedido para ${_student.name}'), // Reemplaza con el nombre del estudiante
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
            // Otros detalles del item
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega a la página createItemPage y espera el resultado
          Item newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateItemPage()),
          );
          if (newItem != null) {
            setState(() {
              items.add(newItem);
            });
          }
        },
        child: Icon(Icons.add), // Icono de añadir
      ),
    );
  }
}


