class Task {

    constructor (task) {
        this.title = task.title;
        this.description = task.description || "";
        this.subtasks = task.subtasks || [];
        this.image = task.image || "";
        this.pictogram = task.pictogram || "";
        this.type = task.type || "FixedType";   // Can be FixedType or RequestType
    }

    toJSON() {
        return {
            title: this.title,
            description: this.description,
            subtasks: this.subtasks,
            image: this.image,
            pictogram: this.pictogram,
            type: this.type
        };
    }
}

module.exports = Task;