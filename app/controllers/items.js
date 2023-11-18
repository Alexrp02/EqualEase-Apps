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


// Exportamos las funciones
module.exports = {
    getItem,
    createItem
}