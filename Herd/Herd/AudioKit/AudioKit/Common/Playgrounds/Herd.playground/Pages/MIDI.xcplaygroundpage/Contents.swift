//: ## Sequencer
//:
import XCPlayground
import AudioKit

//: Create some samplers, load different sounds, and connect it to a mixer and the output
var sampler = AKSampler()
sampler.loadWav("bleat")


var mixer = AKMixer(sampler)

let reverb = AKCostelloReverb(mixer)

let dryWetmixer = AKDryWetMixer(mixer, reverb, balance: 0.2)
AudioKit.output = dryWetmixer

//: Create the sequencer after AudioKit's output has been set
//: Load in a midi file, and set the sequencer to the main audiokit engine
var sequencer = AKSequencer(filename: "bumble_bee", engine: AudioKit.engine)


//: Do some basic setup to make the sequence loop correctly
sequencer.enableLooping()

AudioKit.start()
sequencer.play()


XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPlaygroundPage.currentPage.liveView = PlaygroundView()
