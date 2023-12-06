import 'package:flutter_test/flutter_test.dart';
import 'package:equalease_home/controllers/controller_api.dart';
import 'package:equalease_home/models/student.dart';

void main() {
  group('student-tests', () async {
    final controller = APIController();

    test('Prueba de creacion de Student', () async {
      // Arrange
      var student = Student(
          id: "invalid",
          name: "Andrés",
          surname: "Cruz",
          pendingTasks: [],
          doneTasks: [],
          profilePicture:
              "https://globalsymbols.com/uploads/production/image/imagefile/15796/17_15797_b04bbf21-b50f-4886-8cfe-6e1c033567f2.png",
          hasRequest: false,
          hasKitchenOrder: false,
          representation: "image");

      var previousID = student.id;

      // Act
      var result = await controller.createStudent(student);

      // Assert
      expect(result, true);
      expect(previousID, isNot(student.id));

      // Imprime la representación JSON del estudiante
      print(student.toJson());
    });
  });
}
