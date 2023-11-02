class Subtask {

    constructor(subtask) {
        this.title = subtask.title;
        this.description = subtask.description;
        this.images = subtask.images || [];
        this.pictograms = subtask.pictograms || [];
    }

    toJSON() {
        return {
            _id: this.title,
            title: this.title,
            description: this.description,
            images: this.images,
            pictograms: this.pictograms
        };
    }
}

module.exports = Subtask;
