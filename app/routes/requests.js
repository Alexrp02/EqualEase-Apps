const express = require("express");
const RequestController = require("../controllers/requests");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)
api.get("/request/id/:id", RequestController.getRequest);
api.get("/request", RequestController.getRequests);

// Devuelve los requests que tienen assignedStudent == id
api.get("/request/student/:id", RequestController.getRequestsFromStudent);

module.exports = api;
