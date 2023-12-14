import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:equalease_home/editStudentDataPage.dart';

class StudentData extends StatefulWidget {
  final String _id;

  StudentData(String studentId) : _id = studentId;

  @override
  _StudentDataState createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData>
    with TickerProviderStateMixin {
  // Simulando la obtención de datos del estudiante
  Student? _student;
  APIController _controller = APIController();
  late TabController tabController;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    data = {
      'Enero': 10,
      'Febrero': 20,
      'Marzo': 30,
      'Abril': 40,
      'Mayo': 30,
      'Junio': 20,
      'Julio': 10,
    };

    _student = null;

    _controller.getStudent(widget._id).then((student) {
      setState(() {
        _student = student;
      });
    });
    _controller.getStudentStatistics(widget._id).then((studentData) {
      setState(() {
        data = studentData;
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
                _student != null
                    ? Text(
                        'DATOS DE ${_student!.name.toUpperCase()}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 50.0,
                        ),
                      )
                    :
                    // Si no se ha obtenido el estudiante, se muestra un texto genérico
                    const Text(
                        'DATOS',
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
      body: TabBarView(controller: tabController, children: [
        Center(
          child: _student != null
              ? buildStudentInfo()
              : const Text('No se encontraron datos del estudiante'),
        ),
        Center(
          child: _student != null
              ? SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 100, interval: 5),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <ChartSeries<MapEntry<String, dynamic>, dynamic>>[
                      ColumnSeries<MapEntry<String, dynamic>, String>(
                          dataSource: data["percentageDone"]
                              .entries
                              .toList()
                              .reversed
                              .toList(),
                          xValueMapper: (MapEntry<String, dynamic> entry, _) =>
                              entry.key,
                          yValueMapper: (MapEntry<String, dynamic> entry, _) =>
                              entry.value,
                          name: 'Porcentaje',
                          color: const Color.fromARGB(255, 161, 182, 236))
                    ])
              : const Text('No se encontraron datos del estudiante'),
        ),
      ]),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditStudentDataPage(
                            student: _student!,
                          )),
                ).then((value){
                  setState(() {
                    _student = value;
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 161, 182, 236),
                foregroundColor: Colors.white,
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
                backgroundColor: const Color.fromARGB(255, 161, 182, 236),
                foregroundColor: Colors.white,
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
