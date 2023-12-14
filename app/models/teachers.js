class Teacher {

    constructor (teacher) {
        this.name = teacher.name;
        this.surname = teacher.surname;
        this.email = teacher.email;
        this.profilePicture = teacher.profilePicture || "";
        this.students = teacher.students || [];
        this.isAdmin = teacher.isAdmin || false;
    }

    toJSON() {
        return {
            name: this.name,
            surname: this.surname,
            email: this.email,
            profilePicture: this.profilePicture,
            students: this.students,
            isAdmin: this.isAdmin,
        };
    }
}

module.exports = Teacher;
