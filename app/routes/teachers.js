const express = require("express");
const TeachersController = require("../controllers/teachers");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)

api.post("/teacher", TeachersController.createTeacher);
api.get("/teacher/id/:id", TeachersController.getTeacherById);
api.get("/teacher/name/:name", TeachersController.getTeacherByName);
api.put("/teacher/id/:id", TeachersController.updateTeacher);
api.delete("/teacher/id/:id", TeachersController.deleteTeacher);

module.exports = api;
