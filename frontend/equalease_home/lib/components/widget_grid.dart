import 'package:flutter/material.dart';

class PictogramGridView extends StatefulWidget {
  final GlobalKey<PictogramGridViewState> gridKey;
  final Function(String) onPasswordChanged;

  PictogramGridView({
    required this.gridKey,
    required this.onPasswordChanged,
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

                    return PictogramCard(
                      key: cardKey,
                      imageName: imageName,
                      onSelected: (isSelected) {
                        updateSelectedPictograms(imageName, isSelected);
                      },
                      height: gridHeight,
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

  // Método para reiniciar las imágenes seleccionadas
  void resetSelectedImages() {
    setState(() {
      selectedPictograms.clear();
      concatenatedPassword = '';

      // Iterar sobre las tarjetas y reiniciar su estado y color
      for (final cardKey in cardKeys) {
        cardKey.currentState?.resetCardState();
      }
    });
  }
}

class PictogramCard extends StatefulWidget {
  final String imageName;
  final Function(bool isSelected) onSelected;
  final double height;

  PictogramCard({
    required this.imageName,
    required this.onSelected,
    required this.height,
    required GlobalKey<_PictogramCardState> key,
  });

  @override
  _PictogramCardState createState() => _PictogramCardState();
}

class _PictogramCardState extends State<PictogramCard> {
  bool isSelected = false;
  Color _colorfondo = Colors.transparent;

  void resetCardState() {
    setState(() {
      isSelected = false;
      _colorfondo = Colors.transparent;
      widget.onSelected(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = isSelected ? Colors.blue : Colors.transparent;
    
    if (!isSelected) {
      cardColor = _colorfondo;
    }
    //Color cardColor = _colorfondo;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.onSelected(isSelected);
        });
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