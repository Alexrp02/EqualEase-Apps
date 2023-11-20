const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Request = require("../models/requests.js");

const collectionName = "requests";

// Get request (id)
async function getRequest(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const data = snapshot.data();
            const requestObject = new Request(data);
            res.status(200).json({id: ref.id, ...requestObject });
        } else {
            res.status(404).json({ error: `Request with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting request from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get all requests
async function getRequests(req, res) {
    try {
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion "tasks" exista y tenga datos
        if(snapshot.empty) {
            res.status(400).json({ error: `${collectionName} collection does not exist or is empty.` });
            return;
        }

        // Mapea los documentos a objetos estructurados Task (pero incluyendo id)
        const requests = snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                id: doc.id, 
                ...data
            };
        });

        res.status(200).json( requests );
    } catch (error) {
        console.error("Error getting requests from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Get all requests from a certain student specified by id
async function getRequestsFromStudent(req, res) {
    const id = req.params.id;

    try {

        const studentQuery = query(collection(db, collectionName), where("assignedStudent", "==", id));
        const snapshot = await getDocs(studentQuery);
                
        if(snapshot.empty) {
            res.status(400).json({ error: `${collectionName}: student with id ${id} either does not exist or does not have requests assigned` });
            return;
        }

        // Mapea los documentos a objetos estructurados Request
        const requests = snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                id: doc.id, 
                ...data
            };
        });

        res.status(200).json( requests );
    } catch (error) {
        console.error("Error getting requests from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// create new request
async function createRequest(req, res) {
    const data = new Request(req.body);

    try {
        // Verificar campos vacíos y restricciones
        if (!data.assignedStudent) {
            res.status(400).json({ error: "Request's assigned Student cannot be empty." });
            return;
        }

        // Recorrer el array de items y comprobar si existen todos ellos
        if (data.items.length > 0) {
            const errors = [];

            await Promise.all(data.items.map(async (itemId) => {
                const itemRef = doc(db, "items", itemId);
                const itemSnapshot = await getDoc(itemRef);

                // Check if the item exists
                if (!itemSnapshot.exists()) {
                    errors.push(`Item with ID=${itemId} does not exist.`);
                }
            }));

            if (errors.length > 0) {
                // Si hay errores, enviar una respuesta con el array de errores
                res.status(400).json({ errors });
                return;
            }
        }

        // Comprobar si existe el alumno
        const studentRef = doc(db, "students", data.assignedStudent);
        const snapshot = await getDoc(studentRef);
        if (snapshot.exists()) {
            // Insertar nuevo request
            const ref = await addDoc(collection(db, collectionName), data.toJSON());
            console.log(`Inserted new request to student ${data.assignedStudent}).`);

            // Actualizar el flag de estudiante
            await updateStudentHasRequest(data.assignedStudent);

            // Devolver respuesta
            res.status(201).json({id: ref.id, ...data });
        } else {
            // Error, no existe el estudiante
            res.status(400).json({ error: `Request's assigned Student (studentId=${data.assignedStudent}) does not exist.` });
            return;
        }
    } catch (error) {
        console.error("Error creating item in Firestore:", error);
        res.status(500).send("Server error.");        
    }
}

// update request
async function updateRequest(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        // Comprobar si el documento existe
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización
            const previousStudent = snapshot.data().assignedStudent;

            // Si se desea cambiar el estudiante asignado, se comprueba si el nuevo existe
            if (updatedData.assignedStudent) {
                const studentRef = doc(db, "students", updatedData.assignedStudent);
                const studentSnapshot = await getDoc(studentRef);
                
                // Error, no existe el estudiante
                if(!studentSnapshot.exists()) {
                    res.status(400).json({ error: `Request's assigned Student (studentId=${updatedData.assignedStudent}) does not exist.` });
                    return;
                }

            }

            // Comprobar si los items existen
            if (updatedData.items  && updatedData.items.length > 0) {
                const errors = [];

                await Promise.all(updatedData.items.map(async (itemId) => {
                    const itemRef = doc(db, "items", itemId);
                    const itemSnapshot = await getDoc(itemRef);

                    // Check if the item exists
                    if (!itemSnapshot.exists()) {
                        errors.push(`Item with ID ${itemId} does not exist.`);
                    }
                }));

                if (errors.length > 0) {
                    // Si hay errores, enviar una respuesta con el array de errores
                    res.status(400).json({ errors });
                    return;
                }
            }

            // Si ha llegado hasta aquí, los datos son correctos, procede a actualizarlos
            await updateDoc(ref, updatedData);

            if(updatedData.assignedStudent) {
                await updateStudentHasRequest(previousStudent);
                await updateStudentHasRequest(updatedData.assignedStudent);
            }

            res.status(200).json({ message: `Request with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Request with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating request from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// delete request
async function deleteRequest(req, res) {
    // Eliminar todos los items que están en el array de items de la request a eliminar ??
    print("calling deleteItem!!");
}

// actualiza el flag de estudiante 'hasRequest'
// Para ello realiza una consulta en la colección requests y si encuentra algún
// registro cuyo assignedStudent==studentId entonces hasRequest = true
// en caso contrario lo establece a falso
// pre: el estudiante existe (studentId es válido)
async function updateStudentHasRequest(studentId) {

    try {
        const studentQuery = query(collection(db, collectionName), where("assignedStudent", "==", studentId));
        const snapshot = await getDocs(studentQuery);
                
        // Obtiene la referencia del estudiante y la modifica
        const ref = doc(db, "students", studentId);
        const hasRequest = !snapshot.empty;

        await updateDoc(ref, { hasRequest: hasRequest });
        console.log(`Modified student(id=${studentId}).hasRequest=${hasRequest}`);
    } catch (error) {
        console.error("Error updating student.hasRequest:", error);
    }
}


// Exportamos las funciones
module.exports = {
    getRequest,
    getRequests,
    getRequestsFromStudent,
    createRequest,
    updateRequest,
    deleteRequest
}