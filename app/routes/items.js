const express = require("express");
const ItemController = require("../controllers/items");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)
api.get("/item/:id", ItemController.getItem);

module.exports = api;
