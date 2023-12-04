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

        // Comprobar que si hay tipo sea el correcto
        if (data.type && (data.type != "Menu" && data.type != "Postre")) {
            res.status(400).json({ error: "Error creating menu: Invalid type. It must be 'Menu' or 'Postre'." });
            return;
        }

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

            // Comprobar que si hay tipo sea el correcto
            if (updatedData.type && (updatedData.type != "Menu" && updatedData.type != "Postre")) {
                res.status(400).json({ error: "Error updating menu: Invalid type. It must be 'Menu' or 'Postre'." });
                return;
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

async function deleteMenu(req, res) {
    const id = req.params.id;

    if (!id) {
        res.status(400).json({ error: "Menu's id is required." });
        return;
    }

    try {
        // Comprobar si el documento existe
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la eliminación
            await deleteDoc(ref);
            res.status(204).json({ message: `Menu with id=${id} deleted successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Menu with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error deleting menu from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Exportamos las funciones
module.exports = {
    createMenu,
    getMenu,
    getMenus,
    updateMenu,
    deleteMenu,
}