class Student {

    constructor (student) {
        this.name = student.name;
        this.surname = student.surname;
        this.profilePicture = student.profilePicture || "";
        this.pendingTasks = student.pendingTasks || [];
        this.doneTasks = student.doneTasks || [];
        this.hasRequest = student.hasRequest || false;
        this.hasKitchenOrder = student.hasKitchenOrder || false;
        this.representation = student.representation || "image";
    }

    toJSON() {
        return {
            name: this.name,
            surname: this.surname,
            profilePicture: this.profilePicture,
            pendingTasks: this.pendingTasks,
            doneTasks: this.doneTasks,
            hasRequest: this.hasRequest,
            hasKitchenOrder: this.hasKitchenOrder,
            representation: this.representation
        };
    }
}

module.exports = Student;
