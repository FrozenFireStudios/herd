//: ## Pitch Shift Operation
//:
import XCPlayground
import AudioKit

let bleat1file = try AKAudioFile(readFileName: "BillyGoatBleet.mp3", baseDir: .Resources)

let bleat1 = try AKAudioPlayer(file: bleat1file)

let bleat2file = try AKAudioFile(readFileName: "bleat.wav", baseDir: .Resources)

let bleat2 = try AKAudioPlayer(file: bleat2file)

let bleat3file = try AKAudioFile(readFileName: "SheepBleat.wav", baseDir: .Resources)

let bleat3 = try AKAudioPlayer(file: bleat3file)

let mix = AKMixer(bleat1, bleat2, bleat3)

let effect = AKOperationEffect(mix) {  player, parameters in
    let sinusoid = AKOperation.sineWave(frequency: parameters[2])
    let shift = parameters[0] + sinusoid * parameters[1] / 2.0
    return player.pitchShift(semitones: shift)
}
effect.parameters = [0, 7, 3]

AudioKit.output = effect
AudioKit.start()

class PlaygroundView: AKPlaygroundView {
    
    override func setup() {
        addTitle("Bleats")
        
        addSubview(AKButton(title: "bleat1") {
            bleat1.play()
            return ""
            }
        )
        addSubview(AKButton(title: "bleat2") {
            bleat2.play()
            return ""
            }
        )
        addSubview(AKButton(title: "bleat3") {
            bleat3.play()
            return ""
            }
        )
        
        
        
        addSubview(AKPropertySlider(
            property: "Base Shift",
            format: "%0.3f semitones",
            value: effect.parameters[0], minimum: -12, maximum: 12
        ) { sliderValue in
            effect.parameters[0] = sliderValue
            })
        addSubview(AKPropertySlider(
            property: "Range",
            format: "%0.3f semitones",
            value: effect.parameters[1], minimum: 0, maximum: 24
        ) { sliderValue in
            effect.parameters[1] = sliderValue
            })
        addSubview(AKPropertySlider(
            property: "Speed",
            format: "%0.3f Hz",
            value: effect.parameters[2], minimum: 0.001, maximum: 10
        ) { sliderValue in
            effect.parameters[2] = sliderValue
            })
    }
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = PlaygroundView()
