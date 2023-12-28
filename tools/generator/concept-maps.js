/*
  Different Areas for Random Generation:

  Colors
  Background Landscape Scenery
  Sky Decorations
  Celestial Bodies
  Foreground Focal Point
  Repeating Objects In Foreground
  Motion
    - Slowly Forward
*/

const sharedValues = `
#dim
100
200
300
400
`

const foregroundFocalPoint = `
#root
[arc]

#arc
Arc|zMod:-250.0;zModType:"osc-normal";zIter:35.0;zrIter:5.0;w:[dim].0;h:[dim].0;s:[dim].0;paramB:180.0;fillColor:0;i:21;
`+sharedValues;

module.exports = {
  foregroundFocalPoint
}