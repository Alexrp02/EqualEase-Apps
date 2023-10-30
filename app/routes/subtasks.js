const express = require("express");
const SubtaskController = require("../controllers/subtasks");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar)

api.post("/subtask", SubtaskController.createSubtask);
// api.get("/task", TaskController.getAllTasks);
// api.get("/task/:id", TaskController.getTask);
// api.put("/task/:id", TaskController.updateTask);
// api.delete("/task/:id", TaskController.deleteTask);


module.exports = api;
