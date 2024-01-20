const setupSketchSocketConnection = ws => {
  ws.on("open", () => {
    console.log(
      "[ oavp-commander:sketch-socket-connection ] WebSocket connection opened.",
    );
  });

  ws.on("close", () => {
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
