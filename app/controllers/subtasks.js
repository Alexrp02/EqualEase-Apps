const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Subtask = require("../models/subtasks.js");

// Crear una subtarea
async function createSubtask(req, res) {

    // Obtén los datos de la solicitud y asígnales los valores adecuados
    const subtaskData = new Subtask(req.body);
  
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
            const subtaskRef = await addDoc(collection(db, "subtasksPrueba"), subtaskData.toJSON());
                   
            console.log("Subtarea creada exitosamente!");
            res.status(201).json({id: subtaskRef.id, ...subtaskData });
        }

    } catch (error) {
      console.error("Error al crear la subtarea en Firestore:", error);
      res.status(500).send("Error en el servidor.");
    }
}

// Obtener todas las subtareas
async function getAllSubtasks(req, res) {
    try {
        // Realiza una consulta para obtener todos los documentos de la colección "subtasks"
        const subtaskCollection = collection(db, "subtasks");
        const subtaskSnapshot = await getDocs(subtaskCollection);
        
        // Comprueba que la coleccion "subtasks" exista.
        if(subtaskSnapshot.empty) {
            res.status(400).json({ error: "Subtask collection does not exist." });
            return;
        }

        // Mapea los documentos a objetos estructuras similares a Subtask (pero incluyendo id)
        const subtasks = subtaskSnapshot.docs.map((doc) => {
            const subtaskData = doc.data();
            return {
                id: doc.id,
                title: subtaskData.title,
                description: subtaskData.description,
                images: subtaskData.images,
                pictograms: subtaskData.pictograms
            };
        });

        res.status(200).json({ subtasks });
    } catch (error) {
        console.error("Error al obtener las subtareas:", error);
        res.status(500).send("Error en el servidor.");
    }
}

// Obtener una subtarea por id
async function getSubtask(req, res) {
    const idSubtask = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const subtaskRef = doc(db, "subtasks", idSubtask);

        // Obtener el documento
        const subtaskSnapshot = await getDoc(subtaskRef);

        // Comprobar si el documento de subtarea existe
        if (subtaskSnapshot.exists()) {
            const subtaskData = subtaskSnapshot.data();
            const subtask = new Subtask(subtaskData);

            res.status(200).json({id: subtaskRef.id, ...subtask });
        } else {
            res.status(404).json({ error: "La subtarea no existe." });
        }
    } catch (error) {
        console.error("Error al obtener la subtarea:", error);
        res.status(500).send("Error en el servidor.");
    }
}

async function getSubtaskByTitle(req, res) {
    const title = req.params.title;

    try {
        // Realizar una consulta para obtener la subtarea por título
        const subtaskCollection = collection(db, "subtasks");
        const subtaskQuery = query(subtaskCollection, where("title", "==", title));
        const subtaskQuerySnapshot = await getDocs(subtaskQuery);

        // Comprobar si hay resultados en la consulta
        if (!subtaskQuerySnapshot.empty) {
            // Obtener el primer documento que coincide con el título
            const subtaskDoc = subtaskQuerySnapshot.docs[0];
            const subtaskData = subtaskDoc.data();
            const subtask = new Subtask(subtaskData);

            res.status(200).json({id: subtaskDoc.id, ...subtask });
        } else {
            res.status(404).json({ error: "La subtarea no existe." });
        }
    } catch (error) {
        console.error("Error al obtener la subtarea por título:", error);
        res.status(500).send("Error en el servidor.");
    }
}


// Modificar/actualizar una subtarea creada -> Se deberá tener en cuenta
// el tratamiento de las imagenes y pictogramas (por ejemplo, añadiendo una
// imagen al array de imágenes). Pero por esta primera iteración es suficiente.
async function updateSubtask(req, res) {
    const idSubtask = req.params.id;
    const updatedData = req.body;

    try {
        // Obtener una referencia al documento que deseas actualizar
        const subtaskRef = doc(db, "subtasks", idSubtask);
        const subtaskSnapshot = await getDoc(subtaskRef);

        if (subtaskSnapshot.exists()) {
            // El documento existe, proceder a la actualización
            await updateDoc(subtaskRef, updatedData);
            res.status(200).json({ message: "Subtarea actualizada con éxito" });
        } else {
            // El documento no existe
            res.status(404).json({ error: "La subtarea no existe." });
        }
    } catch (error) {
        console.error("Error al actualizar la subtarea:", error);
        res.status(500).send("Error en el servidor.");
    }
}

// Eliminar una subtarea
async function deleteSubtask(req, res) {
    const idSubtask = req.params.id;

    try {
        // Obtener una referencia al documento que deseas eliminar
        const subtaskRef = doc(db, "subtasks", idSubtask);

        // Obtener el documento y comprobar si existe
        const subtaskSnapshot = await getDoc(subtaskRef);

        if (subtaskSnapshot.exists()) {
            // El documento existe, proceder a la eliminación
            await deleteDoc(subtaskRef);
            res.status(200).json({ message: "Subtarea eliminada con éxito" });
        } else {
            // El documento no existe
            res.status(404).json({ error: "La subtarea no existe." });
        }
    } catch (error) {
        console.error("Error al eliminar la subtarea:", error);
        res.status(500).send("Error en el servidor.");
    }
}

// Exportamos las funciones
module.exports = {
    createSubtask,
    getAllSubtasks,
    getSubtask,
    getSubtaskByTitle,
    updateSubtask,
    deleteSubtask,
}