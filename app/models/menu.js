class Menu {

    constructor (menu) {
        this.name = menu.name;
        this.image = menu.image || "";
    }

    toJSON() {
        return {
            name: this.name,
            image: this.image
        };
    }
}

module.exports = Menu;