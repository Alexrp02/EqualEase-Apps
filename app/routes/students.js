const express = require("express");
const StudentsController = require("../controllers/students");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)

api.post("/student", StudentsController.createStudent);
api.get("/student", StudentsController.getStudents);
api.get("/student/tasks/:id", StudentsController.getPendingTasksToday);
api.get("/student/id/:id", StudentsController.getStudentById);
api.get("/student/name/:name", StudentsController.getStudentByName);
api.put("/student/id/:id", StudentsController.updateStudent);

module.exports = api;
