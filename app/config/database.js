const { initializeApp } = require("firebase/app");
const { getFirestore } = require("firebase/firestore");

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

module.exports = {
    db,
};
