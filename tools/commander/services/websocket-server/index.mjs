import { COMMANDER_WEBSOCKET_SERVER_PORT } from "../../constants.mjs";

const setupWebsocketServer = ({ wsServer, wsClients }) => {
  console.log(
    `[ oavp-commander:websocket-server ] WebSocket server is running at ws://localhost:${COMMANDER_WEBSOCKET_SERVER_PORT}`,
  );

  wsServer.on("connection", (socket) => {
    console.log("[ oavp-commander:websocket-server ] Client connected");
    wsClients.add(socket);

    socket.on("message", (message) => {
      console.log(`[ oavp-commander:websocket-server ] Received: ${message}`);
    });

    socket.on("close", () => {
      console.log("[ oavp-commander:websocket-server ] Client disconnected");
    });
  });
};

export default setupWebsocketServer;
