const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { storageRef, ref, uploadBytesResumable, getDownloadURL } = require("firebase/storage");
const { db, storage } = require("../config/database.js");
const Subtask = require("../models/subtasks.js");

const collectionName = "subtasks";

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

        // El título debe de estar en mayúsculas, por lo que lo convertimos.
        const uppercaseTitle = subtaskData.title.toUpperCase();
        subtaskData.title = uppercaseTitle;

        // Verificar si ya existe una subtarea con el mismo titulo
        const titleQuery = query(collection(db, collectionName), where("title", "==", subtaskData.title));
        const snapshot = await getDocs(titleQuery);

        if (!snapshot.empty) {
            res.status(400).json({ error: `Subtask with title ${subtaskData.title} already exists.` });
        } else {
            const docRef = await addDoc(collection(db, collectionName), subtaskData.toJSON());
                   
            console.log(`Created new subtask (title: ${subtaskData.title}).`);
            res.status(201).json({id: docRef.id, ...subtaskData });
        }

    } catch (error) {
        console.error("Error creating subtask in Firestore:", error);
        res.status(500).send("Server error."); 
    }
}

// Obtener todas las subtareas
async function getSubtasks(req, res) {
    try {
        // Realiza una consulta para obtener todos los documentos de la colección "subtasks"
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion "subtasks" exista.
        if(snapshot.empty) {
            res.status(400).json({ error: "Subtask collection is empty or does not exist." });
            return;
        }

        // Mapea los documentos a objetos estructuras similares a Subtask (pero incluyendo id)
        const subtasks = snapshot.docs.map((doc) => {
            const subtaskData = doc.data();
            return {
                id: doc.id,
                ...subtaskData
            };
        });

        res.status(200).json(subtasks);
    } catch (error) {
        console.error("Error getting subtasks from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Obtener una subtarea por id
async function getSubtaskById(req, res) {
    const id = req.params.id;

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const subtaskData = snapshot.data();
            const subtask = new Subtask(subtaskData);

            res.status(200).json({id: ref.id, ...subtask });
        } else {
            res.status(404).json({ error: `Subtask with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting subtask from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

async function getSubtaskByTitle(req, res) {
    const title = req.params.title.toUpperCase();

    try {
        // Realizar una consulta para obtener la subtarea por título
        const titleQuery = query(collection(db, collectionName), where("title", "==", title));
        const snapshot = await getDocs(titleQuery);

        // Comprobar si hay resultados en la consulta
        if (!snapshot.empty) {
            // Obtener el primer documento que coincide con el título (se supone que es único).
            const subtaskId = snapshot.docs[0].id;
            const subtaskData = snapshot.docs[0].data();
            const subtask = new Subtask(subtaskData);

            res.status(200).json({id: subtaskId, ...subtask});
        } else {
            res.status(404).json({ error: `Subtask with title ${title} does not exist.` });
        }
    } catch (error) {
        console.error("Error getting subtask from Firestore:", error);
        res.status(500).send("Server error.");
    }
}


// Actualizar una subtarea (aún no se tratan los media files)
async function updateSubtask(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        // Obtener una referencia al documento que deseas actualizar
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización

            // Comprobar si se desea actualizar el título y si ya existe una subtarea con ese título
            if (updatedData.title) {

                // Convertir a mayúsculas
                const uppercaseTitle = updatedData.title.toUpperCase();
                updatedData.title = uppercaseTitle;

                const titleQuery = query(collection(db, collectionName), where("title", "==", updatedData.title));
                const querySnapshot = await getDocs(titleQuery);

                if (!querySnapshot.empty && querySnapshot.docs[0].id != id) {
                    res.status(400).json({ error: `Error updating subtask: A subtask with title ${updatedData.title} already exists.` });
                    return;
                }
            }

            await updateDoc(ref, updatedData);
            res.status(200).json({ message: `Subtask with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Subtask with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating subtask from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// delete Subtask
async function deleteSubtask(req, res) {
    const id = req.params.id;

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // Antes de eliminar una subtarea, se deben eliminar sus referencias.
            // Recorrer todas las tareas y comprobar si el id de la subtarea está en los
            // array de subtasks.
            const tasksCollection = collection(db, "tasks");
            const tasksQuery = query(tasksCollection);

            const tasksSnapshot = await getDocs(tasksQuery);

            tasksSnapshot.forEach(async (taskDoc) => {
                const taskData = taskDoc.data();

                // Comprobar si la tarea está en el array de pendingTasks
                if (taskData.subtasks.includes(id)) {
                    const subtasks = taskData.subtasks.filter(subtaskId => subtaskId !== id);
                    await updateDoc(taskDoc.ref, { subtasks });
                    console.log(`Updated 'subtasks' for task (ID: ${taskDoc.ref.id}). Removed subtask with ID ${id}`);
                }

            });

            // Tras las comprobaciones, eliminar la subtarea.
            await deleteDoc(ref);
            console.log(`Deleted subtask with ID ${id}`);
            res.status(200).json({ message: `Savefully deleted subtask with id=${id}.` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Subtask with id=${id} does not exist.` });
        }
    } catch (error) {
        console.error("Error deleting subtask from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Exportamos las funciones
module.exports = {
    createSubtask,
    getSubtasks,
    getSubtaskById,
    getSubtaskByTitle,
    updateSubtask,
    deleteSubtask,
}