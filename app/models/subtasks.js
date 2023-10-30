class Subtask {
    constructor() {
        this.title = '';
        this.description = '';
        this.images = [];
        this.pictograms = [];
    }

    toJSON() {
        return {
            title: this.title,
            description: this.description,
            images: this.images,
            pictograms: this.pictograms
        };
    }
}

module.exports = Subtask;
