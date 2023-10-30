class Teacher {
    constructor(name, surname, email, students, profilePicture) {
        this.name = name;
        this.surname = surname;
        this.email = email;
        this.students = students;
        this.profilePicture = profilePicture;
    }

    constructor () {
        this.name = "";
        this.surname = "";
        this.email = "";
        this.students = [];
        this.profilePicture = "";
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