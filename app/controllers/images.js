const { storageRef, ref, uploadBytesResumable, getDownloadURL } = require("firebase/storage");
const { db, storage } = require("../config/database.js");

async function uploadImage(req, res) {
    if(req.file && req.file.mimetype.startsWith("image/")){
        const folder = req.body.folder;
        const filename = req.body.filename;
        console.log("folder: ", folder);
        // Upload the image to Firebase Storage
       const storageRef = ref(storage, `${folder}/${filename}.jpg`);
       const metadata = {
           contentType: req.file.mimetype
       }
       const snapshot = await uploadBytesResumable(storageRef, req.file.buffer, metadata);
       const downloadURL = await getDownloadURL(snapshot.ref);
       console.log("File available at", downloadURL) ;

       res.status(201).json({image:downloadURL})
   }
}

module.exports = {
    uploadImage
};