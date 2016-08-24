//: ## Audio Player
//:
import XCPlayground
import AudioKit

let bark1file = try AKAudioFile(readFileName: "deepbark.wav", baseDir: .Resources)

let bark1 = try AKAudioPlayer(file: bark1file)

let bark2file = try AKAudioFile(readFileName: "dogbark2.wav", baseDir: .Resources)

let bark2 = try AKAudioPlayer(file: bark2file)

let bark3file = try AKAudioFile(readFileName: "dogbark3.wav", baseDir: .Resources)

let bark3 = try AKAudioPlayer(file: bark3file)

let bark4file = try AKAudioFile(readFileName: "dogbark5.wav", baseDir: .Resources)

let bark4 = try AKAudioPlayer(file: bark4file)

let mix = AKMixer(bark1, bark2, bark3, bark4)

let effect = AKOperationEffect(mix) { player, parameters in
    let sinusoid = AKOperation.sineWave(frequency: parameters[2])
    let shift = parameters[0] + sinusoid * parameters[1] / 2.0
    return player.pitchShift(semitones: shift)
}
effect.parameters = [0, 7, 3]

AudioKit.output = effect
AudioKit.start()

//: Don't forget to show the "debug area" to see what messages are printed by the player
//: and open the timeline view to use the controls this playground sets up....

class PlaygroundView: AKPlaygroundView {
    
    // UI Elements we'll need to be able to access
    var inPositionSlider: AKPropertySlider?
    var outPositionSlider: AKPropertySlider?
    var playingPositionSlider: AKPropertySlider?
    
    override func setup() {
        
        addTitle("Barks")
        
        addSubview(AKButton(title: "bark1") {
            bark1.play()
            return ""
            }
        )
        addSubview(AKButton(title: "bark2") {
            bark2.play()
            return ""
            }
        )
        addSubview(AKButton(title: "bark3") {
            bark3.play()
            return ""
            }
        )
        addSubview(AKButton(title: "bark4") {
            bark4.play()
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
