const express = require("express");
const SubtaskController = require("../controllers/subtasks");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar)

api.post("/subtask", SubtaskController.createSubtask);
api.get("/subtask", SubtaskController.getAllSubtasks);
api.get("/subtask/id/:id", SubtaskController.getSubtask);
api.get("/subtask/title/:title", SubtaskController.getSubtaskByTitle);
api.put("/subtask/id/:id", SubtaskController.updateSubtask);
api.delete("/subtask/id/:id", SubtaskController.deleteSubtask);

module.exports = api;
