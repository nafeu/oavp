import arg from 'arg';
import inquirer from 'inquirer';
import execa from 'execa';

function parseArgumentsIntoOptions(rawArgs) {
    const args = arg(
        {
            '--yes': Boolean,
            '-y': '--yes',
        },
        {
            argv: rawArgs.slice(2),
        }
    )
    return {
        skipPrompts: args['--yes'] || false,
        execution: args['--yes'] || false,
        command: args._[0],
    }
}

async function promptForMissingOptions(options) {
    const defaultCommand = 'date';
    if (options.skipPrompts) {
        return {
            ...options,
            command: options.command || defaultCommand
        };
    }

    const questions = [];
    if (!options.command) {
        questions.push({
            type: 'list',
            name: 'command',
            message: 'Please choose which command to run',
            choices: ['date', 'ls', 'pwd'],
            default: defaultCommand
        })
    }

    const answers = await inquirer.prompt(questions);

    if (!options.execution) {
        const confirmation = await inquirer.prompt([
            {
                type: 'confirm',
                name: 'execution',
                message: `Execute command: '${answers.command || options.command}'?`,
                default: false,
            }
        ])
        return {
            ...options,
            command: options.command || answers.command,
            execution: options.execution || confirmation.execution,
        }
    }

    return {
        ...options,
        command: options.command || answers.command,
    }
}

async function handleOptions({ command, execution }) {
    if (execution) {
        const result = await execa(command, [], {});
        if (result.failed) {
            Promise.reject(`Failed to execute ${command}`)
            return;
        } else {
            console.log(result.stdout);
        }
    }
}

export async function cli(args) {
    let options = parseArgumentsIntoOptions(args);
    options = await promptForMissingOptions(options);
    try {
        await handleOptions(options);
    } catch(err) {
        console.log(err.message);
    }
}