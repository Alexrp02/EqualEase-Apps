class Kitchen {

    constructor (kitchen) {
        this.assignedStudent = kitchen.assignedStudent;
        this.orders = kitchen.orders || [];
    }

    toJSON() {
        return {
            assignedStudent: this.assignedStudent,
            orders: this.orders
        };
    }
}

module.exports = Kitchen;