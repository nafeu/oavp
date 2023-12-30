void webSocketServerEvent(String msg){
  println("[ oavp ] SOCKET EVENT RECEIVED");

  JSONArray receivedOavpObjects = parseJSONArray(msg);

  if (receivedOavpObjects == null) {
    println("[ oavp ] receivedOavpObjects JSONArray could not be parsed");
  } else {
    for (int i = 0; i < receivedOavpObjects.size(); i++) {
      JSONObject receivedOavpObject = receivedOavpObjects.getJSONObject(i);

      String objectClassName = receivedOavpObject.getString("oavpObject");
      String objectId = receivedOavpObject.getString("id");
      JSONArray objectParams = receivedOavpObject.getJSONArray("params");

      OavpVariable activeEditorVariable = objects.add(objectId, objectClassName);

      if (objectParams == null) {
        println("[ oavp ] objectParams JSONArray could not be parsed");
      } else {
        for (int j = 0; j < objectParams.size(); j++) {
          JSONObject objectParam = objectParams.getJSONObject(j);

          String paramId = objectParam.getString("id");
          String paramType = objectParam.getString("type");

          if (paramType.equals("String")) {
            String paramValue = objectParam.getString("value");

            activeEditorVariable.set(paramId, paramValue);
          } else if (paramType.equals("int")) {
            int paramValue = objectParam.getInt("value");

            activeEditorVariable.set(paramId, paramValue);
          } else if (paramType.equals("float")) {
            float paramValue = objectParam.getFloat("value");

            activeEditorVariable.set(paramId, paramValue);
          } else if (paramType.equals("color")) {
            color paramValue = objectParam.getInt("value");

            activeEditorVariable.set(paramId, paramValue);
          }
        }
      }
    }
  }
}

void webSocketConnectEvent(String uid, String ip) {
  println("[ oavp ] New websocket connection", uid, ip);
}

void webSocketDisconnectEvent(String uid, String ip) {
  println("[ oavp ] A websocket client disconnected", uid, ip);
}
