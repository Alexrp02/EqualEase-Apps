import 'package:flutter/material.dart';

class DaysSelector extends StatefulWidget {
  @override
  _DaysSelectorState createState() => _DaysSelectorState();
}

class _DaysSelectorState extends State<DaysSelector> {
  List<String> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Days'),
      content: Column(
        children: [
          for (String day in [
            'Lunes',
            'Martes',
            'Miercoles',
            'Jueves',
            'Viernes',
            'Sábado',
            'Domingo'
          ])
            Row(
              children: [
                Checkbox(
                  value: selectedDays.contains(day),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        if (value) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                      }
                    });
                  },
                ),
                Text(day),
              ],
            ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(selectedDays);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
