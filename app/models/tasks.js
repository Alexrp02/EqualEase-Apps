class Task {

    constructor (task) {
        this.title = task.title;
        this.description = task.description;
        this.subtasks = task.subtasks;
        this.image = task.image;
        this.type = task.type;
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