//: ## Tracking Frequency of an Audio File
//: ### Here is a more real-world example of tracking the pitch of an audio stream
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: "leadloop.wav", baseDir: .Resources)

var player = try AKAudioPlayer(file: file)
player.looping = true

let tracker = AKFrequencyTracker(player)

AudioKit.output = tracker
AudioKit.start()
player.play()

//: User Interface

class PlaygroundView: AKPlaygroundView {
    
    var trackedAmplitudeSlider: AKPropertySlider?
    var trackedFrequencySlider: AKPropertySlider?
    
    override func setup() {
        
        AKPlaygroundLoop(every: 0.1) {
            self.trackedAmplitudeSlider?.value = tracker.amplitude
            self.trackedFrequencySlider?.value = tracker.frequency
        }
        
        addTitle("Tracking An Audio File")
        
        trackedAmplitudeSlider = AKPropertySlider(
            property: "Tracked Amplitude",
            format: "%0.3f",
            value: 0, maximum: 0.55,
            color: AKColor.greenColor()
        ) { sliderValue in
            // Do nothing, just for display
        }
        addSubview(trackedAmplitudeSlider!)
        
        trackedFrequencySlider = AKPropertySlider(
            property: "Tracked Frequency",
            format: "%0.3f",
            value: 0, maximum: 1000,
            color: AKColor.redColor()
        ) { sliderValue in
            // Do nothing, just for display
        }
        addSubview(trackedFrequencySlider!)
        
        addSubview(AKRollingOutputPlot.createView())
    }
}
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = PlaygroundView()
