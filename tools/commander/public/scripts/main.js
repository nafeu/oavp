const $ = selector => document.querySelector(selector);
const $a = selector => document.querySelectorAll(selector);

const socialMediaTemplate = `nafeuvisual.space ▶ link in bio

follow for more ▶ #landscapeart #art #generativeart #creativecoding #abstractlandscape`;

let selectedSketch = null;
let isLoading = false;
let idCounter = 0;

const oavpObjectPropertiesTypeMapping = {};

window.oavpObjectProperties.forEach(({ id, type }) => {
  oavpObjectPropertiesTypeMapping[id] = type;
});

let sketchSocket;

try {
  sketchSocket = new WebSocket('ws://localhost:6287/commands');
} catch (err) {
  console.log(`[ oavp-commander] Cannot connect to processing editor websocket server...`);
}

sketchSocket.addEventListener('open', () => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket connection opened.";
});

sketchSocket.addEventListener('message', (event) => {
  const receivedData = JSON.parse(event.data);
  console.log('Received:', receivedData);
});

sketchSocket.addEventListener('error', () => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket error.";
});

sketchSocket.addEventListener('close', () => {
  $('#sketch-socket').textContent = "[ socket ] WebSocket connection closed.";
});

const commanderSocket = new WebSocket('ws://localhost:3002');

commanderSocket.addEventListener('open', () => {
  $('#commander-socket').textContent = "[ commander ] WebSocket connection opened.";
});

commanderSocket.addEventListener('message', (event) => {
  const dataElement = $('#data');
  const receivedData = JSON.parse(event.data);

  if (receivedData.command === 'preset-builder-result') {
    dataElement.textContent = receivedData.data;
  }
});

commanderSocket.addEventListener('error', () => {
  $('#commander-socket').textContent = "[ commander ] WebSocket error.";
});

commanderSocket.addEventListener('close', () => {
  $('#commander-socket').textContent = "[ commander ] WebSocket connection closed.";
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
        if (command === 'generate-ontop') {
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

function getSocialMediaTextContent(sketchDataObject) {
  const { name, id, paletteString } = sketchDataObject;

  return `${id}_${name.split(' ').join('_').toLowerCase()}\n\npalette ▶ ${paletteString}\n\n${socialMediaTemplate}`;
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

  $('#sketch-clipboard-button')?.addEventListener('click', function () {
    const textToCopy = getSocialMediaTextContent(window.sketchDataObjects[selectedSketch]);

    window.sketchDataObjects[selectedSketch].socialMediaTextContent = textToCopy;

    const tempTextarea = document.createElement('textarea');
    tempTextarea.value = textToCopy;
    document.body.appendChild(tempTextarea);
    tempTextarea.select();
    tempTextarea.setSelectionRange(0, 99999);

    document.execCommand('copy');
    document.body.removeChild(tempTextarea);

    saveSketch();
  });

  const saveOnChangeElements = $a('.save-on-change')

  for (let i = saveOnChangeElements.length; i--;) {
    saveOnChangeElements[i].addEventListener('input', debounce(saveSketch, 500))
  }

  $('#sketch-id-input')?.addEventListener('input', ({ target: { value } }) => {
    console.log('[ oavp ] Persisting id change...');

    window.sketchDataObjects[selectedSketch].id = value;
  });

  $('#sketch-name-input')?.addEventListener('input', ({ target: { value } }) => {
    console.log('[ oavp ] Persisting name change...');

    window.sketchDataObjects[selectedSketch].name = value;
  });

  $('#sketch-palette-input')?.addEventListener('input', ({ target: { value } }) => {
    console.log('[ oavp ] Persisting palette change...');

    window.sketchDataObjects[selectedSketch].paletteString = value;
  });

  const PRINT_SIZES = [
    '1x1',
    '2x3',
    '3x4',
    '4x5',
    '11x14',
    'international'
  ];

  const ORIGINAL_WIDTH = 7680;

  PRINT_SIZES.forEach(size => {
    const sliderElement = $(`#print-offset-${size}`);

    sliderElement?.addEventListener('input', ({ target: { value } }) => {
      $(`#print-guide-${size}`).style.left = `${value}%`;
      $(`#print-guide-vertical-${size}`).style.left = `${value}%`;
      $(`#print-guide-horizontal-${size}`).style.left = `${value}%`;
    });

    sliderElement?.addEventListener('mousedown', () => {
      $(`#print-guide-${size}`).style.opacity = 1;
      $(`#print-guide-vertical-${size}`).style.opacity = 1;
      $(`#print-guide-horizontal-${size}`).style.opacity = 1;
    });

    sliderElement?.addEventListener('mouseup', () => {
      $(`#print-guide-${size}`).style.opacity = 0;
      $(`#print-guide-vertical-${size}`).style.opacity = 0;
      $(`#print-guide-horizontal-${size}`).style.opacity = 0;

      const offsetPx = Math.round(ORIGINAL_WIDTH * ($(`#print-offset-${size}`).value / 100))

      window.sketchDataObjects[selectedSketch][`print-offset-${size}`] = offsetPx;

      saveSketch();
    });
  });
})

// eslint-disable-next-line no-unused-vars
function handleClickLoadSketch() {
  sendApiCommand({ command: 'load', sketchDataObject: window.sketchDataObjects[selectedSketch] })
}

// eslint-disable-next-line no-unused-vars
function handleClickReseedSketch() {
  sendApiCommand({ command: 'reseed', sketchDataObject: window.sketchDataObjects[selectedSketch] })
}

// eslint-disable-next-line no-unused-vars
function handleClickViewSketch(filename) {
  selectedSketch = filename;

  $("#sketch-preview-image").style.backgroundImage = `url(${filename}.png)`;
  $("#sketch-filename").textContent = filename;

  const { id, name, paletteString } = window.sketchDataObjects[selectedSketch];

  if (id) { $("#sketch-id-input").value = id; }
  else { $("#sketch-id-input").value = ''; }

  if (name) { $("#sketch-name-input").value = name; }
  else { $("#sketch-name-input").value = ''; }

  if (paletteString) { $("#sketch-palette-input").value = paletteString; }
  else { $("#sketch-palette-input").value = ''; }

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

        $("#sketch-name-input").value = name;

        $("#sketch-name-button").textContent = "Generate Name";

        isLoading = false;

        saveSketch();
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

        $("#sketch-palette-input").value = colorNames.join(' ');

        $("#sketch-palette-button").textContent = "Generate Palette"

        isLoading = false;

        saveSketch();
      })
      .catch(error => {
        console.error(error);
        $("#sketch-palette-button").textContent = "Generate Palette"

        isLoading = false;
      });
  }
}

