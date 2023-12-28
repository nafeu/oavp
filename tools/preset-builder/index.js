const fs = require('fs');
const diff = require('diff');

const compareFiles = () => {
  if (!fs.existsSync('default.txt')) {
    console.log('Missing "default.txt" file'); process.exit(1);
  }

  if (!fs.existsSync('target.txt')) {
    console.log('Missing "target.txt" file'); process.exit(1);
  }

  const content1 = fs.readFileSync('default.txt', 'utf-8').split('\n');
  const content2 = fs.readFileSync('target.txt', 'utf-8').split('\n');

  const lineDiff = diff.diffArrays(content1, content2);

  let differentLines = lineDiff
    .filter(part => part.added || part.removed)
    .map(part => (part.added ? '+ ' : part.removed ? '- ' : '  ') + part.value)

  differentLines = differentLines
    .filter(part => part[0] === '+')
    .map(part => part.substring(1).trim());

  return differentLines;
}

const splitString = input => {
  const regex = /,(?![^()]*\))/g;
  const result = input.split(regex);
  return result.map(item => item.trim());
}

const directoryPath = './';
const targetFileName = 'target.txt';
const dumpFilePath = 'preset-dump.txt';

console.log(`[ preset-builder ] Watching for changes to ${targetFileName}`);
console.log(`[ preset-builder ] Dumping generated presets into to ${dumpFilePath}`);

const logStream = fs.createWriteStream(dumpFilePath, { flags: 'a' });

let output = '';
let processedDiff = [];
let presetCount = 0;

fs.watch(directoryPath, (eventType, filename) => {
  if (filename !== targetFileName) { return };

  output = '';
  processedDiff = [];

  compareFiles().forEach(line => {
    processedDiff = [...processedDiff, ...splitString(line)];
  });

  processedDiff.forEach(line => {
    const isAddition = line.includes('.add(');

    if (isAddition) {
      const objectName = line.match(/\.add\("[^"]+","([^"]+)"\)/)[1];

      output = `${objectName}|`;
    } else {
      const regex = /\.set\("([^"]+)",\s*([^)]+)\)/g;

      while ((match = regex.exec(line)) !== null) {
        const property = match[1].trim();
        const value = match[2].trim();
        output += `${property}:${value};`;
      }
    }
  });

  console.log(`[ preset-builder ] Added preset (${++presetCount})`);
  logStream.write(`\n${output}`);
});
