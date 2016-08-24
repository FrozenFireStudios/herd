//: ## Sequencer
//:
import XCPlayground
import AudioKit

//: Create some samplers, load different sounds, and connect it to a mixer and the output
var sampler = AKSampler()
sampler.loadWav("bleat")
sampler.tuning = 12
var mixer = AKMixer(sampler)

let reverb = AKCostelloReverb(mixer)

let dryWetmixer = AKDryWetMixer(mixer, reverb, balance: 0.2)
AudioKit.output = AKBooster(dryWetmixer, gain: 10)

//: Create the sequencer after AudioKit's output has been set
//: Load in a midi file, and set the sequencer to the main audiokit engine
var sequencer = AKSequencer(filename: "beethoven_les_adieux_1", engine: AudioKit.engine)


AudioKit.start()
sequencer.setGlobalAVAudioUnitOutput(sampler.samplerUnit)
sequencer.play()


XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//XCPlaygroundPage.currentPage.liveView = PlaygroundView()
