const express = require("express");
const multer = require("multer");

// Configuración de express e inicialización del servidor
const app = express();
const upload = multer({storage: multer.memoryStorage()});
// Antes de cargar las rutas, configuramos la app para que pueda
// recibir json.
app.use(express.json());
app.use(express.urlencoded({extended:true}));

// Cargar rutas (cargar aquí todas las rutas)
const subtask_routes = require("../routes/subtasks.js");
const student_routes = require("../routes/students.js");
const teacher_routes = require("../routes/teachers.js");
const task_routes = require("../routes/tasks.js");

// Rutas base
app.use("/api", upload.single("file"), subtask_routes);
app.use("/api", student_routes);
app.use("/api", teacher_routes);
app.use("/api", task_routes);



module.exports = {
    app,
};