import { weaveTopics } from 'topic-weaver';

const conceptMap = `
#name
[verb]
[noun] [noun]
[adj] [noun]
[verb] [prep] [noun]

#prep
in
on
at
by
with
from
to
under
over
across
along
away
back
beyond
inside
outside
through
up
down
around
towards

#verb
gliding
zooming
swooping
soaring
blasting
cruising
darting
zipping
whizzing
streaking
rocketing
shooting
sailing
gliding
floating
hovering
drifting
speeding
zooming
warping
capture
depict
convey
illustrate
portray
evoke
manifest
reveal
explore
experiment
blend
juxtapose
harmonize
contrast
integrate
distort
transform
manipulate
infuse
radiate
emanate
project
construct
deconstruct
compose
balance
subvert
challenge
provoke
engage
transcend
immerse
mesmerize
intrigue
bewilder
astonish
enchant
encapsulate
elicit
suggest
allude
insinuate
inscribe
embody
signify
symbolize
represent
narrate
unfold
unravel
abstract
refine
synthesize
decontextualize
recontextualize
reconstruct
deform
reconfigure
subdue
amplify
intensify
exaggerate
simplify
elaborate
delineate
transfigure
metamorphose
warp
twist
morph
conceptualize
envision
reimagine
transgress
transport
fracture
dissolve
disintegrate
unify
disassemble
assemble
fragment
cascade
spiral
collide
intersect
overlap
obliterate
obscure
elude
transmute
unfurl
disturb
beguile
entrance
captivate
bewitch
inspire
disrupt
dismantle
unveil
simulate
dream
awaken
freeze
accelerate
disorient
condense
distill
speculate
navigate
traverse
contemplate
visualize

#adj
alienating
bleak
brutal
cold
concrete
dystopian
eerie
fractured
gothic
grim
harrowing
industrial
infinte
isolating
labyrinthine
macabre
mysterious
nihilistic
ominous
post-apocalyptic
prismatic
pyschedelic
robotic
surreal
technological
uncanny
unsettling
utterly
visceral
warped
winding
zenith
apocalyptic
atmospheric
barren
cacophonous
cavernous
convoluted
densely
desolate
distorted
ethereal
grimy
grotesque
intricate
minimalist
futuristic
intense
scaled-up
otherworldly
cosmic
celestial
dreamy
unconventional
unique
bizarre
alien
enigmatic
transcendent
sublime
awe-inspiring
breathtaking
spectacular
grandiose
majestic
towering
skyward
galactic
interstellar
nebulous
starry
stellar
planetary
astro
cosmostellar
interdimensional
multiverse
neo-futuristic
retro-futuristic
space-age
techno-organic
cybernetic
nanotech
post-human
transhuman
cyborg
mechatronic
synthetik
iridescent
serene
idyllic
scenic
panoramic
vast
expansive
rolling
undulating
lush
green
blue
cloudy
sunny
melancholic
somber
contemplative
expressive
vibrant
colorful
energetic
dynamic
abstract
non-representational
symbolic
geometric
maximalist
experimental
innovative
angled
asymmetrical
curved
symmetrical
patterned
graphic
neat
ornate
complex
simple
clean
modernist
expressionist
conceptual
non-figurative
three-dimensional
installation
site-specific
interactive
raw
unfinished
utilitarian
blocky
massive
monolithic
angular
aggregrate
decorative
functional
fantastical
imaginative
gigantic
monumental
colossal
enormous
huge
high-tech
imposing
architectural
dreamlike
irrational
illogical
subconscious
disorienting
spatial
extraterrestrial
intergalactic
universal
astral
chronological
temporal
historical
speculative
theoretical
absurd
angsty
existential
fatalistic
philosophical
psychological
reflective
serious

#noun
mountain range
ocean
sunset
clouds
trees
river
cliff
valley
beach
island
shapes
forms
colors
textures
patterns
lines
gradients
swirls
blotches
splatters
circles
triangles
rectangles
spirals
stars
diamonds
pentagons
hexagons
octagons
irregular shapes
metal structures
glass sculptures
wood carvings
stone statues
plaster forms
clay figures
plexiglas shapes
bone constructions
fabric forms
found object assemblages
blocky buildings
raw concrete structures
angular shapes
industrial facades
monolithic towers
fortress-like designs
monumental columns
massive walls
rusty metal frameworks
decaying ruins
spacecraft
alien landscapes
robots
planets
galaxies
time machines
futuristic cities
cyberpunk environments
interdimensional portals
skyscrapers
megatowers
superstructures
architectural behemoths
city-scale constructions
mega-bridges
colossal domes
gigantic monuments
enormous buildings
massive engineering feats
monuments
statues
obelisks
cylindrical structures
spherical forms
columnar shapes
faceless towers
mysterious pillars
ancient ruins
enigmatic artifacts
dream-like landscapes
ethereal skies
melting clocks
distorted perspectives
unsettling objects
otherworldly creatures
disorienting environments
enigmatic symbols
subconscious visions
uncanny scenes
nebulae
black holes
cosmic rays
space stations
astral bodies
interstellar landscapes
celestial phenomena
cosmic dust
galactic winds
stellar explosions
quantum fluctuations
dark matter clouds
gamma-ray bursts
supernovae remnants
cosmic strings
hyperspace tunnels
planetary landings
alien encounters
zero gravity environments
cosmic radiation exposure
asteroid fields
comet trails
galactic colonization
time dilation effects
interstellar travel
timelines
paradoxes
chrono-disruptors
temporal portals
ages past and future
historical events
alternate realities
epochal shifts
cosmic time streams
the meaning of existence
life's purpose
human nature
morality
free will
fate and destiny
emotional turmoil
existential crises
philosophical queries
metaphysical musings
mountain
lake
forest
meadow
coastline
field
sky
boulders
waterfall
brushstrokes
drips
stains
smudges
blurs
flickers
glows
haze
hues
squares
rhombi
grids
structures
assemblies
compositions
collections
arrangements
arrays
groupings
blocks
massing
brutality
heaviness
harshness
angularity
robustness
solidity
massiveness
alien
time
dimensional
futuristic
cyberpunk
cosmic
city
architectural
engineering
technological
structural
columns
pillars
monoliths
megaliths
stone
earthworks
dreamscapes
nightmares
absurdity
irrationality
unconscious
subconscious
fantastical
imaginative
bizarre
eccentric
black
stellar
interstellar
space
celestial
planetary
asteroid
comets
meteors
galactic
chronology
temporal
parallel
alternate
historical
cultural
human
mortality
identity
purpose
meaning
existence
freedom
choice
`

export const generateName = () => {
  const { topics } = weaveTopics(conceptMap, 1)

  return topics[0];
}

export const getFormattedSketchName = sketchDataObject => sketchDataObject
  .name
  .toLowerCase()
  .split(' ')
  .join('_')
