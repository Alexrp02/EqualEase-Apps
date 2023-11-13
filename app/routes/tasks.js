const express = require("express");
const TaskController = require("../controllers/tasks");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)

api.post("/task", TaskController.createTask);

api.get("/task", TaskController.getTasks);
api.get("/task/type/:type", TaskController.getTasksByType);

api.get("/task/id/:id", TaskController.getTaskById);
api.get("/task/title/:title", TaskController.getTaskByTitle);

api.put("/task/id/:id", TaskController.updateTask);

api.delete("/task/id/:id", TaskController.deleteTask);

module.exports = api;
