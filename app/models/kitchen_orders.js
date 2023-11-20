class KitchenOrder {

    constructor (kitchenOrder) {
        this.assignedStudent = kitchenOrder.assignedStudent;
        this.orders = kitchenOrder.orders || [];
    }

    toJSON() {
        return {
            assignedStudent: this.assignedStudent,
            orders: this.orders
        };
    }
}

module.exports = KitchenOrder;