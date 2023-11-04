class Student {

    constructor (student) {
        this.name = student.name;
        this.surname = student.surname;
        this.profilePicture = student.profilePicture || "";
        this.pendingTasks = student.pendingTasks || "";
        this.doneTasks = student.doneTasks || "";
    }

    toJSON() {
        return {
            name: this.name,
            surname: this.surname,
            profilePicture: this.profilePicture,
            pendingTasks: this.pendingTasks,
            doneTasks: this.doneTasks
        };
    }
}

module.exports = Student;
