class Kitchen {

    constructor (kitchen) {
        this.assignedStudent = kitchen.assignedStudent;
        this.orders = kitchen.orders || [];
        this.date = kitchen.date;
    }

    toJSON() {
        return {
            assignedStudent: this.assignedStudent,
            orders: this.orders,
            date: this.date
        };
    }
}

module.exports = Kitchen;