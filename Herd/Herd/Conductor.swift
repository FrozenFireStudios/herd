//
//  Conductor.swift
//  Herd
//
//  Created by Peter Buerer on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import AudioKit

class Conductor {
    static let sharedInstance = Conductor()
    
    var bark: AKAudioPlayer
    var barkPanner: AKPanner
    var sheep1: AKAudioPlayer
    var backgroundMusic: AKSequencer
    var backgroundSampler = AKSampler()
    
    init() {
        let barkFile = try! AKAudioFile(readFileName: "dogbark2.wav")
        bark = try! AKAudioPlayer(file: barkFile)
        
        barkPanner = AKPanner(bark)
        barkPanner.pan = 0.0
       
        
        let sheepFile = try! AKAudioFile(readFileName: "bleat.wav")
        sheep1 = try! AKAudioPlayer(file: sheepFile)
        
        backgroundSampler.loadWav("baa")
        backgroundSampler.tuning = -12
        
        let mixer = AKMixer(barkPanner, sheep1, backgroundSampler)
        
        AudioKit.output = mixer
        AudioKit.start()
        
        backgroundMusic = AKSequencer(filename: "smwintro", engine: AudioKit.engine)
//        backgroundMusic.setGlobalAVAudioUnitOutput(backgroundSampler.samplerUnit)
//        backgroundMusic.play()
    }
}