const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Item = require("../models/items.js");

const collectionName = "items";

// Get item (id)
async function getItem(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const data = snapshot.data();
            const item = new Item(data);
            res.status(200).json({id: ref.id, ...item });
        } else {
            res.status(404).json({ error: `Item with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting item from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// create new item
async function createItem(req, res) {
    const data = new Item(req.body);

    try {
        // Verificar campos vacíos y restricciones
        if (!data.name) {
            res.status(400).json({ error: "Item's name cannot be empty." });
            return;
        }

        // El nombre debe estar en mayusculas
        const uppercaseName = data.name.toUpperCase();
        data.name = uppercaseName;

        const ref = await addDoc(collection(db, collectionName), data.toJSON());

        console.log(`Inserted new item (name: ${data.name}).`);
        res.status(201).json({id: ref.id, ...data });

    } catch (error) {
        console.error("Error creating item in Firestore:", error);
        res.status(500).send("Server error.");        
    }
}

// update item
async function updateItem(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        // Comprobar si el documento existe
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización

            // Comprobar si se desea actualizar el nombre, convertir a mayúsculas
            if (updatedData.name) {
                const uppercase = updatedData.name.toUpperCase();
                updatedData.name = uppercase;
            }

            await updateDoc(ref, updatedData);
            res.status(200).json({ message: `Item with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `item with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating item from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// delete item
async function deleteItem(req, res) {
    print("calling deleteItem!!");
}


//     const id = req.params.id;

//     try {
//         const ref = doc(db, collectionName, id);
//         const snapshot = await getDoc(ref);

//         if (snapshot.exists()) {
//             // Antes de eliminar un item, se deben eliminar sus referencias.
//             // Se debe recorrer todos los array de los requests y eliminar su referencia.

//             const studentsCollection = collection(db, "students");
//             const studentsQuery = query(studentsCollection);

//             const studentsSnapshot = await getDocs(studentsQuery);

//             studentsSnapshot.forEach(async (studentDoc) => {
//                 const studentData = studentDoc.data();

//                 // Comprobar si la tarea está en el array de pendingTasks
//                 if (studentData.pendingTasks.includes(id)) {
//                     const pendingTasks = studentData.pendingTasks.filter(taskId => taskId !== id);
//                     await updateDoc(studentDoc.ref, { pendingTasks });
//                     console.log(`Updated 'pendingTasks' for student (ID: ${studentDoc.ref.id}). Removed task with ID ${id}`);
//                 }

//                 // Comprobar si la tarea está en el array de doneTasks
//                 if (studentData.doneTasks.includes(id)) {
//                     const doneTasks = studentData.doneTasks.filter(taskId => taskId !== id);
//                     await updateDoc(studentDoc.ref, { doneTasks });
//                     console.log(`Updated 'doneTasks' for student (ID: ${studentDoc.ref.id}). Removed task with ID ${id}`);
//                 }
//             });

//             // Tras las comprobaciones, eliminar la tarea.
//             await deleteDoc(ref);
//             console.log(`Deleted task with ID ${id}`);
//             res.status(200).json({ message: `Savefully deleted task with id=${id}.` });
//         } else {
//             // El documento no existe
//             res.status(404).json({ error: `Task with id=${id} does not exist.` });
//         }
//     } catch (error) {
//         console.error("Error deleting task from Firestore:", error);
//         res.status(500).send("Server error.");
//     }
// }


// Exportamos las funciones
module.exports = {
    getItem,
    createItem,
    updateItem,
    deleteItem,
}