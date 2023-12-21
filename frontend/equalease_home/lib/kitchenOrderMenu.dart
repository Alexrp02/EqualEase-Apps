import 'package:flutter/material.dart';
import 'controllers/controller_api.dart';
import 'addMenu.dart';
import 'models/menu.dart';
import 'models/student.dart';

class KitchenOrderPage extends StatefulWidget {
  @override
  _KitchenOrderPageState createState() => _KitchenOrderPageState();
}

class _KitchenOrderPageState extends State<KitchenOrderPage> {
  bool isLoading = true;
  final _controller = APIController();
  List<Menu> _MenusAgregados = [];
  Map<String, dynamic> _kitchenOrdersQuantities = {};
  List<Student> _StudentsAdded = [];
  int estilo = 0;

  @override
  void initState() {
    super.initState();
    _controller.getStudents().then((students) {
      setState(() {
        _StudentsAdded = students;
      });
    });

    // Obtener las cantidades de KitchenOrders
    _controller.getKitchenOrdersQuantities().then((quantities) {
      setState(() {
        _kitchenOrdersQuantities = quantities;
      });
    });

    // Obtener los menús (ajusta según tu lógica)
    _controller.getMenus().then((value) {
      setState(() {
        _MenusAgregados = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Menu> menusConCantidad = _MenusAgregados.where(
        (menu) => (_kitchenOrdersQuantities[menu.id!] ?? 0) > 0).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
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
                  'COMANDA DEL DIA',
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
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            )
          : ListView.builder(
              itemCount: menusConCantidad.length,
              itemBuilder: (context, i) {
                final Menu MenuAgregado = menusConCantidad[i];
                int currentIndex = i + 1;
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Row(
                      children: [
                        // Mostrar la imagen del menú
                        Image.network(
                          MenuAgregado.image,
                          width: 120.0,
                          height: 120.0,
                        ),
                        SizedBox(width: 16.0),
                        // Mostrar el título del menú con manejo de desbordamiento
                        Expanded(
                          child: Text(
                            MenuAgregado.name,
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        // Mostrar la cantidad de KitchenOrders en el listado
                        Text(
                          "CANTIDAD: ${_kitchenOrdersQuantities[MenuAgregado.id!] ?? 0}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24.0,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Lógica cuando se toca un menú
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Color.fromARGB(255, 161, 182, 236),
      child: Container(
        height: 60.0,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildStudentWidgets(),
        ),
      ),
    );
  }

  List<Widget> _buildStudentWidgets() {
    List<Widget> widgets = [];
    for (var student in _StudentsAdded) {
      if (student.hasKitchenOrder) {
        widgets.add(Container(
          //color: Colors.lightBlue,
          //padding: EdgeInsets.all(16.0),
          child: Text(
            "ESTUDIANTE ENCARGADO: ${student.name.toUpperCase()}",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 22.0,
            ),
          ),
        ));
      }
    }
    return widgets;
  }
}
