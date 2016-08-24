//: ## Output Waveform Plot
//: ### If you open the Assitant editor and make sure it shows the
//: ### "Output Waveform Plot.xcplaygroundpage (Timeline) view",
//: ### you should see a plot of the waveform in real time
import XCPlayground
import AudioKit

var oscillator = AKFMOscillator()
oscillator.amplitude = 0.1
oscillator.rampTime = 0.1
AudioKit.output = oscillator
AudioKit.start()
oscillator.start()

class PlaygroundView: AKPlaygroundView {
    
    override func setup() {
        addTitle("Output Waveform Plot")
        
        addSubview(AKPropertySlider(
            property: "Frequency",
            format: "%0.2f Hz",
            value: oscillator.baseFrequency, maximum: 800,
            color: AKColor.yellowColor()
        ) { frequency in
            oscillator.baseFrequency = frequency
        })
        
        addSubview(AKPropertySlider(
            property: "Carrier Multiplier",
            format: "%0.3f",
            value: oscillator.carrierMultiplier, maximum: 3,
            color: AKColor.redColor()
        ) { multiplier in
            oscillator.carrierMultiplier = multiplier
        })
        
        addSubview(AKPropertySlider(
            property: "Modulating Multiplier",
            format: "%0.3f",
            value: oscillator.modulatingMultiplier, maximum: 3,
            color: AKColor.greenColor()
        ) { multiplier in
            oscillator.modulatingMultiplier = multiplier
        })
        
        addSubview(AKPropertySlider(
            property: "Modulation Index",
            format: "%0.3f",
            value: oscillator.modulationIndex, maximum: 3,
            color: AKColor.cyanColor()
        ) { index in
            oscillator.modulationIndex = index
        })
        
        
        addSubview(AKPropertySlider(
            property: "Amplitude",
            format: "%0.3f",
            value: oscillator.amplitude,
            color: AKColor.purpleColor()
        ) { amplitude in
            oscillator.amplitude = amplitude
        })

        
        addSubview(AKOutputWaveformPlot.createView())
    }
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = PlaygroundView()

