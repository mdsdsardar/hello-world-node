// Load the http module to create an HTTP server.
const http = require('http');

// Configure our HTTP server to respond with "Hello, World!" to all requests.
const server = http.createServer((req, res) => {
  // Set the response HTTP header with HTTP status and Content type
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  // Send the response body "Hello, World!"
  res.end('Hi, Mom!\n');
});

// Listen on port 3000 and IP address 127.0.0.1
const PORT = 3000;
const HOST = '0.0.0.0';
server.listen(PORT, HOST, () => {
  console.log(`Server is running at http://${HOST}:${PORT}/`);
});

