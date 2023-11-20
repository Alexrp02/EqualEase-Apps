const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const KitchenOrder = require("../models/kitchen_orders.js");

const collectionName = "kitchen_orders";

async function createKitchenOrder(req, res) {
    const data = new KitchenOrder(req.body);

    try {
        // Verificar campos vacíos y restricciones
        if (!data.assignedStudent) {
            res.status(400).json({ error: "Kitchen order's assigned Student cannot be empty." });
            return;
        }

        // Verificar que existan los id de los menus y que la cantidad sea > 0
        if (data.orders.length > 0) {
            const errors = [];

            await Promise.all(data.orders.map(async (order) => {
                const menuId = order.menuId;
                const menuRef = doc(db, "menus", menuId);
                const menuSnapshot = await getDoc(menuRef);

                // Check if the menu exists
                if (!menuSnapshot.exists()) {
                    errors.push(`Menu with ID=${menuId} does not exist.`);
                }

                // Check if quantity is >= 0
                const quantity = order.quantity;
                if(!(quantity>=0)) {
                    errors.push("Quantity is less than 0");
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
            // Insertar nuevo kitchen order
            const ref = await addDoc(collection(db, collectionName), data.toJSON());

            // Aquí, actualizar al estudiante poniendo en hasRequest = true
            await updateStudentHasKitchenOrder(data.assignedStudent);
            console.log(`Inserted new kitchen order for student ${data.assignedStudent}).`);

            res.status(201).json({id: ref.id, ...data });
        } else {
            // Error, no existe el estudiante
            res.status(400).json({ error: `Request's assigned Student (studentId=${data.assignedStudent}) does not exist.` });
            return;
        }
    } catch (error) {
        console.error("Error creating kitchen order in Firestore:", error);
        res.status(500).send("Server error.");        
    }
}

// Get all requests
async function getKitchenOrders(req, res) {
    try {
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion exista y tenga datos
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
        console.error("Error getting kitchen orders from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Get kitchen order (id)
async function getKitchenOrder(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const data = snapshot.data();
            const object = new KitchenOrder(data);
            res.status(200).json({id: ref.id, ...object });
        } else {
            res.status(404).json({ error: `Kitchen order with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting kitchen order from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get all kitchen orders from a certain student specified by id
async function getKitchenOrdersFromStudent(req, res) {
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
        console.error("Error getting kitchen orders from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// update kitchen order (similar to create)
async function updateKitchenOrder(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        // Comprobar si el documento existe
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {

            // Obtenemos el anterior estudiante para posterior uso
            const previousStudent = snapshot.data().assignedStudent;

            // Si se desea cambiar el estudiante asignado, se comprueba si el nuevo existe
            if (updatedData.assignedStudent) {
                const studentRef = doc(db, "students", updatedData.assignedStudent);
                const studentSnapshot = await getDoc(studentRef);
                
                // Error, no existe el estudiante
                if(!studentSnapshot.exists()) {
                    res.status(400).json({ error: `Kitchen Order's assigned Student (studentId=${updatedData.assignedStudent}) does not exist.` });
                    return;
                }
            }

            // Comprobar si los orders son válidos
            // Verificar que existan los id de los menus y que la cantidad sea > 0
            if (updatedData.orders && updatedData.orders.length > 0) {
                const errors = [];

                await Promise.all(updatedData.orders.map(async (order) => {
                    const menuId = order.menuId;
                    const menuRef = doc(db, "menus", menuId);
                    const menuSnapshot = await getDoc(menuRef);

                    // Check if the menu exists
                    if (!menuSnapshot.exists()) {
                        errors.push(`Menu with ID=${menuId} does not exist.`);
                    }

                    // Check if quantity is >= 0
                    const quantity = order.quantity;
                    if(!(quantity>=0)) {
                        errors.push("Quantity is less than 0");
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

            //  En caso de que se hubiera cambiado el estudiante, actualizar el flag hasKitchenOrder de los dos estudiantes implicados
            if(updatedData.assignedStudent) {
                await updateStudentHasKitchenOrder(previousStudent);
                await updateStudentHasKitchenOrder(updatedData.assignedStudent);
            }

            // Devolver respuesta
            res.status(200).json({ message: `Kitchen Order with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Kitchen Order with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating Kitchen Order from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// delete kitchen request
async function deleteKitchenOrder(req, res) {
    const id = req.params.id;

    // No elimina los menus de la coleccion
    // Deberia actualizar al estudiante poniendo has kitchen order a su valor nuevo
    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // Obtener el assignedStudent para su posterior actualización
            const studentId = snapshot.data().assignedStudent;

            // Eliminar el pedido de cocina
            await deleteDoc(ref);
            console.log(`Deleted Kitchen Order with ID ${id}`);

            // Actualizar al estudiante
            await updateStudentHasKitchenOrder(studentId);

            // Devolver respuesta
            res.status(200).json({ message: `Safefully deleted kitchen order with id=${id}.` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Kitchen order with id=${id} does not exist.` });
        }
    } catch (error) {
        console.error("Error deleting kitchen order from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// actualiza el flag de estudiante 'hasKitchenOrder'
// Para ello realiza una consulta en la colección kitchen_orders y si encuentra algún
// registro cuyo assignedStudent==studentId entonces hasKitchenOrder = true
// en caso contrario lo establece a falso
// pre: el estudiante existe (studentId es válido)
async function updateStudentHasKitchenOrder(studentId) {

    try {
        const studentQuery = query(collection(db, collectionName), where("assignedStudent", "==", studentId));
        const snapshot = await getDocs(studentQuery);
                
        // Obtiene la referencia del estudiante y la modifica
        const ref = doc(db, "students", studentId);
        const hasKitchenOrder = !snapshot.empty;

        await updateDoc(ref, { hasKitchenOrder: hasKitchenOrder });
        console.log(`Modified student(id=${studentId}).hasKitchenOrder=${hasKitchenOrder}`);
    } catch (error) {
        console.error("Error updating student.hasKitchenOrder:", error);
    }
}

// Exportamos las funciones
module.exports = {
    createKitchenOrder,
    getKitchenOrders,
    getKitchenOrder,
    getKitchenOrdersFromStudent,
    updateKitchenOrder,
    deleteKitchenOrder
}