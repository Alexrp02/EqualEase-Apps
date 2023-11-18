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

        // Comprobar si existe el alumno
        const studentRef = doc(db, "students", data.assignedStudent);
        const snapshot = await getDoc(studentRef);
        if (snapshot.exists()) {
            // Insertar nuevo request
            const ref = await addDoc(collection(db, collectionName), data.toJSON());

            console.log(`Inserted new request to student ${data.assignedStudent}).`);
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


// Exportamos las funciones
module.exports = {
    getRequest,
    getRequests,
    getRequestsFromStudent,
    createRequest,
}