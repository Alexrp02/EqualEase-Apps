const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc} = require("firebase/firestore");
const { db } = require("../config/database.js");
const Teacher = require("../models/teachers.js");

const collectionName = "teachers";

// Create a teacher
async function createTeacher(req, res) {

    const teacherData = new Teacher(req.body);
  
    try {

        // Verificar campos vacíos
        if (!teacherData.name) {
            res.status(400).json({ error: "Teacher's name cannot be empty.'" });
            return;
        }

        if (!teacherData.surname) {
            res.status(400).json({ error: "Teacher's surname cannot be empty." });
            return;
        }

        if (!teacherData.email) {
            res.status(400).json({ error: "Teacher's email cannot be empty." });
            return;
        }

        // Verificar si el profesor ya existe.
        // Para ello se comprueba que el email no coincida.
        const validationQuery = query(collection(db, collectionName), where("email", "==", teacherData.email));
        const querySnapshot = await getDocs(validationQuery);

        if (!querySnapshot.empty) {
            // Si hay resultados en la consulta, significa que ya existe una tarea con el mismo título
            res.status(400).json({ error: `Teacher with email ${teacherData.email} already exists.` });
        } else {
            // Si no hay resultados, procedemos a crearla
            const ref = await addDoc(collection(db, collectionName), teacherData.toJSON());
                   
            console.log(`Created new teacher (name: ${teacherData.name}, surname: ${teacherData.surname}, email: ${teacherData.email}).`);
            res.status(201).json({id: ref.id, ...teacherData });
        }

    } catch (error) {
        console.error("Error creating teacher in Firestore:", error);
        res.status(500).send("Server error.");        
    }
}

// Get teacher (id)
async function getTeacherById(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const teacherData = snapshot.data();
            const teacher = new Teacher(teacherData);

            res.status(200).json({id: ref.id, ...teacher });
        } else {
            res.status(404).json({ error: `Teacher with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting teacher from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get teacher (name)
async function getTeacherByName(req, res) {
    const name = req.params.name; // Assuming the teacher's name is part of the route parameters

    try {
        // Query the Firestore collection to find a teacher with the specified name
        const nameQuery = query(collection(db, collectionName), where("name", "==", name));
        const querySnapshot = await getDocs(nameQuery);

        if (!querySnapshot.empty) {
            // Assuming you want to get the first teacher found with the specified name
            const teacherId = querySnapshot.docs[0].id;
            const teacherData = querySnapshot.docs[0].data();
            const teacher = new Teacher(teacherData);

            res.status(200).json({id: teacherId, ...teacher});
        } else {
            res.status(404).json({ error: `Teacher with name ${name} does not exist.` });
        }
    } catch (error) {
        console.error("Error getting teacher from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// update teacher's data
async function updateTeacher(req, res) {
    const id = req.params.id;
    const updatedData = req.body;

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización
            await updateDoc(ref, updatedData);
            res.status(200).json({ message: `Teacher with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Teacher with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating teacher from Firestore:", error);
        res.status(500).send("Server error.");
    }
}


// Exportamos las funciones
module.exports = {
    createTeacher,
    getTeacherById,
    getTeacherByName,
    updateTeacher
}