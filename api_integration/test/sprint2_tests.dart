import 'package:test/test.dart';

// Controllers
import 'package:api_integration/controllers/controller_api.dart';

// Models
import 'package:api_integration/models/student.dart';
import 'package:api_integration/models/teacher.dart';
import 'package:api_integration/models/subtask.dart';
import 'package:api_integration/models/task.dart';
import 'package:api_integration/models/item.dart';
import 'package:api_integration/models/request.dart';

void main() {
  final apiController = APIController(); // Crea una instancia de APIController.

  test('getRequest works fine', () async {
    final requestId = 'KOipZ5TNMLyhgag8TbZD'; // Reemplaza con un ID válido.
    final request = await apiController.getRequest(requestId);

    // Asegúrate de que la solicitud no sea nula.
    expect(request, isNotNull);

    // Verifica si la solicitud es una instancia válida de Request.
    expect(request, isA<Request>());
  });

  test('getRequestsFromStudent works fine', () async {
    final studentId = 'BzeOSKjQKDhh2Da3JHYC'; // Reemplaza con un ID válido.
    final list = await apiController.getRequestsFromStudent(studentId);

    // Asegúrate de que la lista de solicitudes no sea nula y que contenga al menos una solicitud.
    expect(list, isNotNull);
    expect(list, isNotEmpty);

    // Verifica si los elementos de la lista son instancias válidas de Request.
    for (var element in list) {
      expect(element, isA<Request>());
    }
  });

  test('getItem works fine', () async {
    final itemId = 'NqJlJsy5PsrgKIRi7B4a'; // Reemplaza con un ID válido.
    final item = await apiController.getItem(itemId);

    // Asegúrate de que la solicitud no sea nula.
    expect(item, isNotNull);

    // Verifica si la solicitud es una instancia válida de Request.
    expect(item, isA<Item>());
  });

  test('getItemsFromRequest works fine', () async {
    final requestId = 'KOipZ5TNMLyhgag8TbZD'; // Reemplaza con un ID válido.
    final list = await apiController.getItemsFromRequest(requestId);

    // Asegúrate de que la lista de solicitudes no sea nula y que contenga al menos una solicitud.
    expect(list, isNotNull);
    expect(list, isNotEmpty);
    expect(list.length, 2);
    // Verifica si los elementos de la lista son instancias válidas de Request.
    for (var element in list) {
      expect(element, isA<Item>());
    }
  });

  test('createRequest works fine', () async {
    final request =
        Request(id: "invalid", assignedStudent: "AOe1OeoaREbyyI5s5HW8", items: [
      "62SdI3etezisxhDCtqYy",
      "NqJlJsy5PsrgKIRi7B4a",
      "yN4pW61avHXacUoRwlke",
      "yq7WRJDZAMwL8BIYNIOJ"
    ]);

    final previousId = request.id;

    final result = await apiController.createRequest(request);

    // Asegúrate de que el resultado de la creación sea verdadero.
    expect(result, isTrue);

    // Asegúrate de que el id cambió.
    expect(request.id, isNot(equals(previousId)));
  });

  test('createItem works fine', () async {
    final item = Item(
        id: "invalid",
        name: "Pegamento de Barra",
        pictogram: "",
        quantity: 12,
        size: "SMALL");

    final previousId = item.id;
    final previousName = item.name;

    final result = await apiController.createItem(item);

    // Asegúrate de que el resultado de la creación sea verdadero.
    expect(result, isTrue);

    // Asegúrate de que el id cambió.
    expect(item.id, isNot(equals(previousId)));

    // Asegurarse de que el nombre cambió a todo mayúsculas
    expect(item.name, equals(previousName.toUpperCase()));
  });

  test('update item works fine', () async {
    final id = 'GNm74Sdq7HPiPLGKmA5S';
    final item = await apiController.getItem(id);

    final previousQuantity = item.quantity;

    item.quantity += 2;

    final result = await apiController.updateItem(item);

    // Asegúrate de que el resultado de la creación sea verdadero.
    expect(result, isTrue);

    // Asegúrate de que el id cambió.
    expect(item.quantity, isNot(equals(previousQuantity)));
  });

  test('update request works fine', () async {
    final id = 'CJNX7WGBKJBKyrkhZpLs';
    final request = await apiController.getRequest(id);

    final previousLength = request.items.length;

    final itemId = 'GNm74Sdq7HPiPLGKmA5S';
    request.items.add(itemId);

    final result = await apiController.updateRequest(request);

    // Asegúrate de que el resultado de la creación sea verdadero.
    expect(result, isTrue);

    // Asegúrate de que el id cambió.
    expect(request.items.length, equals(previousLength + 1));
  });
}
