const oavpObjectPropertiesTypeMapping = {};

window.oavpObjectProperties.forEach(({ id, type }) => {
  oavpObjectPropertiesTypeMapping[id] = type;
});

const sketchSocket = new WebSocket('ws://localhost:6287/commands');

sketchSocket.addEventListener('open', (event) => {
  document.getElementById('sketch-socket').textContent = "[ socket ] WebSocket connection opened.";
  console.log('WebSocket connection opened:', event);
});

sketchSocket.addEventListener('message', (event) => {
  const receivedData = JSON.parse(event.data);
  console.log('Received:', receivedData);
});

sketchSocket.addEventListener('error', (event) => {
  document.getElementById('sketch-socket').textContent = "[ socket ] WebSocket error.";
  console.error('WebSocket error:', event);
});

sketchSocket.addEventListener('close', (event) => {
  document.getElementById('sketch-socket').textContent = "[ socket ] WebSocket connection closed.";
  console.log('WebSocket connection closed:', event);
});

const commanderSocket = new WebSocket('ws://localhost:3002');

commanderSocket.addEventListener('open', (event) => {
  document.getElementById('commander-socket').textContent = "[ commander ] WebSocket connection opened.";
  console.log('WebSocket connection opened:', event);
});

commanderSocket.addEventListener('message', (event) => {
  const dataElement = document.getElementById('data');
  const receivedData = JSON.parse(event.data);

  if (receivedData.command === 'preset-builder-result') {
    dataElement.textContent = receivedData.data;
  }
});

commanderSocket.addEventListener('error', (event) => {
  document.getElementById('commander-socket').textContent = "[ commander ] WebSocket error.";
  console.error('WebSocket error:', event);
});

commanderSocket.addEventListener('close', (event) => {
  document.getElementById('commander-socket').textContent = "[ commander ] WebSocket connection closed.";
  console.log('WebSocket connection closed:', event);
});

function sendSocketCommand({ command, ...params }) {
  const responseElement = document.getElementById('response');
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
    const responseElement = document.getElementById('response');
    const dataElement = document.getElementById('data');
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
    const responseElement = document.getElementById('response');
    responseElement.textContent = 'Error occurred during API request.';
  });
}

// eslint-disable-next-line no-unused-vars
function sendDebug({ command, ...params }) {
  console.log({ command, params });
}

function getPropertyName() {
  const propertyNameElement = document.getElementById('property-name')

  return propertyNameElement.value;
}

function getPropertyType() {
  const propertyNameElement = document.getElementById('property-name')

  return oavpObjectPropertiesTypeMapping[propertyNameElement.value];
}

// eslint-disable-next-line no-unused-vars
function getPropertyValue() {
  const propertyValueElement = document.getElementById('property-value');

  if (getPropertyType() !== 'String') {
    return Number(propertyValueElement.value);
  }

  return propertyValueElement.value;
}

function setSelectedProperty(property) {
  const propertyNameElement = document.getElementById('property-name');

  const lastButtonElement = document.getElementById('last-button');

  lastButtonElement.textContent = `Last button pressed: Select ${property}`;

  propertyNameElement.value = property;
}

// eslint-disable-next-line no-unused-vars
function setAndSendDirectEdit(property, value) {
  setSelectedProperty(property);
  sendSocketCommand({ command: 'direct-edit', name: getPropertyName(), type: getPropertyType(), value })
}

document.addEventListener('keydown', function(event) {
  const key = event.key.toLowerCase(); // Convert to lowercase for case-insensitivity
  if (
    key === 'e'
    || key === 'g'
    || key === 'x'
    || key === '|'
    || key === 'p'
    || key === 'n'
    || key === 'm'
    || key === ']'
    || key === '['
    || key === '1'
    || key === '2'
    || key === '4'
    || key === '5'
    || key === '7'
    || key === '8'
  ) {
    const buttonId = `button${key.toUpperCase()}`;
    const button = document.getElementById(buttonId);

    if (
      button
      && (document.activeElement !== document.getElementById('property-value'))
      && (document.activeElement !== document.getElementById('property-name'))
    ) {
      const lastButtonElement = document.getElementById('last-button');

      lastButtonElement.textContent = `Last button pressed: ${key} -> ${button.textContent}`;

      // TODO: Re-enable once ready
      // button.click();
    }
  }
});

document.getElementById('data').addEventListener('click', function () {
  const originalText = document.getElementById('data').textContent;
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

// eslint-disable-next-line no-unused-vars
function handleClickMatrixImage(filename) {
  console.log({ event: 'click', filename });
}

// eslint-disable-next-line no-unused-vars
function handleHoverMatrixImage(filename) {
  document.getElementById("sketch-preview-image").style.backgroundImage = `url(${filename}.png)`;
}
