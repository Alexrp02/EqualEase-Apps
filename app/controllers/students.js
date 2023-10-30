const {
  addDoc,
  collection,
  query,
  where,
  getDocs,
  doc,
  getDoc,
  updateDoc,
  deleteDoc,
} = require("firebase/firestore");
const { db } = require("../config/database.js");

// Esto quizá sería mejor crear una subcarpeta /models que almacene
// la estructura de cada una de las colecciones. Y así separar el modelo.
// ¿Preguntar?

// Define la estructura de datos para las subtareas
const studentData = {
  name: "", // Nombre del alumno (string)
  surname: "", // Apellidos del alumno (string)
  birthDate: "", // Fecha de nacimiento (string)
  profilePicture: "", // Imagen de perfil (string)
  parentsContact: "", // Contacto de los padres (string)
  pendingTasks: [], // Array de referencias a tareas pendientes
  doneTasks: [], // Array de referencias a tareas completadas
};

// Crear una subtarea
async function createStudent(req, res) {
  // Obtén los datos de la solicitud y asígnales los valores adecuados
  studentData.name = req.body.name;
  studentData.surname = req.body.surname;
  studentData.birthDate = req.body.birthDate;
  studentData.profilePicture = req.body.profilePicture || "";
  studentData.parentsContact = req.body.parentsContact;
  studentData.pendingTasks = req.body.pendingTasks || [];
  studentData.doneTasks = req.body.doneTasks || [];

  try {
    // Verificar campos vacíos
    if (!studentData.name) {
      res.status(400).json({ error: "Student's name can't be empty." });
      return;
    }

    if (!studentData.surname) {
      res.status(400).json({ error: "Student's surname can't be empty." });
      return;
    }

    if (!studentData.birthDate) {
      res.status(400).json({ error: "Student's birthdate can't be empty." });
      return;
    }

    if (!studentData.parentsContact) {
      res
        .status(400)
        .json({ error: "Student's partents contact can't be empty." });
      return;
    }

    // Verificar si ya existe una subtarea con el mismo titulo
    const studentQuery = query(
      collection(db, "Students"),
      where("name", "==", studentData.name),
      where("surname", "==", studentData.surname)
    );
    const studentQuerySnapshot = await getDocs(studentQuery);

    if (!studentQuerySnapshot.empty) {
      // Si hay resultados en la consulta, significa que ya existe una tarea con el mismo título
      res
        .status(400)
        .json({ error: "El estudiante ya está en la base de datos" });
    } else {
      // Si no hay resultados, procedemos a crearla
      const studentRef = await addDoc(collection(db, "Students"), studentData);

      console.log(
        "Estudiante añadido a la base de datos con ID: ",
        studentRef.id
      );
      res.status(201).json({ student: { id: studentRef.id, ...studentData } });
    }
  } catch (error) {
    console.error("Error al crear el estudiante en Firestore:", error);
    res.status(500).send("Error en el servidor.");
  }
}

// Exportamos las funciones
module.exports = {
  createStudent,
};
