class Menu {

    constructor (menu) {
        this.name = menu.name;
        this.image = menu.image || "";
        this.type = menu.type || "Menu";
    }

    toJSON() {
        return {
            name: this.name,
            image: this.image,
            type: this.type
        };
    }
}

module.exports = Menu;