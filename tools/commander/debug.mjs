import { getConceptMaps, getConceptMapMeta } from './services/concept-maps/index.mjs';

export const runDebugScript = () => {
  console.log(`--- DEBUG ${Date.now()} ---`);

  // console.log(getConceptMapMeta().map(({ mapId, prefabsCount }) => `${mapId}: ${prefabsCount}`));
  console.log(getConceptMapMeta());
}
