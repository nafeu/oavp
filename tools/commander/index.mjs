import WebSocket, { WebSocketServer } from "ws";

import { runDebugScript } from './debug.mjs';

import {
  COMMANDER_WEBSOCKET_SERVER_PORT,
  SKETCH_WEBSOCKET_SERVER_URL,
} from "./constants.mjs";

if (process.env.OAVP_DEBUG) {
  runDebugScript();
  process.exit(0);
}

import setupExpressServer from "./services/express-server/index.mjs";
import setupSketchSocketConnection from "./services/sketch-socket-connection/index.mjs";
import setupWebsocketServer from "./services/websocket-server/index.mjs";
import setupFilewatchEventHandlers from "./services/filewatch-event-handlers/index.mjs";

const ws = new WebSocket(SKETCH_WEBSOCKET_SERVER_URL);
const wsServer = new WebSocketServer({ port: COMMANDER_WEBSOCKET_SERVER_PORT });
const wsClients = new Set();

const main = () => {
  setupExpressServer(ws);
  setupSketchSocketConnection(ws, wsServer);
  setupWebsocketServer({ wsServer, wsClients });
  setupFilewatchEventHandlers(ws);
};

main();
