import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../studentLandingPage.dart';

import 'package:equalease_home/controllers/controller_api.dart';
//import 'components/widget_grid.dart';
import 'package:google_fonts/google_fonts.dart';

class PictogramGridView extends StatefulWidget {
  final GlobalKey<PictogramGridViewState> gridKey;
  final Function(String) onPasswordChanged;
  final String studentId; // Agregamos el nuevo parámetro

  PictogramGridView({
    required this.gridKey,
    required this.onPasswordChanged,
    required this.studentId, // Agregamos el nuevo parámetro
  });

  @override
  PictogramGridViewState createState() => PictogramGridViewState();
}

class PictogramGridViewState extends State<PictogramGridView> {
  final List<String> pictogramAssets = [
    'coche',
    'botella',
    'circulo',
    'casa',
    'planta',
    'vaso',
  ];

  List<String> selectedPictograms = [];
  String concatenatedPassword = '';
  final double bottomContainerHeight = 100.0;

  // Lista de claves para acceder al estado de las tarjetas
  final List<GlobalKey<_PictogramCardState>> cardKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double gridHeight = constraints.maxHeight;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: constraints.maxWidth /
                        (gridHeight * 2 - 250 - bottomContainerHeight),
                  ),
                  itemCount: pictogramAssets.length,
                  itemBuilder: (BuildContext context, int index) {
                    final imageName = pictogramAssets[index];

                    // Crear una clave para cada tarjeta
                    final cardKey = GlobalKey<_PictogramCardState>();
                    cardKeys.add(cardKey);
                    final resetKey = GlobalKey<PictogramGridViewState>();

                    return PictogramCard(
                      key: cardKey,
                      imageName: imageName,
                      onSelected: (isSelected) {
                        updateSelectedPictograms(imageName, isSelected);
                      },
                      height: gridHeight,
                      selectColor: selectedPictograms.contains(imageName),
                      studentId: widget.studentId, // Pasamos el studentId
                      concatenatedPassword: concatenatedPassword,
                      selectedPictograms: selectedPictograms,
                      gridKey: resetKey,
                      clear: clear,
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: bottomContainerHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedPictograms.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/${selectedPictograms[index]}.png',
                    height: 80.0,
                    width: 80.0,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateSelectedPictograms(String imageName, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedPictograms.add(imageName);
      } else {
        selectedPictograms.remove(imageName);
      }

      concatenatedPassword = selectedPictograms.join();
      print(concatenatedPassword);

      // Notificar cambios a través del callback
      widget.onPasswordChanged(concatenatedPassword);
    });
  }

  void clear() {
    setState(() {
      selectedPictograms.clear();
      selectedPictograms = [];
      concatenatedPassword = '';
    });
  }

  // Método para reiniciar las imágenes seleccionadas
  void resetSelectedImages() {
    setState(() {
      selectedPictograms.clear();
      selectedPictograms = [];
      concatenatedPassword = '';
      print("entramos aqui");

      // Iterar sobre las tarjetas y reiniciar su estado y color
      for (final cardKey in cardKeys) {
        cardKey.currentState?.resetCardState();
      }
    });
  }

  static void deleteAll() {}
}

class PictogramCard extends StatefulWidget {
  final String imageName;
  final Function(bool isSelected) onSelected;
  final Function() clear;
  final double height;
  final bool selectColor;
  final String studentId; // Agregamos el nuevo parámetro
  final String concatenatedPassword;
  List<String> selectedPictograms;
  final GlobalKey<PictogramGridViewState> gridKey; // Nueva línea

  PictogramCard(
      {required this.imageName,
      required this.onSelected,
      required this.height,
      required GlobalKey<_PictogramCardState> key,
      required this.selectColor,
      required this.studentId, // Agregamos el nuevo parámetro
      required this.concatenatedPassword,
      required this.selectedPictograms,
      required this.gridKey,
      required this.clear});

  @override
  _PictogramCardState createState() => _PictogramCardState();
}

class _PictogramCardState extends State<PictogramCard> {
  bool isSelected = false;
  Color _colorfondo = Colors.transparent;
  final APIController _controller = APIController();
  String concatenatedPassword = '';
  List<String> selectedPictograms = [];

  @override
  void initState() {
    concatenatedPassword = widget.concatenatedPassword;
    selectedPictograms = widget.selectedPictograms;
    super.initState();
  }

  void resetCardState() {
    setState(() {
      isSelected = false;
      _colorfondo = Colors.transparent;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.selectColor ? Colors.blue : Colors.transparent;

    if (!isSelected) {
      cardColor = _colorfondo;
    }

    return GestureDetector(
      onTap: () async {
        setState(() {
          isSelected = !isSelected;
          _colorfondo = isSelected ? Colors.blue : Colors.transparent;
          widget.onSelected(isSelected);
          selectedPictograms = widget.selectedPictograms;
          concatenatedPassword = widget.concatenatedPassword;
          concatenatedPassword = concatenatedPassword + this.widget.imageName;
        });
        
        if (selectedPictograms.length >= 3) {
          Map<String, dynamic> loginResult =
              await _controller.login(widget.studentId, concatenatedPassword);

          
          print("Realizando comprobación automatica");

          if (loginResult["token"] != null) {
            widget.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentLandingPage(
                  idStudent: widget.studentId,
                ),
              ),
            );
          } else {
            widget.clear();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('INTÉNTALO OTRA VEZ'),
                  content: Row(
                    children: [
                      Icon(
                        Icons
                            .sentiment_satisfied, // El icono de la cara sonriente
                        color: Colors
                            .orange, // Puedes ajustar el color según tus preferencias
                        size:
                            80.0, // Puedes ajustar el tamaño según tus preferencias
                      ),
                      SizedBox(
                          width: 10.0), // Espaciado entre el icono y el texto
                      Text(
                        'ÁNIMO',
                        style: TextStyle(
                          fontSize:
                              20.0, // Ajusta el tamaño del texto según tus preferencias
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // Llamar a la función para resetear las imágenes
                          //_passwordGridKey.currentState?.resetSelectedImages();
                          widget.gridKey.currentState?.resetSelectedImages();

                          selectedPictograms.clear();
                          selectedPictograms = [];

                          Navigator.pop(context);
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
        ),
        child: SizedBox(
          height: widget.height,
          width: widget.height,
          child: Center(
            child: Image.asset(
              'assets/${widget.imageName}.png',
            ),
          ),
        ),
      ),
    );
  }
}


/*
void main() {
  runApp(MaterialApp(
    home: PictogramGridView(),
  ));
}
*/