class KitchenOrder {

    constructor (kitchenOrder) {
        this.classroom = kitchenOrder.classroom;
        this.revised = kitchenOrder.revised || false;
        this.orders = kitchenOrder.orders || [];
    }

    toJSON() {
        return {
            classroom: this.classroom,
            revised: this.revised,
            orders: this.orders
        };
    }
}

module.exports = KitchenOrder;