const { initializeApp } = require("firebase/app");
const { getFirestore, doc, getDoc } = require("firebase/firestore");

// Configuracion de la conexion con la BD: Google Firebase.
// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBslrAWwGdPuik-0B8BQDI1If2GlrKP7V8",
    authDomain: "equalease-128e1.firebaseapp.com",
    projectId: "equalease-128e1",
    storageBucket: "equalease-128e1.appspot.com",
    messagingSenderId: "410128800130",
    appId: "1:410128800130:web:6284f02ac5530cad72179b",
    measurementId: "G-KQB4HDZTZ4"
  };

// Inicialización de Firebase y Firestore
const initializeFirebase = () => {
    const firebaseApp = initializeApp(firebaseConfig);
    const db = getFirestore(firebaseApp);
    return db;
};

const db = initializeFirebase();

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
};
