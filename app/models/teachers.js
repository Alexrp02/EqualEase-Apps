class Teacher {

    constructor (teacher) {
        this.name = teacher.name;
        this.surname = teacher.surname;
        this.email = teacher.email;
        this.students = teacher.students;
        this.profilePicture = teacher.profilePicture;
    }

    toJSON() {
        return {
            name: this.name,
            surname: this.surname,
            email: this.email,
            students: this.students,
            profilePicture: this.profilePicture,
        };
    }
}