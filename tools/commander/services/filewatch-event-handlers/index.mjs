import fs from 'fs';

import {
  DIRECTORY_PATH,
  DUMP_FILE_PATH,
  EXPORT_FILE_DIR,
  EXPORT_FILE_NAME,
  EXPORT_IMAGE_NAME,
  TARGET_FILE_NAME,
  SANDBOX_CONCEPT_MAPS_FILE_NAME
} from '../../constants.mjs'

import {
  handlePresetEvent,
  handleExportFileEvent,
  handleExportImageEvent,
  handleSandboxConceptMapsFileEvent
} from './helpers.mjs'

const setupFilewatchEventHandlers = wsClients => {
  console.log([
    `[ oavp-commander:filewatch ] Watching for changes to ${TARGET_FILE_NAME}`,
    `[ oavp-commander:filewatch ] Watching for changes to ${EXPORT_FILE_NAME}`,
    `[ oavp-commander:filewatch ] Dumping generated presets into to ${DUMP_FILE_PATH}`,
    `[ oavp-commander:filewatch ] Saving exported sketches to ${EXPORT_FILE_DIR}`
  ].join('\n'));

  const logStream = fs.createWriteStream(DUMP_FILE_PATH, { flags: "a" });

  fs.watch(DIRECTORY_PATH, (eventType, filename) => {
    if (filename === TARGET_FILE_NAME) handlePresetEvent({ wsClients, logStream });
    if (filename === EXPORT_FILE_NAME) handleExportFileEvent();
    if (filename === EXPORT_IMAGE_NAME) handleExportImageEvent();
    if (filename === SANDBOX_CONCEPT_MAPS_FILE_NAME) handleSandboxConceptMapsFileEvent(wsClients);
  });
}

export default setupFilewatchEventHandlers;
