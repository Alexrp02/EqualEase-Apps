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
