class KitchenOrder {

    constructor (kitchenOrder) {
        this.classroom = kitchenOrder.classroom;
        this.revised = kitchenOrder.revised || false;
        this.orders = kitchenOrder.orders || [];
        this.date = kitchenOrder.date;
    }

    toJSON() {
        return {
            classroom: this.classroom,
            revised: this.revised,
            orders: this.orders,
            date: this.date
        };
    }
}

module.exports = KitchenOrder;