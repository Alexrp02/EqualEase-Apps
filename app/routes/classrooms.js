const express = require("express");
const ClassroomsController = require("../controllers/classrooms");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)

api.get("/classroom", ClassroomsController.getClassrooms);
api.get("/classroom/:id", ClassroomsController.getClassroom);

module.exports = api;
