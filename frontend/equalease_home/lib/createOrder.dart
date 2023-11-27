import 'package:flutter/material.dart';





class createOrderPage extends StatelessWidget {
  final String studentId;

  createOrderPage(this.studentId);

  @override
  Widget build(BuildContext context) {
    // Lógica de la página CreateOrderPage usando el ID del estudiante
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order for Student $studentId'),
      ),
       // Contenido de la página CreateOrderPage,
    );
  }
}
