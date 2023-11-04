// Cargamos el fichero app
const { app } = require("./config/app.js");
const port = 3000

// Levantamos el servidor
app.listen(port, () => {
  console.log(`API REST server is working on http://localhost:${port}`)
});
