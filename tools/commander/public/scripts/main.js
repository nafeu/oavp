const $ = selector => document.querySelector(selector);

const socialMediaTemplate = `nafeuvisual.space ▶ link in bio

follow for more ▶ #landscapeart #art #generativeart #creativecoding #abstractlandscape`;

let selectedSketch = null;
let isLoading = false;
let idCounter = 0;
let socialMediaTextContent = '';

const oavpObjectPropertiesTypeMapping = {};

window.oavpObjectProperties.forEach(({ id, type }) => {
  oavpObjectPropertiesTypeMapping[id] = type;
});

let sketchSocket;

try {
  sketchSocket = new WebSocket('ws://localhost:6287/commands');
} catch(err) {
  console.log(`[ oavp-commander] Cannot connect to processing editor websocket server...`);
}

sketchSocket.addEventListener('open', (event) => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket connection opened.";
  console.log('WebSocket connection opened:', event);
});

sketchSocket.addEventListener('message', (event) => {
  const receivedData = JSON.parse(event.data);
  console.log('Received:', receivedData);
});

sketchSocket.addEventListener('error', (event) => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket error.";
  console.log('[ oavp-commander ] WebSocket error:', event);
});

sketchSocket.addEventListener('close', (event) => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket connection closed.";
  console.log('WebSocket connection closed:', event);
});

const commanderSocket = new WebSocket('ws://localhost:3002');

commanderSocket.addEventListener('open', (event) => {
  $('#commander-socket').textContent = "[ commander ] WebSocket connection opened.";
  console.log('WebSocket connection opened:', event);
});

commanderSocket.addEventListener('message', (event) => {
  const dataElement = $('#data');
  const receivedData = JSON.parse(event.data);

  if (receivedData.command === 'preset-builder-result') {
    dataElement.textContent = receivedData.data;
  }
});

commanderSocket.addEventListener('error', (event) => {
  $('#commander-socket').textContent = "[ commander ] WebSocket error.";
  console.error('WebSocket error:', event);
});

commanderSocket.addEventListener('close', (event) => {
  $('#commander-socket').textContent = "[ commander ] WebSocket connection closed.";
  console.log('WebSocket connection closed:', event);
});

// eslint-disable-next-line no-unused-vars
function debounce(func, delay) {
  let timeoutId;
  return function () {
    const context = this;
    const args = arguments;
    clearTimeout(timeoutId);
    timeoutId = setTimeout(function () {
      func.apply(context, args);
    }, delay);
  };
}

// eslint-disable-next-line no-unused-vars
function handleTextareaUpdate() {
  socialMediaTextContent = $('#social-media-text').value;
  window.sketchDataObjects[selectedSketch].socialMediaTextContent = socialMediaTextContent;
  handleClickSave();
}

function sendSocketCommand({ command, ...params }) {
  const responseElement = $('#response');
  responseElement.textContent += `SOCKET @ ${new Date().toLocaleString()} : ${command}\n`;
  sketchSocket.send(JSON.stringify({ command, ...params }));
}

// eslint-disable-next-line no-unused-vars
function sendApiCommand({ command, ...params }) {
  fetch('/api/command', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ command, ...params }),
  })
  .then(response => response.json())
  .then(data => {
    const responseElement = $('#response');
    const dataElement = $('#data');
    responseElement.textContent = `API @ ${new Date().toLocaleString()} : ${data.message}`;

    if (data.data) {
      if (command === 'generate') {
        let dataElementText = '';

        data.data.forEach(item => {
          dataElementText += `${item.id}\n${item.params.map((param, index) => `[${param.id} : ${param.value}]`).join(' ').trim()}\n\n`;
        })

        dataElementText += `Total Objects: ${data.data.length}`;
        dataElement.textContent = dataElementText;
      }
    }
  })
  .catch(error => {
    console.error('Error:', error);
    const responseElement = $('#response');
    responseElement.textContent = 'Error occurred during API request.';
  });
}

// eslint-disable-next-line no-unused-vars
function sendDebug({ command, ...params }) {
  console.log({ command, params });
}

