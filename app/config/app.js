const express = require("express");

// Configuración de express e inicialización del servidor
const app = express();
// Antes de cargar las rutas, configuramos la app para que pueda
// recibir json.
app.use(express.json());
app.use(express.urlencoded({extended:true}));

// Cargar rutas (cargar aquí todas las rutas)
const subtask_routes = require("../routes/subtasks.js");
const student_routes = require("../routes/students.js");

// Rutas base
app.use("/api", subtask_routes);
app.use("/students", student_routes);

module.exports = {
    app,
};