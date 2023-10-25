import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<dynamic> _images = [];
  String _searchText = '';
  bool _selected = false;
  int _selectedNumber = 0;

  Future<void> _fetchImages() async {
    final response = await http
        .get(Uri.parse('https://api.arasaac.org/v1/pictograms/all/es'));
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      _images = List.filled(responseData.length, {});
    });
    // For each pictogram data, fetch the image url and add it to the images list
    for (var i = 0; i < responseData.length; i++) {
      final responseImage = await http.get(Uri.parse(
          'https://api.arasaac.org/v1/pictograms/${responseData[i]['_id']}?url=true&download=false'));
      final responseDataImage = json.decode(responseImage.body);
      setState(() {
        _images[i] = {'url': responseDataImage['image'], 'selected': false};
      });
      // responseData[i]['url'] = responseDataImage['image'];
    }
    print("Images fetched");
  }

  void _searchImages() async {
    final response = await http.get(Uri.parse(
        'https://api.arasaac.org/v1/pictograms/es/search/$_searchText'));
    final List<dynamic> responseData = json.decode(response.body);
    setState(() {
      _selected = false;
      _selectedNumber = 0;
      _images = List.generate(
          responseData.length, (index) => {'url': null, 'selected': false});
    });
    // For each pictogram data, fetch the image url and add it to the images list
    for (var i = 0; i < responseData.length; i++) {
      final responseImage = await http.get(Uri.parse(
          'https://api.arasaac.org/v1/pictograms/${responseData[i]['_id']}?url=true&download=false'));
      final responseDataImage = json.decode(responseImage.body);
      setState(() {
        _images[i] = {'url': responseDataImage['image'], 'selected': false};
      });
    }
    print("Images fetched");
  }

  @override
  void initState() {
    super.initState();
    // _fetchImages();
  }

  void _selectPhoto(int index) {
    setState(() {
      if (_images[index]['selected'] == null) {
        _images[index]['selected'] = true;
        setState(() {
          _selectedNumber++;
        });
      } else {
        _images[index]['selected'] = !_images[index]['selected'];
        if (_images[index]['selected'] == true) {
          setState(() {
            _selectedNumber++;
          });
        } else {
          setState(() {
            _selectedNumber--;
          });
        }
      }
      if (_selectedNumber == 0) {
        _selected = false;
      }
      print(_images[index]['selected']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Image Gallery'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  onSubmitted: (value) {
                    _searchImages();
                  },
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Búsqueda de pictogramas',
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: _searchImages,
                child: const Text('Buscar'),
              ),
              Expanded(
                child: Stack(children: [
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: () =>
                            {_selected = true, _selectPhoto(index)},
                        onTap: () {
                          if (!_selected) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Hero(
                                  tag: _images[index]['url'],
                                  child: ImageScreen(
                                      imageUrl: _images[index]['url']),
                                ),
                              ),
                            );
                          } else {
                            _selectPhoto(index);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: _images[index]['selected'] == true
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                          ),
                          child: _images[index]['url'] != null
                              ? Hero(
                                  tag: _images[index]['url'],
                                  child: Image.network(
                                    _images[index]['url'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  Visibility(
                    visible: _selectedNumber > 0,
                    child: Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          _selected = true;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            List<Map<String, dynamic>> copiedList = [];
                            for (var element in _images) {
                              if (element['selected'] == true) {
                                copiedList.add(Map.from(element));
                              }
                            }
                            return NewTaskScreen(images: copiedList);
                          }));
                        },
                        child: Text('$_selectedNumber'),
                      ),
                    ),
                  )
                ]),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  const ImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image'),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}

class NewTaskScreen extends StatefulWidget {
  final List<dynamic> images;

  const NewTaskScreen({super.key, required this.images});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState(images);
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _selected = false;
  List<dynamic> images = [];
  int _selectedNumber = 0;
  _NewTaskScreenState(this.images) {
    for (var element in images) {
      element['selected'] = false;
    }
  }

  void _selectPhoto(int index) {
    setState(() {
      if (widget.images[index]['selected'] == null) {
        widget.images[index]['selected'] = true;
        setState(() {
          _selectedNumber++;
        });
      } else {
        widget.images[index]['selected'] = !widget.images[index]['selected'];
        if (widget.images[index]['selected'] == true) {
          setState(() {
            _selectedNumber++;
          });
        } else {
          setState(() {
            _selectedNumber--;
          });
        }
      }
      if (_selectedNumber == 0) {
        _selected = false;
      }
      print(widget.images[index]['selected']);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(images);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: () => {_selected = true, _selectPhoto(index)},
              onTap: () {
                if (!_selected) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageScreen(imageUrl: images[index]['url']),
                    ),
                  );
                } else {
                  _selectPhoto(index);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: images[index]['selected'] == true
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: images[index]['url'] != null
                    ? Image.network(
                        images[index]['url'],
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            );
          }),
    );
  }
}
