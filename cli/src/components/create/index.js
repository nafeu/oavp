import { readTemplate } from '../../utils/helpers';

export async function handleCreateCommand() {
  console.log(await readTemplate('default'));
}