import 'package:flutter/material.dart';

class PictogramGridView extends StatefulWidget {
  @override
  _PictogramGridViewState createState() => _PictogramGridViewState();
}

class _PictogramGridViewState extends State<PictogramGridView> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pictogramas'),
      ),
      body: Column(
        children: [
          Container(
            height: 800,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: pictogramAssets.length,
              itemBuilder: (BuildContext context, int index) {
                final imageName = pictogramAssets[index];
                return PictogramCard(
                  imageName: imageName,
                  onSelected: (isSelected) {
                    updateSelectedPictograms(imageName, isSelected);
                  },
                );
              },
            ),
          ),
          Container(
                height: 100.0, // Altura del ListView
              alignment: Alignment.center,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedPictograms.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/${selectedPictograms[index]}.png',
                      height: 80.0, // Ajusta el tamaño según sea necesario
                      width: 80.0,
                      // fit: BoxFit.cover,
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

      // Actualizar la contraseña concatenando los nombres de los pictogramas
      concatenatedPassword = selectedPictograms.join();
      print(concatenatedPassword);
    });
  }
}

class PictogramCard extends StatefulWidget {
  final String imageName;
  final Function(bool isSelected) onSelected;

  PictogramCard({
    required this.imageName,
    required this.onSelected,
  });

  @override
  _PictogramCardState createState() => _PictogramCardState();
}

class _PictogramCardState extends State<PictogramCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.blue : null,
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            widget.onSelected(isSelected);
          });
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/${widget.imageName}.png',
                      // height: 120.0,
                      // width: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PictogramGridView(),
  ));
}
