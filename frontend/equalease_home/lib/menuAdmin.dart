import 'package:flutter/material.dart';
import 'package:equalease_home/addMenu.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/menu.dart';

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
          backgroundColor: Color.fromARGB(255, 161, 182, 236),
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
                    fontSize: 30.0,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
        child: Icon(Icons.add),
      ),
    );
  }

  void _eliminarMenu(Menu menu) {
    // Lógica para eliminar el menú
    // Puedes utilizar el controller o cualquier otra lógica necesaria
    // Ejemplo: controller.eliminarMenu(menu);
  }
}
