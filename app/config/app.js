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
const student_routes = require("../routes/students.js");
const teacher_routes = require("../routes/teachers.js");
const classroom_routes = require("../routes/classrooms.js");

const subtask_routes = require("../routes/subtasks.js");
const task_routes = require("../routes/tasks.js");
const images_routes = require("../routes/images.js");

const item_routes = require("../routes/items.js");
const request_routes = require("../routes/requests.js");

const menu_routes = require("../routes/menu.js");
const kitchen_order_routes = require("../routes/kitchen_orders.js");
const kitchen_routes = require("../routes/kitchen.js")

// Rutas base
app.use("/api", student_routes);
app.use("/api", teacher_routes);
app.use("/api", classroom_routes);

app.use("/api", subtask_routes);
app.use("/api", task_routes);
app.use("/api", upload.single("image"), images_routes);

app.use("/api", item_routes);
app.use("/api", request_routes);

app.use("/api", menu_routes);
app.use("/api", kitchen_order_routes);
app.use("/api", kitchen_routes);


module.exports = {
    app,
};