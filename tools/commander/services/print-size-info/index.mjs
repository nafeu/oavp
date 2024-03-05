import _ from 'lodash';

export const getPrintSizeOptions = sketchDataObject => (
  _.chain(sketchDataObject)
    .keys()
    .filter(key => _.includes(key, 'print-offset'))
    .map(key => `${sketchDataObject[key]}`)
    .value()
)
