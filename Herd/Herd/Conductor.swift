//
//  Conductor.swift
//  Herd
//
//  Created by Peter Buerer on 8/24/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import AudioKit

enum SoundKey: String {
    case BackgroundMusicKey
    case BarkLoudKey
    case TwoBarkKey
    case SheepSoundKey
    case DyingSheepKey
    case CrowdBooingKey
    case CrowdCheeringKey
    case SuccessPingKey
}

class Conductor {
    static let sharedInstance = Conductor()
    
    var backgroundMusic: AKSequencer
    var backgroundSampler = AKSampler()
    
    var barkLoud: AKAudioPlayer
    var barkLoudPanner: AKPanner
    var twoBark: AKAudioPlayer
    var twoBarkPanner: AKPanner
    
    var sheep1: AKAudioPlayer
    
    var boo: AKAudioPlayer
    var cheer: AKAudioPlayer
    var successPing: AKAudioPlayer
    
    var dyingSheep: AKAudioPlayer
    var dyingSheepEffect: AKOperationEffect
    var dyingSheepBooster: AKBooster
    
    var soundDict = [String : AKNode]()
    
    init() {
        let barkLoudFile = try! AKAudioFile(readFileName: "Sounds/dogbarkLoud.wav")
        barkLoud = try! AKAudioPlayer(file: barkLoudFile)
        
        barkLoudPanner = AKPanner(barkLoud)
        barkLoudPanner.pan = 0.0
        
        let twoBarkFile = try! AKAudioFile(readFileName: "Sounds/dogbarks.wav")
        twoBark = try! AKAudioPlayer(file: twoBarkFile)
        
        twoBarkPanner = AKPanner(twoBark)
        twoBarkPanner.pan = 0.0
       
        let sheepFile = try! AKAudioFile(readFileName: "Sounds/bleat.wav")
        sheep1 = try! AKAudioPlayer(file: sheepFile)
        
        backgroundSampler.loadWav("Sounds/baa")
        backgroundSampler.tuning = -12
       
        let booFile = try! AKAudioFile(readFileName: "Sounds/crowdBoo1.wav")
        boo = try! AKAudioPlayer(file: booFile)
        
        let cheerFile = try! AKAudioFile(readFileName: "Sounds/crowdCheerToSolo.wav")
        cheer = try! AKAudioPlayer(file: cheerFile)
        
        let successFile = try! AKAudioFile(readFileName: "Sounds/shorterGlassPing.wav")
        successPing = try! AKAudioPlayer(file: successFile)
       
        let successMixer = AKMixer(successPing)
        
        let reverb = AKCostelloReverb(successMixer)
        
        let dryWetSuccessMixer = AKDryWetMixer(successMixer, reverb, balance: 0.6)
      
        let dyingSheepFile = try! AKAudioFile(readFileName: "Sounds/SheepBleat.wav")
        dyingSheep = try! AKAudioPlayer(file: dyingSheepFile)
        
        dyingSheepEffect = AKOperationEffect(dyingSheep) {  player, parameters in
            let sinusoid = AKOperation.sineWave(frequency: parameters[2])
            let shift = parameters[0] + sinusoid * parameters[1] / 2.0
            return player.pitchShift(semitones: shift)
        }
        
        dyingSheepEffect.parameters = [8.836, 2.618, 1.524]
        
        dyingSheepBooster = AKBooster(dyingSheepEffect, gain: 2)
       
        // what we need to put in the mixer so things that get play()ed sound right
        let mixer = AKMixer(barkLoudPanner, twoBarkPanner, sheep1, dyingSheepBooster, boo, cheer, dryWetSuccessMixer, backgroundSampler)
        
        AudioKit.output = mixer
        AudioKit.start()
        
        backgroundMusic = AKSequencer(filename: "Sounds/smwintro", engine: AudioKit.engine)
    }
    
    static func playSound(forKey key: SoundKey) {
        switch key {
        case .BarkLoudKey:
            sharedInstance.barkLoud.play()
        case .TwoBarkKey:
            sharedInstance.twoBark.play()
        case .SheepSoundKey:
            sharedInstance.sheep1.play()
        case .DyingSheepKey:
            sharedInstance.dyingSheep.play()
        case .CrowdBooingKey:
            sharedInstance.boo.play()
        case .CrowdCheeringKey:
            sharedInstance.cheer.play()
        case .SuccessPingKey:
            sharedInstance.successPing.play()
        case .BackgroundMusicKey:
            sharedInstance.backgroundMusic.play()
        }
    }
}