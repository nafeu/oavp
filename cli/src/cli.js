import arg from 'arg';
import inquirer from 'inquirer';
import _ from 'lodash';
import { handleCreateCommand } from './components/create';

function parseArgumentsIntoOptions(rawArgs) {
    const args = arg(
        {
            '--template': String,
            '-t': '--template',
        },
        {
            '--sketch': String,
            '-s': '--sketch',
        },
        {
            argv: rawArgs.slice(2),
        }
    )
    return {
        sketch: args['--sketch'],
        template: args['--template'],
        command: args._[0],
    }
}

const VALID_COMMANDS = ['create', 'build'];
const DEFAULT_COMMAND = 'create';

async function promptForMissingCommand(options) {
    const questions = [];

    const isInvalidCommand = options.command && !_.includes(VALID_COMMANDS, _.toLower(options.command));

    if (isInvalidCommand) {
      console.log(`[ oavp ] Command '${options.command}' not recognized.`)
    }

    if (!options.command || isInvalidCommand) {
        questions.push({
            type: 'list',
            name: 'command',
            message: 'Please select a command:',
            choices: VALID_COMMANDS,
            default: DEFAULT_COMMAND
        });
    }

    const answers = await inquirer.prompt(questions);

    return {
        ...options,
        command: options.command || answers.command,
    }
}

async function handleOptions(options) {
  switch (options.command) {
    case 'create':
      await handleCreateCommand(options);
      break;
    default:
      await handleCreateCommand(options);
  }
}

export async function cli(args) {
    let options = parseArgumentsIntoOptions(args);
    options = await promptForMissingCommand(options);
    try {
        await handleOptions(options);
    } catch(err) {
        console.log(err.message);
    }
}
