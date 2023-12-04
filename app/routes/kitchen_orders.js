const express = require("express");
const KitchenOrderController = require("../controllers/kitchen_orders");

const api = express.Router();

api.post("/kitchen-order", KitchenOrderController.createKitchenOrder);

api.get("/kitchen-order", KitchenOrderController.getKitchenOrders);
api.get("/kitchen-order/id/:id", KitchenOrderController.getKitchenOrder);
api.get("/kitchen-order/classroom/:classroomID", KitchenOrderController.getOrdersFromClass) ;
api.get("/kitchen-order/quantities", KitchenOrderController.getQuantities);

api.put("/kitchen-order/id/:id", KitchenOrderController.updateKitchenOrder);

module.exports = api;
