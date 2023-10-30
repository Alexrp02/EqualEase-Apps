const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");

// Esto quizá sería mejor crear una subcarpeta /models que almacene
// la estructura de cada una de las colecciones. Y así separar el modelo.
// ¿Preguntar?

// Define la estructura de datos para las subtareas
const subtaskData = {
    title: '',          // Título de la subtarea (string)
    description: '',    // Descripción de la subtarea (string) - No puede estar vacía
    images: [],         // Array de imágenes
    pictograms: []      // Array de imágenes de pictogramas
};

// Crear una subtarea
async function createSubtask(req, res) {
    // Obtén los datos de la solicitud y asígnales los valores adecuados
    subtaskData.title = req.body.title;
    subtaskData.description = req.body.description;
    subtaskData.images = req.body.images || [];
    subtaskData.pictograms = req.body.pictograms || [];
  
    try {

        // Verificar campos vacíos
        if (!subtaskData.title) {
            res.status(400).json({ error: "Subtask title cannot be empty." });
            return;
        }

        if (!subtaskData.description) {
            res.status(400).json({ error: "Subtask description cannot be empty." });
            return;
        }

        // Verificar si ya existe una subtarea con el mismo titulo
        const subtaskQuery = query(collection(db, "subtasks"), where("title", "==", subtaskData.title));
        const subtaskQuerySnapshot = await getDocs(subtaskQuery);

        if (!subtaskQuerySnapshot.empty) {
            // Si hay resultados en la consulta, significa que ya existe una tarea con el mismo título
            res.status(400).json({ error: "La tarea ya existe." });
        } else {
            // Si no hay resultados, procedemos a crearla
            const subtaskRef = await addDoc(collection(db, "subtasks"), subtaskData);
        
            console.log("Subtarea creada exitosamente!");
            res.status(201).json({ subtask: { id: subtaskRef.id, ...subtaskData } });
        }

    } catch (error) {
      console.error("Error al crear la subtarea en Firestore:", error);
      res.status(500).send("Error en el servidor.");
    }
}

// Exportamos las funciones
module.exports = {
    createSubtask,

}