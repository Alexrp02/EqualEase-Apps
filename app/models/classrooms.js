class Classroom {

    constructor (classroom) {
        this.letter = classroom.letter || "";
        this.assignedTeacher = classroom.assignedTeacher || "";
    }

    toJSON() {
        return {
            letter: this.letter,
            assignedTeacher: this.assignedTeacher
        };
    }
}

module.exports = Classroom;