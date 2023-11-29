const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const KitchenOrder = require("../models/kitchen_orders.js");

const collectionName = "kitchen_orders";

async function createKitchenOrder(req, res) {
    const data = new KitchenOrder(req.body);

    try {
        // Verificar campos vacíos y restricciones
        if (!data.classroom) {
            res.status(400).json({ error: "Kitchen order's classroom cannot be empty." });
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

        // Comprobar si existe la clase
        const classroomRef = doc(db, "classrooms", data.classroom);
        const snapshot = await getDoc(classroomRef);
        if (snapshot.exists()) {
            // Insertar nuevo kitchen order
            const ref = await addDoc(collection(db, collectionName), data.toJSON());
            console.log(`Inserted new kitchen order for classroom ${data.classroom}).`);

            res.status(201).json({id: ref.id, ...data });
        } else {
            // Error, no existe el estudiante
            res.status(400).json({ error: `Request's classroom (classroomId=${data.classroom}) does not exist.` });
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

// update kitchen order (similar to create)
async function updateKitchenOrder(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        // Comprobar si el documento existe
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {

            // Si se desea cambiar el estudiante asignado, se comprueba si el nuevo existe
            if (updatedData.classroom) {
                const classroomRef = doc(db, "classrooms", updatedData.classroom);
                const classroomSnapshot = await getDoc(classroomRef);
                
                // Error, no existe el estudiante
                if(!classroomSnapshot.exists()) {
                    res.status(400).json({ error: `Kitchen Order's assigned classroom (classroomId=${updatedData.classroom}) does not exist.` });
                    return;
                }
            }

            // Comprobar si los orders son válidos
            // Verificar que existan los id de los menus y que la cantidad sea > 0
            if (updatedData.orders && updatedData.orders.length > 0) {
                const errors = [];

                await Promise.all(updatedData.orders.map(async (order) => {
                    const menu = order.menu;
                    const menuRef = doc(db, "menus", menu);
                    const menuSnapshot = await getDoc(menuRef);

                    // Check if the menu exists
                    if (!menuSnapshot.exists()) {
                        errors.push(`Menu with ID=${menu} does not exist.`);
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


async function getOrdersFromClass(req, res) {
    try {
        const currentDate = new Date();
        const currentDateString = currentDate.toISOString().split("T")[0];
        const kitchenQuery = query(collection(db, "kitchen_orders"), where("date", "==", currentDateString), where("classroom", "==", req.params.classroomID));
        const snapshot = await getDocs(kitchenQuery);
                
        if(snapshot.empty) {
            // Si no existe orden para la clase, lo creamos
            let request = new KitchenOrder({
                classroom: req.params.classroomID,
                orders: [],
                revised: false,
                date: currentDateString
            });

            // Obtenemos los menus y los añadimos a la orden con cantidad 0
            const menusQuery = query(collection(db, "menus"));
            const menusSnapshot = await getDocs(menusQuery);
            menusSnapshot.forEach((doc) => {
                request.orders.push({
                    menu: doc.id,
                    quantity: 0
                });
            });

            const ref = await addDoc(collection(db, "kitchen_orders"), request.toJSON());

            console.log(`Inserted new kitchen order for classroom ${req.params.classroom}).`);
            // Devolvemos la orden creada
            res.status(200).json({id: ref.id, ...request });
            return ;
        }
        
        // Si el snapshot no está vacío, creamos el objeto KitchenOrder y lo devolvemos
        const data = snapshot.docs[0].data();
        const request = new KitchenOrder(data);

        // Get all the menus from the database
        const menusQuery = query(collection(db, "menus"));
        const menusSnapshot = await getDocs(menusQuery);

        // Check if the request has a menu that isn´t in the database, if it does, delete it
        request.orders.forEach((order) => {
            const menuId = order.menu;
            if(!menusSnapshot.some(menu => menu.id === menuId)) {
                request.orders = request.orders.filter(order => order.menu !== menuId);
            }
        });

        // Check if the request has all the menus, if it doesn´t have one, add it with quantity 0
        menusSnapshot.forEach((doc) => {
            const menuId = doc.id;
            if(!request.orders.some(order => order.menu === menuId)) {
                request.orders.push({
                    menu: menuId,
                    quantity: 0
                });
            }
        }
        );

        res.status(200).json({id: snapshot.docs[0].id, ...request });
    } catch (error) {
        console.error("Error getting kitchen from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get the total quantity of each menu in the kitchen orders
async function getQuantities(req, res) {
    try {
        const currentDate = new Date();
        const currentDateString = currentDate.toISOString().split("T")[0];
        const kitchenQuery = query(collection(db, "kitchen_orders"), where("date", "==", currentDateString));
        const snapshot = await getDocs(kitchenQuery);
                
        if(snapshot.empty) {
            // Return am object with every menu on the database and quantity 0
            const menusQuery = query(collection(db, "menus"));
            const menusSnapshot = await getDocs(menusQuery);
            const quantities = {};
            menusSnapshot.forEach((doc) => {
                quantities[doc.id] = 0;
            });
            res.status(200).json( quantities );
            return ;
        }



        // Mapea los documentos a objetos estructurados Task (pero incluyendo id)
        const requests = snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                id: doc.id, 
                ...data
            };
        });

        // Creamos un objeto con la cantidad total de cada menu
        const quantities = {};
        requests.forEach((request) => {
            request.orders.forEach((order) => {
                if (order.menu in quantities) {
                    quantities[order.menu] += order.quantity;
                } else {
                    quantities[order.menu] = order.quantity;
                }
            });
        });

        res.status(200).json( quantities );
    } catch (error) {
        console.error("Error getting kitchen orders from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Exportamos las funciones
module.exports = {
    createKitchenOrder,
    getKitchenOrders,
    getKitchenOrder,
    updateKitchenOrder,
    getOrdersFromClass,
    getQuantities,
}