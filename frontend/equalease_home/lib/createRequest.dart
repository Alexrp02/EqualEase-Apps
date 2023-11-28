import 'package:flutter/material.dart';
import 'package:equalease_home/models/student.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/item.dart';
import 'package:equalease_home/createItem.dart';
import 'package:equalease_home/models/request.dart';


class CreateRequestPage extends StatefulWidget {
  final String studentId;

  CreateRequestPage(this.studentId);

  @override
  _CreateRequestPageState createState() => _CreateRequestPageState();
}

class _CreateRequestPageState extends State<CreateRequestPage> {
  final APIController _controller = APIController();
  late Student _student;
  late Request _request;

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
    
    _request = Request(
          id: '',
          items: [],
          assignedStudent: widget.studentId,
    );

    _controller.getRequestsFromStudent(widget.studentId).then((reqList) {
      //print("Tamaño de la peticion: ${reqList.length}");

      if (reqList.isNotEmpty) {
        setState(() {
          _request = reqList[0];
        });
      } else {
        
        //print("La lista de ${_student.name} está vacía");
        _controller.createRequest(_request).then((request) {
          setState(() {
            _request.id = request;
          });
        });
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creación de pedido para ${_student.name}'), // Reemplaza con el nombre del estudiante
      ),
      body: FutureBuilder(
        future: Future.wait(_request.items.map((itemId) => _controller.getItem(itemId))),
        builder: (context, AsyncSnapshot<List<Item>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Item item = snapshot.data![index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('Cantidad: ${item.quantity}, Tamaño: ${item.size}'),
                  // Otros detalles del item
                );
              },
            );

          } else {
            return Text('No hay datos');
          }
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
              _request.items.add(newItem.id);
              //print(_request.items) ;
              _controller.updateRequest(_request);
            });
          }
        },
        child: Icon(Icons.add), // Icono de añadir
      ),
    );
  }
}


