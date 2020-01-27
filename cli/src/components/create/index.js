import inquirer from 'inquirer';
import _ from 'lodash';
import { capitalCase } from 'change-case';

import {
  readTemplateConfig,
  readTemplateSketch,
  getTemplates,
  validateSketchName,
  createSketch,
  openWithEditor,
  confirm,
} from '../../utils/helpers';

const DEFAULT_TEMPLATE = 'default';
const TEMPLATE_PATTERN = /%([A-Z]\w+(\|[\S])|())\w+%/g;

export async function handleCreateCommand(options) {
  const name = await getSketchName(options);
  const { config, template } = await getTemplateConfig(options);
  const sketch = await readTemplateSketch(template);
  const path = createSketch({ name, config, sketch });
  if (await confirm(`Open this sketch in an editor?`, false)) {
    await openWithEditor(path);
  }
}

export async function getSketchName(options) {
  const questions = [];

  if (options.sketch && !validateSketchName(options.sketch)) {
    console.log(`[ oavp ] The sketch name '${options.sketch}' is invalid or already exists.`)
  }

  if (!options.sketch || !validateSketchName(options.sketch)) {
    const answers = await inquirer.prompt({
      type: 'input',
      name: 'name',
      message: 'Please enter a name for your sketch:',
      validate: validateSketchName
    });
    return answers.name;
  }

  return options.name;
}

export async function getTemplateConfig(options) {
  const questions = [];

  const availableTemplates = await getTemplates();

  const isInvalidTemplate = options.template && !_.includes(availableTemplates, _.toLower(options.template));

  if (isInvalidTemplate) {
    console.log(`[ oavp ] Template '${options.command}' not recognized.`)
  }

  if (!options.template || isInvalidTemplate) {
    questions.push({
      type: 'list',
      name: 'template',
      message: 'Please select a template:',
      choices: availableTemplates,
      default: DEFAULT_TEMPLATE
    });
  }

  const answers = await inquirer.prompt(questions);
  const finalTemplate = options.template || answers.template;
  const [templateData, templateDefaults] = (await readTemplateConfig(finalTemplate)).split('---');

  const templateDefaultsMapping = {};
  let templateAnswers = {};

  if (templateDefaults) {
    _.each(_.filter(templateDefaults.split('\n'), item => item.length > 0), item => {
      const delimiter = ': ';
      const name = item.split(delimiter)[0];
      templateDefaultsMapping[name] = item.substr(name.length + delimiter.length, item.length);
    })
  }

  const templateVariables = _.uniq(_.map(templateData.match(TEMPLATE_PATTERN), item => _.trim(item, '%')));

  const { useDefaults } = await inquirer.prompt({
    type: 'confirm',
    name: 'useDefaults',
    message: 'Use default preset values?',
    default: true
  });

  if (useDefaults) {
    templateAnswers = templateDefaultsMapping;
  } else {
    const templateQuestions = [];

    _.forEach(templateVariables, item => {
      templateQuestions.push({
        type: 'input',
        name: item,
        message: `Enter ${capitalCase(item)}:`,
        default: templateDefaultsMapping[item] ? templateDefaultsMapping[item] : capitalCase(item),
      });
    });

    templateAnswers = await inquirer.prompt(templateQuestions);
  }

  let processedTemplateData = templateData;

  _.forEach(templateVariables, item => {
    processedTemplateData = processedTemplateData.replace(
      new RegExp(`%${item}%`, 'g'),
      templateAnswers[item]
    );
  });

  return { config: processedTemplateData, template: options.template || answers.template };
}

