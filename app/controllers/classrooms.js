const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc} = require("firebase/firestore");
const { db } = require("../config/database.js");
const Classroom = require("../models/classrooms.js");

const collectionName = "classrooms";

// Get classrooms (all)
async function getClassrooms(req, res) {
    try {
        const snapshot = await getDocs(collection(db, collectionName));
        
        // Comprueba que la coleccion exista y tenga datos
        if(snapshot.empty) {
            res.status(400).json({ error: `${collectionName} collection does not exist or is empty.` });
            return;
        }

        // Mapea los documentos a objetos estructurados Classroom (pero incluyendo id)
        const classrooms = snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                id: doc.id, 
                ...data
            };
        });

        res.status(200).json( classrooms );
    } catch (error) {
        console.error("Error getting classrooms from Firestore:", error);
        res.status(500).send("Server error.");  
    }
}

// Get classroom (id)
async function getClassroom(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const data = snapshot.data();
            const classroom = new Classroom(data);

            res.status(200).json({id: ref.id, ...classroom });
        } else {
            res.status(404).json({ error: `Classroom with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting classroom from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Exportamos las funciones
module.exports = {
    getClassroom,
    getClassrooms,
}