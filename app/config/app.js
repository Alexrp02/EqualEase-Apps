const express = require("express");

// Configuración de express e inicialización del servidor
const app = express();
// Antes de cargar las rutas, configuramos la app para que pueda
// recibir json.
app.use(express.json());
app.use(express.urlencoded({extended:true}));

// Cargar rutas (cargar aquí todas las rutas)
//const hello_routes = require("../routes/hello.js");
//const task_routes = require("../routes/tasks.js");

// Rutas base
//app.use("/api", hello_routes);
//app.use("/api", task_routes);

module.exports = {
    app,
};