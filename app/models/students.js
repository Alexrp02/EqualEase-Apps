class Student {
    constructor() {
        
            this.name= ""; // Nombre del alumno (string)
            this.surname= ""; // Apellidos del alumno (string)
            this.birthDate= ""; // Fecha de nacimiento (string)
            this.profilePicture= ""; // Imagen de perfil (string)
            this.parentsContact= ""; // Contacto de los padres (string)
            this.pendingTasks= []; // Array de referencias a tareas pendientes
            this.doneTasks= []; // Array de referencias a tareas completadas
          
    }

    // constructor (student) {
    //     this.name = student.name;
    //     this.surname = student.surname;
    //     this.birthDate = student.birthDate;
    //     this.profilePicture = student.profilePicture;
    //     this.parentsContact = student.parentsContact;
    //     this.pendingTasks = student.pendingTasks;
    //     this.doneTasks = student.doneTasks;
    // }

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