// eslint-disable-next-line no-unused-vars
function saveSketch() {
  if (!isLoading) {
    isLoading = true;

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

        isLoading = false;
      })
      .catch(error => {
        console.error(error);

        // eslint-disable-next-line no-undef
        alert(error);

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

  $('#sketch-id-input').value = newId;

  saveSketch();
}

// eslint-disable-next-line no-unused-vars
function handleClickDecrementId() {
  if (idCounter !== null && idCounter !== undefined && idCounter > 0) {
    const newId = formatNumberWithLeadingZeros(--idCounter);

    window.sketchDataObjects[selectedSketch].id = newId;

    $('#sketch-id-input').value = newId;
  }

  saveSketch();
}

// eslint-disable-next-line no-unused-vars
function handleClickCopyToClipboard() {
  $('#sketch-clipboard-button').textContent = 'Copied!';

  setTimeout(() => {
    $('#sketch-clipboard-button').textContent = 'Copy To Clipboard';
  }, 1000);
}

// eslint-disable-next-line no-unused-vars
function handleClickPackage() {
  if (!isLoading) {
    isLoading = true;

    window.sketchDataObjects[selectedSketch].socialMediaTextContent = getSocialMediaTextContent(
      window.sketchDataObjects[selectedSketch]
    )

    $("#sketch-package-button").textContent = "Packaging..."

    fetch('/api/package', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ sketchDataObject: window.sketchDataObjects[selectedSketch], exportId: selectedSketch })
    })
      .then(response => response.json())
      .then(({ message }) => {
        $("#sketch-package-button").textContent = "Package"

        console.log(message);

        isLoading = false;
      })
      .catch(error => {
        console.error(error);
        $("#sketch-package-button").textContent = "Package"

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

// eslint-disable-next-line no-unused-vars
function getCheckedConceptMaps() {
  const output = [];

  // Check if query parameter options is set to 'all'
  const urlParams = new URLSearchParams(window.location.search);
  const optionsParam = urlParams.get('options');

  if (optionsParam === 'all') {
    // Use existing logic: check checkboxes
    const categories = ['default', 'background', 'celestial', 'sky', 'surrounding', 'foreground'];

    categories.forEach(category => {
      window.conceptMapMeta[category].forEach(({ mapId }) => {
        const isMapIdChecked = $(`#${mapId}-checkbox`)?.checked;

        if (isMapIdChecked) {
          output.push(mapId);
        }
      });
    });
  } else {
    // Use new logic: find toggled buttons and randomly select from each category
    const toggledButtons = $a('.concept-map-toggle.active');

    toggledButtons.forEach(button => {
      const category = button.getAttribute('data-category');

      if (category && window.conceptMapMeta[category] && window.conceptMapMeta[category].length > 0) {
        // Randomly select one entry from this category
        const randomIndex = Math.floor(Math.random() * window.conceptMapMeta[category].length);
        const selectedMap = window.conceptMapMeta[category][randomIndex];
        output.push(selectedMap.mapId);
      }
    });
  }

  console.log(output);

  return output.join(' ');
}