function getPropertyName() {
  const propertyNameElement = $('#property-name')

  return propertyNameElement.value;
}

function getPropertyType() {
  const propertyNameElement = $('#property-name')

  return oavpObjectPropertiesTypeMapping[propertyNameElement.value];
}

// eslint-disable-next-line no-unused-vars
function getPropertyValue() {
  const propertyValueElement = $('#property-value');

  if (getPropertyType() !== 'String') {
    return Number(propertyValueElement.value);
  }

  return propertyValueElement.value;
}

function setSelectedProperty(property) {
  const propertyNameElement = $('#property-name');

  const lastButtonElement = $('#last-button');

  lastButtonElement.textContent = `Last button pressed: Select ${property}`;

  propertyNameElement.value = property;
}

// eslint-disable-next-line no-unused-vars
function setAndSendDirectEdit(property, value) {
  setSelectedProperty(property);
  sendSocketCommand({ command: 'direct-edit', name: getPropertyName(), type: getPropertyType(), value })
}

document.addEventListener("DOMContentLoaded", () => {
  $('#data').addEventListener('click', function () {
    const originalText = $('#data').textContent;
    const textarea = document.createElement('textarea');
    textarea.value = this.textContent;
    document.body.appendChild(textarea);
    textarea.select();
    document.execCommand('copy');
    document.body.removeChild(textarea);
    this.textContent = 'Copied to Clipboard!';
    setTimeout(() => {
      this.textContent = originalText;
    }, 1000);
  });

  $('#sketch-clipboard-button').addEventListener('click', function() {
    const textToCopy = $('#social-media-text').value;

    const tempTextarea = document.createElement('textarea');
    tempTextarea.value = textToCopy;
    document.body.appendChild(tempTextarea);
    tempTextarea.select();
    tempTextarea.setSelectionRange(0, 99999);

    document.execCommand('copy');
    document.body.removeChild(tempTextarea);
  });

  $('#social-media-text').addEventListener('input', debounce(handleTextareaUpdate, 200));
})

// eslint-disable-next-line no-unused-vars
function handleClickLoadSketch() {
  sendApiCommand({ command: 'load', sketchDataObject: window.sketchDataObjects[selectedSketch] })
}

// eslint-disable-next-line no-unused-vars
function handleClickReseedSketch() {
  sendApiCommand({ command: 'reseed', sketchDataObject: window.sketchDataObjects[selectedSketch] })
}

function rebuildSocialMediaText({ newId, newName, newPaletteString, save } = {}) {
  const { colors, tags, name, paletteString, id, socialMediaTextContent } = window.sketchDataObjects[selectedSketch];

  if (socialMediaTextContent) {
    $('#social-media-text').textContent = socialMediaTextContent;
    $('#social-media-text').value = socialMediaTextContent;
  } else {
    const encodedId = newId || id || '0000X';
    const encodedName = (newName || name || 'example_name')
      .split(' ')
      .join('_');

    const encodedPalette = newPaletteString
      || paletteString
      || Object.keys(colors).map(key => colors[key].value).join(' ');

/* Line-spacing specific constant - START */
    const socialMediaText = `${encodedId}_${encodedName}

${`palette ▶ ${encodedPalette}`}

${`objects ▶ ${tags.join(' ')}`}

${socialMediaTemplate}
`
/* Line-spacing specific constant - END */
    $("#social-media-text").textContent = socialMediaText;
    $("#social-media-text").value = socialMediaText;
  }

  if (save) {
    handleTextareaUpdate();
  }
}

// eslint-disable-next-line no-unused-vars
function handleClickViewSketch(filename) {
  selectedSketch = filename;

  $("#sketch-preview-image").style.backgroundImage = `url(${filename}.png)`;
  $("#sketch-filename").textContent = filename;

  rebuildSocialMediaText();

  react();
}

