const express = require("express");
const KitchenOrderController = require("../controllers/kitchen_orders");

const api = express.Router();

api.post("/kitchen-order", KitchenOrderController.createKitchenOrder);

api.get("/kitchen-order", KitchenOrderController.getKitchenOrders);
api.get("/kitchen-order/id/:id", KitchenOrderController.getKitchenOrder);
api.get("/kitchen-order/student/:id", KitchenOrderController.getKitchenOrdersFromStudent);

api.put("/kitchen-order/:id", KitchenOrderController.updateKitchenOrder);

api.delete("/kitchen-order/:id", KitchenOrderController.deleteKitchenOrder);

module.exports = api;
