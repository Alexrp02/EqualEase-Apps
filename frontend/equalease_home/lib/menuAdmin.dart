import 'package:equalease_home/models/kitchen.dart';
import 'package:equalease_home/models/kitchen_order.dart';
import 'package:flutter/material.dart';
import 'package:equalease_home/addMenu.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/menu.dart';
import 'package:equalease_home/kitchenOrderMenu.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool isLoading = false;
  final controller = APIController();

  List<Menu> _MenuAgregadas = [];

  @override
  void initState() {
    super.initState();

    controller.getMenus().then((value) {
      setState(() {
        _MenuAgregadas = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
          toolbarHeight: 100.0,
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
                  'LISTA DE MENUS',
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
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1),
                  itemCount: _MenuAgregadas.length,
                  itemBuilder: (context, i) {
                    final Menu menuAgregado = _MenuAgregadas[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        // Lógica cuando se toca un menú
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 170, 172, 174),
                            width: 3.0,
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        margin: EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Centra los elementos horizontalmente
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Centra los elementos verticalmente
                                    children: [
                                      // Mostrar la imagen del menú
                                      Image.network(
                                        menuAgregado.image,
                                        width: 150.0,
                                        height: 150.0,
                                      ),
                                      SizedBox(height: 10.0),
                                      // Mostrar el título del menú con manejo de desbordamiento
                                      Container(
                                        width:
                                            180.0, // Ancho máximo permitido para el texto
                                        child: Text(
                                          menuAgregado.name,
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 20.0,
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Evita el desbordamiento con puntos suspensivos
                                          maxLines:
                                              2, // Número máximo de líneas permitido
                                          textAlign: TextAlign
                                              .center, // Centra el texto dentro del contenedor
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Color.fromARGB(255, 170, 172, 174),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 35,
                              ),
                              onPressed: () {
                                // Lógica para eliminar el menú
                                _eliminarMenu(menuAgregado);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 90,
            height: 90,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 161, 182, 236),
              onPressed: () {
                // Lógica para el botón "Añadir"
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddMenuForm()),
                ).then((value) {
                  //_MenuAgregadas.add(value);
                  setState(() {
                    _MenuAgregadas.add(value);
                  });
                });
              },
              child: Icon(Icons.add, size: 75),
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: 90,
            height: 90,
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 161, 182, 236),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KitchenOrderPage()),
                );
              },
              child: Icon(Icons.restaurant_menu, size: 75),
              heroTag:
                  null, // Agrega esta línea para evitar conflictos en los hero tags
              mini: true, // Hace que el botón sea más pequeño
              // Ajusta el tamaño según sea necesario
            ),
          ),
        ],
      ),
    );
  }

  void _eliminarMenu(Menu menu) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "ELIMINAR MENU",
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  "¿ESTÁ SEGURO?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "CANCELAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "ACEPTAR",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (menu.id != null) {
                  controller.deleteMenu(menu.id!);
                  setState(() {
                    _MenuAgregadas.remove(menu);
                    // Llamar al controlador de eliminación
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        );
      },
    );
  }
}
