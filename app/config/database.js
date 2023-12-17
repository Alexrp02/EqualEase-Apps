const { initializeApp } = require("firebase/app");
const { getFirestore, doc, getDoc } = require("firebase/firestore");
const {getStorage} = require("firebase/storage");
const fs = require("fs");

//Load the configuration file
const configFile = fs.readFileSync("./config/config.json");


// Configuracion de la conexion con la BD: Google Firebase.
// Your web app's Firebase configuration
const firebaseConfig = JSON.parse(configFile);

const firebaseApp = initializeApp(firebaseConfig);

// Inicialización de Firebase y Firestore
const initializeFirebase = (firebaseApp) => {
    const db = getFirestore(firebaseApp);
    return db;
};

const initializeStorage = (firebaseApp) => {
    const storage = getStorage(firebaseApp);
    return storage;
}

const db = initializeFirebase(firebaseApp);

const storage = initializeStorage(firebaseApp);

// Función para realizar un "ping" periódico
async function pingFirestore() {
    const firestoreRef = doc(db, 'ping/ping'); // Utiliza una colección y documento de tu elección
    await getDoc(firestoreRef)
        .then(() => {
            console.log('Successful ping to Firestore.');
        })
        .catch((error) => {
            console.error('Ping error to Firestore', error);
        });
}

// Realiza un ping cada 5 minutos (para mantener la conexión del cliente firebase)
const pingInterval = 5 * 60 * 1000;
setInterval(pingFirestore, pingInterval);

module.exports = {
    db,
    storage,
};
