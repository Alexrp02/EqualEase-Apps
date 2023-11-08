class Subtask {

    constructor(subtask) {
        this.title = subtask.title;
        this.description = subtask.description;
        this.image = subtask.image || "";
        this.pictogram = subtask.pictogram || "";
        this.audio = subtask.audio || "";
        this.video = subtask.video || "";
    }

    toJSON() {
        return {
            title: this.title,
            description: this.description,
            image: this.image,
            pictogram: this.pictogram,
            audio: this.audio,
            video: this.video
        };
    }
}

module.exports = Subtask;
