import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdministrationPage extends StatefulWidget {
  AdministrationPage();

  @override
  _AdministrationPage createState() => _AdministrationPage();
}

class _AdministrationPage extends State<AdministrationPage>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Student? _student;
  APIController _controller = APIController();
  late TabController tabController;
  late Map<String, dynamic> data;
  bool isLoading = true;

  List<Student> _StudentsAdded = []; //para obtener los alumnos

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    _controller.getStudents().then((students) {
      setState(() {
        _StudentsAdded = students;
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
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
                  'LISTA DE ALUMNOS',
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
                width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80%
                child: ListView.builder(
                  itemCount: _StudentsAdded.length,
                  itemBuilder: (context, i) {
                    final Student StudentAgregada = _StudentsAdded[i];
                    int currentIndex = i + 1;
                    return GestureDetector(
                      onTap: () {
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetallesTaskPage(
                              task: TaskAgregada,
                              controller: controller,
                            ),
                          ),
                        );*/
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
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ALUMNO: ${StudentAgregada.name} ${StudentAgregada.surname}',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 30.0, // Ajusta el tamaño del texto
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      iconSize: 50.0,
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditTaskPage(task: TaskAgregada),
                                        ),
                                      ).then((value) {
                                        setState(() {
                                          TaskAgregada.title = value;
                                        });
                                      });*/
                                      }),
                                  IconButton(
                                    iconSize: 50.0,
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      // _showDeleteConfirmationDialog(
                                      //   TaskAgregada);
                                    },
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
                      ),
                    );
                  },
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarTaskPage(
                onTaskSaved: (task) {
                  // Ajusta el parámetro para que sea de tipo Task
                },
              ),
            ),
          ).then((value) {
            setState(() {
              _TasksAgregadas.add(value);
            });
          });*/
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: GFTabBar(
        tabBarColor: const Color.fromARGB(255, 161, 182, 236),
        indicatorColor: const Color.fromARGB(255, 83, 120, 214),
        indicatorWeight: 5,
        length: 2,
        controller: tabController,
        tabs: const [
          Tab(
            icon: Icon(Icons.person),
            child: Text(
              "Datos",
            ),
          ),
          Tab(
            icon: Icon(Icons.bar_chart),
            child: Text(
              "Estadísticas",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStudentInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nombre:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _student!.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          'Apellidos:',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          _student!.surname,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Acción a realizar al presionar el botón de editar
                print('Editar');
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Editar'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Acción a realizar al presionar el botón de eliminar
                print('Eliminar');
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 161, 182, 236),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: Text('Eliminar'),
            ),
          ],
        ),
      ],
    );
  }
}
