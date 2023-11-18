const express = require("express");
const ItemController = require("../controllers/items");

const api = express.Router();

api.post("/item", ItemController.createItem);
api.get("/item/:id", ItemController.getItem);
api.put("/item/:id", ItemController.updateItem);
api.delete("/item/:id", ItemController.deleteItem);

module.exports = api;
