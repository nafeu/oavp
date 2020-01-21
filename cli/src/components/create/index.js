import { readTemplate, getTemplates } from '../../utils/helpers';
import inquirer from 'inquirer';
import _ from 'lodash';
import { capitalCase } from 'change-case';

const DEFAULT_TEMPLATE = 'default';
const TEMPLATE_PATTERN = /%([A-Z]\w+(\|[\S])|())\w+%/g;

export async function handleCreateCommand(options) {
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
  const [templateData, templateDefaults] = (await readTemplate(options.template || answers.template)).split('---');

  const templateDefaultsMapping = {}

  if (templateDefaults) {
    _.each(_.filter(templateDefaults.split('\n'), item => item.length > 0), item => {
      const delimiter = ': ';
      const name = item.split(delimiter)[0];
      templateDefaultsMapping[name] = item.substr(name.length + delimiter.length, item.length);
    })
  }

  const templateVariables = _.uniq(_.map(templateData.match(TEMPLATE_PATTERN), item => _.trim(item, '%')));

  const templateQuestions = [];

  _.forEach(templateVariables, item => {
    templateQuestions.push({
      type: 'input',
      name: item,
      message: `Enter ${capitalCase(item)}:`,
      default: templateDefaultsMapping[item] ? templateDefaultsMapping[item] : capitalCase(item),
    });
  });

  const templateAnswers = await inquirer.prompt(templateQuestions);

  let processedTemplateData = templateData;

  _.forEach(templateVariables, item => {
    processedTemplateData = processedTemplateData.replace(
      new RegExp(`%${item}%`, 'g'),
      templateAnswers[item]
    );
  });

  const parsedTemplateData = JSON.parse(processedTemplateData);

  console.log(parsedTemplateData);
}
