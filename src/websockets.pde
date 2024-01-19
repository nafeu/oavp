void webSocketServerEvent(String msg) {
  println("[ oavp ] Socket Event Received: " + msg);

  JSONObject message = parseJSONObject(msg);
  String command = message.getString("command");

  if (command.equals("write-objects")) {
    JSONArray receivedOavpObjects = message.getJSONArray("objects");

    noLoop();
    handleReceivedOavpObjects(receivedOavpObjects);
    loop();
  }
  else if (command.equals("reset")) {
    noLoop();
    objects.removeAll();
    loop();
  }
  else if (command.equals("save-preset")) {
    objects.exportObjectData();
  }
  else if (command.equals("randomize-palette")){
    randomizePalette();
    randomizeAllColors();
  }
  else if (command.equals("randomize-colors")) {
    randomizeAllColors();
  }
  else if (command.equals("feeling-lucky")) {
    JSONArray receivedOavpObjects = message.getJSONArray("objects");
    int seed = message.getInt("seed");

    noLoop();
    objects.removeAll();
    setSketchSeed(seed);
    handleReceivedOavpObjects(receivedOavpObjects);
    randomizePalette();
    randomizeAllColors();
    loop();
  }
  else if (command.equals("direct-edit")) {
    String propertyName = message.getString("name");
    String propertyType = message.getString("type");

    if (propertyType.equals("String")) {
      String propertyValue = message.getString("value");

      editor.externalDirectEdit(propertyName, propertyValue);
    } else if (propertyType.equals("int")) {
      int propertyValue = message.getInt("value");

      editor.externalDirectEdit(propertyName, propertyValue);
    } else if (propertyType.equals("float")) {
      float propertyValue = message.getFloat("value");

      editor.externalDirectEdit(propertyName, propertyValue);
    } else if (propertyType.equals("color")) {
      color propertyValue = message.getInt("value");

      editor.externalDirectEdit(propertyName, propertyValue);
    }
  }
  else if (command.equals("preview-edit")) {
    String propertyName = message.getString("name");
    String propertyType = message.getString("type");

    if (propertyType.equals("String")) {
      String propertyValue = message.getString("value");

      println("[ oavp ] Error: cannot preview-edit String");
    } else if (propertyType.equals("int")) {
      int propertyValue = message.getInt("value");

      editor.previewEdit(propertyName, propertyValue); editor.commitEdit(propertyName);
    } else if (propertyType.equals("float")) {
      float propertyValue = message.getFloat("value");

      editor.previewEdit(propertyName, propertyValue); editor.commitEdit(propertyName);
    } else if (propertyType.equals("color")) {
      color propertyValue = message.getInt("value");

      editor.previewEdit(propertyName, propertyValue); editor.commitEdit(propertyName);
    }
  }
  else if (command.equals("toggle-edit")) {
    editor.toggleEditMode();
  }
  else if (command.equals("next-object")) {
    objects.nextActiveVariable();
    updateEditorVariableMeta();
  }
  else if (command.equals("prev-object")) {
    objects.prevActiveVariable();
    updateEditorVariableMeta();
  }
  else if (command.equals("export-sketch")) {
    editor.queueExportSketchToFile();
  }
  else {
    println("[ oavp ] Command not recognized");
  }
}

void handleReceivedOavpObjects(JSONArray oavpObjects) {
  if (oavpObjects == null) {
    println("[ oavp ] oavpObjects JSONArray could not be parsed");
  } else {
    for (int i = 0; i < oavpObjects.size(); i++) {
      JSONObject receivedOavpObject = oavpObjects.getJSONObject(i);

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

            if (paramId.contains("variation")) {
              activeEditorVariable.set(paramId, activeEditorVariable.getVariationIndex(paramValue));
            } else {
              activeEditorVariable.set(paramId, paramValue);
            }

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
