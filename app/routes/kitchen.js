const express = require("express");
const KitchenController = require("../controllers/kitchen");

const api = express.Router();

api.post("/kitchen", KitchenController.createKitchenRequest);

api.get("/kitchen", KitchenController.getKitchenRequests);
api.get("/kitchen/id/:id", KitchenController.getKitchenRequestById);
api.get("/kitchen/student/:id", KitchenController.getKitchenRequestsFromStudent);

api.put("/kitchen/:id", KitchenController.updateKitchenRequest);

api.delete("/kitchen/:id", KitchenController.deleteKitchenRequest);

module.exports = api;
