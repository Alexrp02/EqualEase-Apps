class Item {

    constructor (item) {
        this.name = item.name;
        this.pictogram = item.pictogram || "";
        this.quantity = item.quantity || 1;
        this.size = item.size || "";
    }

    toJSON() {
        return {
            name: this.name,
            pictogram: this.pictogram,
            quantity: this.quantity,
            size: this.size,
        };
    }
}

module.exports = Item;