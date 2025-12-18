let pingCount = 0;
let pingInterval;
const PING_COUNT_RESET = 30;
const PING_INTERVAL_MS = 1000;

const setupSketchSocketConnection = (ws, wsServer) => {
  ws.on("open", () => {
    console.log(
      "[ oavp-commander:sketch-socket-connection ] WebSocket connection opened.",
    );

    pingInterval = setInterval(() => {
      if (pingCount === 0) {
        console.log(`[ oavp-commander:sketch-socket-connection ] Pinging...`)
      }

      ws.send(JSON.stringify({ command: 'ping' }));

      if (pingCount >= PING_COUNT_RESET) {
        pingCount = 0;
      } else {
        pingCount += 1;
      }
    }, PING_INTERVAL_MS)
  });

  ws.on("message", (data) => {
    try {
      const message = JSON.parse(data.toString());

      // If it's a screenshot message, broadcast it to all connected clients
      if (message.type === "screenshot") {
        wsServer.clients.forEach((client) => {
          if (client.readyState === 1) { // WebSocket.OPEN
            client.send(JSON.stringify(message));
          }
        });
      }
    } catch (error) {
      // Not JSON or other error, ignore
    }
  });

  ws.on("close", () => {
    clearInterval(pingInterval);

    console.log(
      "[ oavp-commander:sketch-socket-connection ] WebSocket connection closed",
    );
  });

  ws.on("error", (error) => {
    console.error(
      `[ oavp-commander:sketch-socket-connection ] WebSocket error (make sure oavp is running): ${error}`,
    );
  });
}

export default setupSketchSocketConnection;
