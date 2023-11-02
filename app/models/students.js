class Student {

    constructor (student) {
        this.name = student.name;
        this.surname = student.surname;
        this.birthDate = student.birthDate;
        this.profilePicture = student.profilePicture || "";
        this.parentsContact = student.parentsContact;
        this.pendingTasks = student.pendingTasks || "";
        this.doneTasks = student.doneTasks || "";
    }

    toJSON() {
        return {
            name: this.name,
            surname: this.surname,
            birthDate: this.birthDate,
            profilePicture: this.profilePicture,
            parentsContact: this.parentsContact,
            pendingTasks: this.pendingTasks,
            doneTasks: this.doneTasks,
        };
    }
}

module.exports = Student;
