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
      representation: "text",
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
        actions: [
          // Agrega el botón de cerrar sesión en el AppBar
          IconButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: Icon(
              Icons.exit_to_app,
              size: 70.0,
            ),
          ),
        ],
        toolbarHeight: 100.0,
        backgroundColor: Color.fromARGB(255, 161, 182, 236),
        leading: new IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: new Icon(
              Icons.arrow_back,
              size: 50.0,
            )),
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CREACION DE PEDIDO PARA ${_student.name.toUpperCase()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(top: 36.0),
            child: FutureBuilder(
              future: Future.wait(
                  _request.items.map((itemId) => _controller.getItem(itemId))),
              builder: (context, AsyncSnapshot<List<Item>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.isNotEmpty) {
                  return DataTable(
                    columns: [
                      DataColumn(
                        label: Text('NOMBRE', style: TextStyle(fontSize: 44.0)),
                      ),
                      DataColumn(
                        label:
                            Text('CANTIDAD', style: TextStyle(fontSize: 44.0)),
                      ),
                      DataColumn(
                        label: Text('TAMAÑO', style: TextStyle(fontSize: 44.0)),
                      ),
                    ],
                    rows: snapshot.data!.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                if (item.pictogram != "")
                                  Image.network(
                                    item.pictogram,
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  )
                                else
                                  Container(
                                      width: 50.0,
                                      height:
                                          50.0), // Otra opción: Placeholder de imagen
                                SizedBox(width: 8.0),
                                Text(
                                  item.name,
                                  style: TextStyle(fontSize: 30.0),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              item.quantity.toString(),
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.size,
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: Text(
                      'Aún no se ha asociado ningún objeto al pedido',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey[
                            700], // Puedes ajustar el color según tus preferencias
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            ),
          ),
        ),
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
