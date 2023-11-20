const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc, deleteDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Menu = require("../models/menu.js");

const collectionName = "menus";

// Create menu
async function createMenu(req, res) {
    const data = new Menu(req.body);

    try {
        // Verificar campos vacíos y restricciones
        if (!data.name) {
            res.status(400).json({ error: "Menu's name cannot be empty." });
            return;
        }

        // El nombre debe estar en mayusculas
        const uppercaseName = data.name.toUpperCase();
        data.name = uppercaseName;

        const ref = await addDoc(collection(db, collectionName), data.toJSON());

        console.log(`Inserted new menu (name: ${data.name}).`);
        res.status(201).json({id: ref.id, ...data });

    } catch (error) {
        console.error("Error creating menu in Firestore:", error);
        res.status(500).send("Server error.");        
    }
}

// Get menu (id)
async function getMenu(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const data = snapshot.data();
            const menu = new Menu(data);
            res.status(200).json({id: ref.id, ...menu });
        } else {
            res.status(404).json({ error: `Menu with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting menu from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get all menus
async function getMenus(req, res) {
    try {
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion "menus" exista y tenga datos
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
        console.error("Error getting menus from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// update menu
async function updateMenu(req, res) {
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
            res.status(200).json({ message: `Menu with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Menu with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating menu from Firestore:", error);
        res.status(500).send("Menu error.");
    }
}

// delete menu
async function deleteMenu(req, res) {
    const id = req.params.id;
    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);
    
        if (snapshot.exists()) {
            // Eliminar referencia de los pedidos de cocina donde aparezca

            const kitchenOrderCollection = collection(db, "kitchen_orders");
            const kitchenOrderQuery = query(kitchenOrderCollection);
    
            const kitchenOrderSnapshot = await getDocs(kitchenOrderQuery);
    
            kitchenOrderSnapshot.forEach(async (kitchenOrderDoc) => {
                const kitchenOrderData = kitchenOrderDoc.data();

                // Comprobar si el menú está en orders.menuId
                const indexToRemove = kitchenOrderData.orders.findIndex(order => order.menuId === id);

                if (indexToRemove !== -1) {
                    // El menuId está presente en algún objeto de la propiedad orders
                    // Eliminar la fila del array orders
                    const updatedOrders = [...kitchenOrderData.orders];
                    updatedOrders.splice(indexToRemove, 1);

                    // Actualizar el documento con el nuevo array orders
                    await updateDoc(kitchenOrderDoc.ref, { orders: updatedOrders });

                    console.log(`Menu with ID ${id} found in kitchen order with ID ${kitchenOrderDoc.id}. Removed menu order.`);
                }
    
            });
    
            // Tras las comprobaciones, eliminar el menu
            await deleteDoc(ref);
            console.log(`Deleted Menu with ID ${id}`);
            res.status(200).json({ message: `Safefully deleted menu with id=${id}.` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Menu with id=${id} does not exist.` });
        }
    } catch (error) {
        console.error("Error deleting menu from Firestore:", error);
        res.status(500).send("Server error.");
    }

    // Eliminar referencia de los pedidos de cocina donde aparezca

    
    // Recorre los kitchenOrder.orders y si menuId.exists lo elimina
    
}

// Exportamos las funciones
module.exports = {
    createMenu,
    getMenu,
    getMenus,
    updateMenu,
    deleteMenu,
}