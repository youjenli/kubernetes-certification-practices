const express  = require('express');
const app = express();

// https://www.sitepoint.com/build-a-simple-web-server-with-node-js/
app.get('/healthz/return200', (req, res) => {
    res.send('helloworld')
});

const port = 80;
app.listen(port, () => {
    console.log(`Start listening on port ${port}`)
})