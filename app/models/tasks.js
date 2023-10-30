class Task {

    constructor(title, description, subtasks, image, type) {
        this.title = title;
        this.description = description;
        this.subtasks = subtasks;
        this.image = image;
        this.type = type;
    }

    constructor () {
        this.title = "";
        this.description = "";
        this.subtasks = [];
        this.image = "";
        this.type = "";
    }

    toJSON() {
        return {
            title: this.title,
            description: this.description,
            subtasks: this.subtasks,
            image: this.image,
            type: this.type,
        };
    }
}

module.exports = Task;