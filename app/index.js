// Cargamos el fichero app
const { app } = require("./config/app.js");
const port = 3000

// Levantamos el servidor
app.listen(port, () => {
  console.log(`API REST server is working on http://localhost:${port}`)
});

/*

// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore, collection, doc, setDoc, getDoc } from "firebase/firestore";
import express  from "express";

// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// API port
const PORT = 3000;

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBslrAWwGdPuik-0B8BQDI1If2GlrKP7V8",
  authDomain: "equalease-128e1.firebaseapp.com",
  projectId: "equalease-128e1",
  storageBucket: "equalease-128e1.appspot.com",
  messagingSenderId: "410128800130",
  appId: "1:410128800130:web:6284f02ac5530cad72179b",
  measurementId: "G-KQB4HDZTZ4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

const db = getFirestore(app);

const api = express() ;
api.use(express.json());

// Import route files
import tasksRoutes from "./routes/tasks.js";
import studentsRoutes from "./routes/students.js";
import teachersRoutes from "./routes/teachers.js";

api.use("/tasks", tasksRoutes);
api.use("/students", studentsRoutes);
api.use("/teachers", teachersRoutes);

api.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`) ;
})

*/