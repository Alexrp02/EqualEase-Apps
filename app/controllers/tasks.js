const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Task = require("../models/tasks.js");

const collectionName = "tasks";

// Create a task
async function createTask(req, res) {
  const taskData = new Task(req.body);

  try {

        // Verificar campos vacíos y restricciones
        if (!taskData.title) {
            res.status(400).json({ error: "Task's title cannot be empty." });
            return;
        }

        if (!taskData.description) {
            res.status(400).json({ error: "Task's description cannot be empty." });
            return;
        }

        if(taskData.type!="FixedType" && taskData.type!="RequestType") {
            res.status(400).json({ error: "Task's type can only be FixedType or RequestType." });
            return;
        }

        // check if task already exists (based on name).
        // Title must be in capital letters

        const uppercaseTitle = taskData.title.toUpperCase();
        taskData.title = uppercaseTitle;

        const validationQuery = query(collection(db, collectionName), where("title", "==", taskData.title));
        const querySnapshot = await getDocs(validationQuery);

        if (!querySnapshot.empty) {
            // Si hay resultados en la consulta, significa que ya existe una tarea con el mismo título
            res.status(400).json({ error: `Task with title ${taskData.title} already exists.` });
        } else {
            // Si no hay resultados, procedemos a crearla
            const ref = await addDoc(collection(db, collectionName), taskData.toJSON());
                   
            console.log(`Created new task (title: ${taskData.title}).`);
            res.status(201).json({id: ref.id, ...taskData });
        }

  } catch (error) {
      console.error("Error creating student in Firestore:", error);
      res.status(500).send("Server error.");        
  }
}

// Get all tasks
async function getTasks(req, res) {
    try {
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion "tasks" exista y tenga datos
        if(snapshot.empty) {
            res.status(400).json({ error: `${collectionName} collection does not exist or is empty.` });
            return;
        }

        // Mapea los documentos a objetos estructurados Task (pero incluyendo id)
        const tasks = snapshot.docs.map((doc) => {
            const taskData = doc.data();
            return {
                id: doc.id, 
                ...taskData
            };
        });

        res.status(200).json( tasks );
    } catch (error) {
        console.error("Error getting tasks from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Get all tasks by filtered by type
async function getTasksByType(req, res) {
    
    const type = req.params.type;

    if(type!="FixedType" && type!="RequestType") {
        res.status(400).json({ error: "Task's type can only be FixedType or RequestType." });
        return;
    }

    try {
        const typeQuery = query(collection(db, collectionName), where("type", "==", type));
        const snapshot = await getDocs(typeQuery);
        
        // Comprueba que la coleccion "tasks" exista y tenga datos
        if(snapshot.empty) {
            res.status(400).json({ error: `There are no tasks with type ${type} yet.` });
            return;
        }

        // Mapea los documentos a objetos estructurados Task (pero incluyendo id)
        const tasks = snapshot.docs.map((doc) => {
            const taskData = doc.data();
            return {
                id: doc.id, 
                ...taskData
            };
        });

        res.status(200).json( tasks );
    } catch (error) {
        console.error("Error getting tasks (type: ${type}) from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Get task (id)
async function getTaskById(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const taskData = snapshot.data();
            const task = new Task(taskData);

            res.status(200).json({id: ref.id, ...task });
        } else {
            res.status(404).json({ error: `Task with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting task from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get task (title)
async function getTaskByTitle(req, res) {
    const title = req.params.title.toUpperCase();

    try {
        // Query the Firestore collection to find a teacher with the specified name
        const titleQuery = query(collection(db, collectionName), where("title", "==", title));
        const snapshot = await getDocs(titleQuery);

        if (!snapshot.empty) {
            // Assuming you want to get the first task found with the specified (title is unique).
            const taskId = snapshot.docs[0].id;
            const taskData = snapshot.docs[0].data();
            const task = new Task(taskData);

            res.status(200).json({id: taskId, ...task});
        } else {
            res.status(404).json({ error: `Task with title ${title} does not exist.` });
        }
    } catch (error) {
        console.error("Error getting task from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// update task
async function updateTask(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización

            // Comprobar si se desea actualizar el título y si ya existe una tarea con ese título
            if (updatedData.title) {

                // Convertir a mayúsculas
                const uppercaseTitle = updatedData.title.toUpperCase();
                updatedData.title = uppercaseTitle;

                const titleQuery = query(collection(db, collectionName), where("title", "==", updatedData.title));
                const querySnapshot = await getDocs(titleQuery);

                if (!querySnapshot.empty && querySnapshot.docs[0].id != id) {
                    res.status(400).json({ error: `Error updating task: A task with title ${updatedData.title} already exists.` });
                    return;
                }
            }

            // Comprobar si se desea actualizar el tipo y si es "RequestType" o "FixedType"
            if (updatedData.type && (updatedData.type != "RequestType" && updatedData.type != "FixedType")) {
                res.status(400).json({ error: "Error updating task: Invalid task type. It must be 'RequestType' or 'FixedType'." });
                return;
            }

            await updateDoc(ref, updatedData);
            res.status(200).json({ message: `Task with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Task with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating task from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// delete task
async function deleteTask(req, res) {
    const id = req.params.id;

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // Antes de eliminar una tarea, se deben eliminar sus referencias.
            // Recorrer todos los alumnos y comprobar si el id de la tarea está en los
            // array de pendingTasks y doneTasks.
            const studentsCollection = collection(db, "students");
            const studentsQuery = query(studentsCollection);

            const studentsSnapshot = await getDocs(studentsQuery);

            studentsSnapshot.forEach(async (studentDoc) => {
                const studentData = studentDoc.data();

                // Comprobar si la tarea está en el array de pendingTasks
                // if (studentData.pendingTasks.includes(id)) {
                //     const pendingTasks = studentData.pendingTasks.filter(taskId => taskId !== id);
                //     await updateDoc(studentDoc.ref, { pendingTasks });
                //     console.log(`Updated 'pendingTasks' for student (ID: ${studentDoc.ref.id}). Removed task with ID ${id}`);
                // }
                studentData.pendingTasks = studentData.pendingTasks.filter(taskId => taskId !== id);

                // Comprobar si la tarea está en el array de doneTasks
                // if (studentData.doneTasks.includes(id)) {
                //     const doneTasks = studentData.doneTasks.filter(taskId => taskId !== id);
                //     await updateDoc(studentDoc.ref, { doneTasks });
                //     console.log(`Updated 'doneTasks' for student (ID: ${studentDoc.ref.id}). Removed task with ID ${id}`);
                // }
                studentData.doneTasks = studentData.doneTasks.filter(taskId => taskId !== id);

                // Actualizar el documento del alumno
                await updateDoc(studentDoc.ref, studentData);
            });

            // Tras las comprobaciones, eliminar la tarea.
            await deleteDoc(ref);
            console.log(`Deleted task with ID ${id}`);
            res.status(200).json({ message: `Savefully deleted task with id=${id}.` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Task with id=${id} does not exist.` });
        }
    } catch (error) {
        console.error("Error deleting task from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Exportamos las funciones
module.exports = {
    createTask,
    getTasks,
    getTasksByType,
    getTaskById,
    getTaskByTitle,
    updateTask,
    deleteTask
}