const express = require("express");
const ImageController = require("../controllers/images.js");

const api = express.Router();

// Métodos: post (crear), get(leer), put(actualizar), delete(eliminar)

api.post("/image", ImageController.uploadImage);

module.exports = api;
