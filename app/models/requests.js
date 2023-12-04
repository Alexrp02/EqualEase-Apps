class Request {

    constructor (request) {
        this.assignedStudent = request.assignedStudent;
        this.items = request.items || [];
    }

    toJSON() {
        return {
            assignedStudent: this.assignedStudent,
            items: this.items
        };
    }
}

module.exports = Request;