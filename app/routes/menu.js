const express = require("express");
const MenuController = require("../controllers/menu");

const api = express.Router();

api.post("/menu", MenuController.createMenu);

api.get("/menu", MenuController.getMenus);
api.get("/menu/:id", MenuController.getMenu);

api.put("/menu/id/:id", MenuController.updateMenu);

api.delete("/menu/:id", MenuController.deleteMenu);

module.exports = api;
