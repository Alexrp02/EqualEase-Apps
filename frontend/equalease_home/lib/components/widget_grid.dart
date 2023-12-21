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
  final double bottomContainerHeight = 160.0;
  bool isPasswordIncorrect = false;

  // Lista de claves para acceder al estado de las tarjetas
  final List<GlobalKey<_PictogramCardState>> cardKeys = [];

  void showIncorrect() {
    setState(() {
      isPasswordIncorrect = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isPasswordIncorrect = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double gridHeight = constraints.maxHeight;
                  double gridWidth = constraints.maxWidth;
                  return Column(
                      children: List.generate(
                          (pictogramAssets.length / 3).ceil(), (rowIndex) {
                    return Wrap(
                      children: List.generate(3, (colIndex) {
                        int index = rowIndex * 3 + colIndex;
                        if (index < pictogramAssets.length) {
                          final imageName = pictogramAssets[index];
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
                            width: gridWidth,
                            selectColor: selectedPictograms.contains(imageName),
                            studentId: widget.studentId, // Pasamos el studentId
                            concatenatedPassword: concatenatedPassword,
                            selectedPictograms: selectedPictograms,
                            gridKey: resetKey,
                            clear: clear,
                            showIncorrect: showIncorrect,
                          );
                        } else {
                          return SizedBox
                              .shrink(); // return an empty widget if there's no item
                        }
                      }),
                    );
                  })

                      // final imageName = pictogramAssets[index];

                      // // Crear una clave para cada tarjeta
                      // final cardKey = GlobalKey<_PictogramCardState>();
                      // cardKeys.add(cardKey);
                      // final resetKey = GlobalKey<PictogramGridViewState>();

                      // return PictogramCard(
                      //   key: cardKey,
                      //   imageName: imageName,
                      //   onSelected: (isSelected) {
                      //     updateSelectedPictograms(imageName, isSelected);
                      //   },
                      //   height: gridHeight,
                      //   selectColor: selectedPictograms.contains(imageName),
                      //   studentId: widget.studentId, // Pasamos el studentId
                      //   concatenatedPassword: concatenatedPassword,
                      //   selectedPictograms: selectedPictograms,
                      //   gridKey: resetKey,
                      //   clear: clear,
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
                      height: bottomContainerHeight,
                      width: bottomContainerHeight,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        if (isPasswordIncorrect)
          Positioned.fromRect(
            rect: Rect.fromCenter(
              center: Offset(
                MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 4,
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: MediaQuery.of(context).size.width - bottomContainerHeight,
            ),
          )
      ]),
    );
  }

  void updateSelectedPictograms(String imageName, bool isSelected) {
    setState(() {
      // if (isSelected) {
      //   selectedPictograms.add(imageName);
      // } else {
      //   selectedPictograms.remove(imageName);
      // }

      if (selectedPictograms.contains(imageName)) {
        selectedPictograms.remove(imageName);
      } else {
        selectedPictograms.add(imageName);
      }

      concatenatedPassword = selectedPictograms.join();
      print(concatenatedPassword);

      // Notificar cambios a través del callback
    });
    widget.onPasswordChanged(concatenatedPassword);

    print("Updated password " + concatenatedPassword);
    print("Updated array" + selectedPictograms.toString());
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
  final double width;
  final bool selectColor;
  final String studentId; // Agregamos el nuevo parámetro
  final String concatenatedPassword;
  List<String> selectedPictograms;
  final GlobalKey<PictogramGridViewState> gridKey; // Nueva línea
  final Function() showIncorrect;

  PictogramCard(
      {required this.imageName,
      required this.onSelected,
      required this.height,
      required this.width,
      required GlobalKey<_PictogramCardState> key,
      required this.selectColor,
      required this.studentId, // Agregamos el nuevo parámetro
      required this.concatenatedPassword,
      required this.selectedPictograms,
      required this.gridKey,
      required this.clear,
      required this.showIncorrect});

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
    // Color cardColor = widget.selectColor ? Colors.blue : Colors.transparent;
    // Color cardColor;
    // if (!isSelected) {
    //   cardColor = _colorfondo;
    // }

    return GestureDetector(
      onTap: () async {
        // setState(() {
        //   isSelected = !isSelected;
        // });
        widget.onSelected(isSelected);
        // isSelected = !isSelected;
        concatenatedPassword = widget.concatenatedPassword + widget.imageName;
        // setState(() {
        //   isSelected = !isSelected;
        //   _colorfondo = isSelected ? Colors.blue : Colors.transparent;
        //   widget.onSelected(isSelected);
        //   selectedPictograms = widget.selectedPictograms;
        //   concatenatedPassword = widget.concatenatedPassword;
        //   concatenatedPassword = concatenatedPassword + this.widget.imageName;
        // });
        if (widget.selectedPictograms.length >= 3) {
          Map<String, dynamic> loginResult =
              await _controller.login(widget.studentId, concatenatedPassword);
          // isSelected = false;

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
            widget.showIncorrect();
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return AlertDialog(
            //       title: Text('INTÉNTALO OTRA VEZ'),
            //       content: Row(
            //         children: [
            //           Icon(
            //             Icons
            //                 .sentiment_satisfied, // El icono de la cara sonriente
            //             color: Colors
            //                 .orange, // Puedes ajustar el color según tus preferencias
            //             size:
            //                 80.0, // Puedes ajustar el tamaño según tus preferencias
            //           ),
            //           SizedBox(
            //               width: 10.0), // Espaciado entre el icono y el texto
            //           Text(
            //             'ÁNIMO',
            //             style: TextStyle(
            //               fontSize:
            //                   20.0, // Ajusta el tamaño del texto según tus preferencias
            //             ),
            //           ),
            //         ],
            //       ),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             setState(() {
            //               // Llamar a la función para resetear las imágenes
            //               //_passwordGridKey.currentState?.resetSelectedImages();
            //               widget.gridKey.currentState?.resetSelectedImages();

            //               selectedPictograms.clear();
            //               selectedPictograms = [];

            //               Navigator.pop(context);
            //             });
            //           },
            //           child: Text('OK'),
            //         ),
            //       ],
            //     );
            //   },
            // );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.selectColor ? Colors.blue : Colors.transparent,
        ),
        child: SizedBox(
          height: widget.height / 2,
          width: widget.width / 3,
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