void main() async {
  print("hello from MAIN");
}

// void main() async {
//   print('Hey JUDE!!');

//   /////////////////////////////////////////////////////////////////////////////
//   print("///////////////////////////////////////////////////////////");
//   // Prueba de obtener una subtarea por su id
//   Subtask? subtask; // Declarar la variable fuera del bloque try como nullable
//   try {
//     subtask = await subtaskController.getSubtaskById("aAmlJnXo785HjgTrdewX");
//     // Realizar acciones con la subtask aquí
//   } catch (e) {
//     // Manejar errores aquí
//     print(e);
//   }

//   // Puedes utilizar 'subtask' fuera del bloque try
//   if (subtask != null) {
//     // Realizar acciones con 'subtask' aquí
//     print(subtask.id);
//     print(subtask.title);
//   }

//   /////////////////////////////////////////////////////////////////////////////
//   print("///////////////////////////////////////////////////////////");
//   // Prueba de obtener una subtarea por su titulo
//   Subtask? subtaskById;
//   try {
//     subtaskById = await subtaskController.getSubtaskByTitle("Ver la Champions");
//   } catch (e) {
//     print(e);
//   }

//   // Puedes utilizar 'subtask' fuera del bloque try
//   if (subtaskById != null) {
//     // Realizar acciones con 'subtask' aquí
//     print(subtaskById.id);
//     print(subtaskById.title);
//   }

//   /////////////////////////////////////////////////////////////////////////////
//   print("///////////////////////////////////////////////////////////");
//   // Prueba de obtener todas las subtareas
//   try {
//     List<Subtask> subtasksList = await subtaskController.getAllSubtasks();
//     for (var subtask in subtasksList) {
//       print(subtask.title);
//     }
//   } catch (e) {
//     print(e);
//   }

//   /////////////////////////////////////////////////////////////////////////////
//   print("///////////////////////////////////////////////////////////");
//   // Prueba de crear una subtarea
//   Subtask subtaskPOST = Subtask(
//     id: 'invalid',
//     title: 'tarea creada en DART',
//     description:
//         'tarea creada en DART, para volver a crear una nueva cambia el titulo.',
//   );

//   // print('subtask.id (in main before createSubtask): ${subtaskPOST.id}');
//   try {
//     await subtaskController.createSubtask(subtaskPOST);
//     // print('subtask.id (in main after createSubtask): ${subtaskPOST.id}');
//   } catch (e) {
//     print(e);
//   }

//   /////////////////////////////////////////////////////////////////////////////
//   print("///////////////////////////////////////////////////////////");
//   // Prueba de modificar una subtarea existente

//   // Obtenemos la tarea
//   Subtask? subtaskPUT;
//   try {
//     subtaskPUT = await subtaskController.getSubtaskByTitle(subtaskPOST.title);
//   } catch (e) {
//     print(e);
//   }

// // Modificamos la tarea
//   if (subtaskPUT != null) {
//     // modificamos la descripcion de la tarea por ejemplo.
//     // NO se debe modificar el id nunca.
//     // ¿¿El titulo se debe poder modificar??
//     subtaskPUT.description += " Además he sido modificada desde DART con PUT.";
//     try {
//       await subtaskController.updateSubtask(subtaskPUT);
//     } catch (e) {
//       print(e);
//     }
//   }
// }
