const { addDoc, collection, query, where, getDocs, doc, getDoc, updateDoc } = require("firebase/firestore");
const { db } = require("../config/database.js");
const Student = require("../models/students.js");

const collectionName = "students";

async function getStudents(req, res) {
    try {
        const students = [];
        const querySnapshot = await getDocs(collection(db, collectionName));

        querySnapshot.forEach((doc) => {
            const studentData = doc.data();
            const student = new Student(studentData);

            students.push({ id: doc.id, ...student });
        });

        res.status(200).json(students);
    } catch (error) {
        console.error("Error getting students from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Create a student
async function createStudent(req, res) {
  const studentData = new Student(req.body);

  try {

      // Verificar campos vacíos
      if (!studentData.name) {
          res.status(400).json({ error: "Student's name cannot be empty.'" });
          return;
      }

      if (!studentData.surname) {
          res.status(400).json({ error: "Student's surname cannot be empty." });
          return;
      }

      // check if student exists. how??

      const ref = await addDoc(collection(db, collectionName), studentData.toJSON());
              
      console.log(`Created new student (name: ${studentData.name}, surname: ${studentData.surname}).`);
      res.status(201).json({id: ref.id, ...studentData });
      

  } catch (error) {
      console.error("Error creating student in Firestore:", error);
      res.status(500).send("Server error.");        
  }
}

// Get student (id)
async function getStudentById(req, res) {
    const id = req.params.id;

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const studentData = snapshot.data();
            const student = new Student(studentData);

            res.status(200).json({id: ref.id, ...student });
        } else {
            res.status(404).json({ error: `Student with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting student from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Get teacher (name)
async function getStudentByName(req, res) {
    const name = req.params.name; // Assuming the teacher's name is part of the route parameters

    try {
        // Query the Firestore collection to find a teacher with the specified name
        const nameQuery = query(collection(db, collectionName), where("name", "==", name));
        const querySnapshot = await getDocs(nameQuery);

        if (!querySnapshot.empty) {
            // Assuming you want to get the first teacher found with the specified name
            const studentId = querySnapshot.docs[0].id;
            const studentData = querySnapshot.docs[0].data();
            const student = new Student(studentData);

            res.status(200).json({id: studentId, ...student});
        } else {
            res.status(404).json({ error: `Student with name ${name} does not exist.` });
        }
    } catch (error) {
        console.error("Error getting student from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

async function updateStudent(req, res) {
    const id = req.params.id;
    const updatedData = req.body;
    console.log(updatedData);

    try {
        const ref = doc(db, collectionName, id);
        const snapshot = await getDoc(ref);

        if (snapshot.exists()) {
            // El documento existe, proceder a la actualización
            await updateDoc(ref, updatedData);
            res.status(200).json({ message: `Student with id=${id} updated successfully` });
        } else {
            // El documento no existe
            res.status(404).json({ error: `Student with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error updating student from Firestore:", error);
        res.status(500).send("Server error.");
    }
}

// Get pending tasks of today from student id
async function getPendingTasksToday(req, res) {
    const id = req.params.id;

    if (!id) {
        res.status(400).json({ error: "Student's id cannot be empty." });
        return;
    }

    try {
        // Obtener una referencia al documento de subtarea por su ID
        const ref = doc(db, collectionName, id);

        // Obtener el documento
        const snapshot = await getDoc(ref);

        // Comprobar si el documento de subtarea existe
        if (snapshot.exists()) {
            const studentData = snapshot.data();
            const student = new Student(studentData);
            const pendingTasksToday = student.pendingTasks.filter(task => {
                const currentDate = new Date();
                const weekDays = ["Domingo", "Lunes", "Martes", "Miercoles", "Jueves", "Viernes", "Sábado"] ;
                const startDate = new Date(task.startDate);
                const endDate = new Date(task.endDate);
                // Check if the current date is within the interval if there is one
                if (task.startDate && task.endDate && task.daysOfTheWeek) {
                    console.log("Task " + task.id + " has all the fields") ;
                    return (currentDate >= startDate && currentDate <= endDate) && (task.daysOfTheWeek.includes(weekDays[currentDate.getDay()]) || task.daysOfTheWeek.length == 0) ;
                }else if (task.startDate && task.endDate){
                    console.log("Task " + task.id + " has start and end date") ;
                    return (currentDate >= startDate && currentDate <= endDate);
                }else if(task.daysOfTheWeek){
                    console.log("Task " + task.id + " has days of week") ;
                    // Check if the current day of the week is in the days of the week array
                    return task.daysOfTheWeek.includes(weekDays[currentDate.getDay()]) || task.daysOfTheWeek.length == 0;
                }else if(!task.startDate && !task.endDate && !task.daysOfTheWeek){
                    console.log("Task " + task.id + " has no fields") ;
                    return true;
                }
                return false;
            });
            const pendingTasksIds = pendingTasksToday.map(task => task.id);

            res.status(200).json(pendingTasksIds);
        } else {
            res.status(404).json({ error: `Student with id=${id} does not exist.`});
        }
    } catch (error) {
        console.error("Error getting student from Firestore:", error);
        res.status(500).send("Server error.");   
    }
}

// Cuando se implemente la operación de eliminar estudiante,
// tener en cuenta las dependencias y eliminarlo de los arrays teacher.students[].
// Para ver como se implementa, ver el ejemplo deleteTask

// Exportamos las funciones
module.exports = {
    getStudents,
    createStudent,
    getStudentById,
    getStudentByName,
    updateStudent,
    getPendingTasksToday,
}