// eslint-disable-next-line no-unused-vars
function handleClickGenerateName() {
  if (!isLoading) {
    isLoading = true;

    $("#sketch-name-button").textContent = "Generating...";

    fetch('/api/name', { method: 'GET' })
      .then(response => response.json())
      .then(({ name }) => {
        window.sketchDataObjects[selectedSketch].name = name;

        rebuildSocialMediaText({ newName: name, save: true });

        $("#sketch-name-button").textContent = "Generate Name";

        isLoading = false;
      })
      .catch(error => {
        console.error(error);
        $("#sketch-name-button").textContent = "Generate Name";

        isLoading = false;
      });
  }
}

// eslint-disable-next-line no-unused-vars
function handleClickGeneratePalette() {
  if (!isLoading) {
    isLoading = true;

    $("#sketch-palette-button").textContent = "Generating..."

    fetch('/api/colors', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ colors: window.sketchDataObjects[selectedSketch].colors }),
    })
      .then(response => response.json())
      .then(({ colorNames }) => {
        window.sketchDataObjects[selectedSketch].paletteString = colorNames.join(' ');

        rebuildSocialMediaText({ newPaletteString: colorNames.join(' '), save: true });

        $("#sketch-palette-button").textContent = "Generate Palette"

        isLoading = false;
      })
      .catch(error => {
        console.error(error);
        $("#sketch-palette-button").textContent = "Generate Palette"

        isLoading = false;
      });
  }
}

// eslint-disable-next-line no-unused-vars
function handleClickSave() {
  if (!isLoading) {
    isLoading = true;

    $("#sketch-save-button").textContent = "Saving..."

    fetch('/api/save-sketch', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ filename: selectedSketch, sketchDataObject: window.sketchDataObjects[selectedSketch] }),
    })
      .then(response => response.json())
      .then(({ message }) => {
        console.log(message);

        $("#sketch-save-button").textContent = "Saved."

        isLoading = false;
      })
      .catch(error => {
        console.error(error);

        // eslint-disable-next-line no-undef
        alert(error);

        $("#sketch-save-button").textContent = "Error Saving"

        isLoading = false;
      });
  }
}

function formatNumberWithLeadingZeros(number) {
  if (number >= 0 && number <= 99999) {
    return String(number).padStart(5, '0');
  } else {
    console.error('Number is out of range (0 to 99999)');
    return null;
  }
}

// eslint-disable-next-line no-unused-vars
function handleClickIncrementId() {
  const newId = formatNumberWithLeadingZeros(++idCounter);

  window.sketchDataObjects[selectedSketch].id = newId;

  rebuildSocialMediaText({ newId, save: true })
}

// eslint-disable-next-line no-unused-vars
function handleClickDecrementId() {
  const newId = formatNumberWithLeadingZeros(--idCounter);

  window.sketchDataObjects[selectedSketch].id = newId;

  rebuildSocialMediaText({ newId, save: true })
}

// eslint-disable-next-line no-unused-vars
function handleClickCopyToClipboard() {
  $('#sketch-clipboard-button').textContent = 'Copied!';

  setTimeout(() => {
    $('#sketch-clipboard-button').textContent = 'Copy To Clipboard';
  }, 1000);
}

// eslint-disable-next-line no-unused-vars
function handleClickGenerateTimelapse() {
  console.log();

  if (!isLoading) {
    isLoading = true;

    $("#sketch-generate-timelapse-button").textContent = "Generating..."

    fetch('/api/generate-timelapse', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ sketchDataObject: window.sketchDataObjects[selectedSketch] }),
    })
      .then(response => response.json())
      .then(({ message }) => {
        $("#sketch-generate-timelapse-button").textContent = "Generate Timelapse"

        console.log(message);

        isLoading = false;
      })
      .catch(error => {
        console.error(error);
        $("#sketch-generate-timelapse-button").textContent = "Generate Timelapse"

        isLoading = false;
      });
  }
}

function react() {
  if (selectedSketch !== null) {
    $("#details-menu").style.display = 'block';
    $("#loaded-actions").style.display = 'flex';
  } else {
    $("#details-menu").style.display = 'none';
    $("#loaded-actions").style.display = 'none';
  }
}
