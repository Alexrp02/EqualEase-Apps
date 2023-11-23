const express = require("express");
const KitchenOrderController = require("../controllers/kitchen_orders");

const api = express.Router();

api.post("/kitchen-order", KitchenOrderController.createKitchenOrder);

api.get("/kitchen-order", KitchenOrderController.getKitchenOrders);
api.get("/kitchen-order/:id", KitchenOrderController.getKitchenOrder);

api.put("/kitchen-order/:id", KitchenOrderController.updateKitchenOrder);

module.exports = api;
