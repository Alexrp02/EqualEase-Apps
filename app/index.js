const { initializeApp } = require('firebase/app');
const { getFirestore, collection, doc, getDoc} = require('firebase/firestore');
const express = require('express');
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyBslrAWwGdPuik-0B8BQDI1If2GlrKP7V8",
  authDomain: "equalease-128e1.firebaseapp.com",
  projectId: "equalease-128e1",
  storageBucket: "equalease-128e1.appspot.com",
  messagingSenderId: "410128800130",
  appId: "1:410128800130:web:6284f02ac5530cad72179b",
  measurementId: "G-KQB4HDZTZ4"
};

const api = express() ;
api.use(express.json());

// Initialize Firebase
const app = initializeApp(firebaseConfig);

const db = getFirestore(app);

const citiesRef = collection(db, "cities");

async function getcity(){

const docRef = doc(db, "cities", "SF");
const docSnap = await getDoc(docRef);

if (docSnap.exists()) {
  console.log("Document data:", docSnap.data());
} else {
  // docSnap.data() will be undefined in this case
  console.log("No such document!");
}
}

getcity();