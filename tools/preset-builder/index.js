const fs = require('fs');
const diff = require('diff');

const compareFiles = () => {
  const content1 = fs.readFileSync('default.txt', 'utf-8').split('\n');
  const content2 = fs.readFileSync('target.txt', 'utf-8').split('\n');

  const lineDiff = diff.diffArrays(content1, content2);

  const differentLines = lineDiff
    .filter(part => part.added || part.removed)
    .map(part => (part.added ? '+ ' : part.removed ? '- ' : '  ') + part.value)
    .filter(part => part[0] === '+')
    .map(part => part.substring(1).trim());

  return differentLines;
}

difference = compareFiles();

let output = '';

difference.forEach(line => {
  const isAddition = line.includes('.add(');

  if (isAddition) {
    const objectName = line.match(/\.add\("[^"]+", "([^"]+)"\)/)[1];

    output = `${objectName}|`;
  } else {
    const [_, property, value] = line.match(/\.set\("([^"]+)", (?:([^"]+)|(\w+))\)/);

    output += `${property}:${value};`;
  }
});

console.log(output);
