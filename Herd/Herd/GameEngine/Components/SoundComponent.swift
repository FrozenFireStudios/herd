//
//  SoundComponent.swift
//  Herd
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 Frozen Fire Studios. All rights reserved.
//

import GameKit

class SoundComponent: GKComponent {

    func makeSound(named: SoundKey, angle: Float? = nil) {
        if let angle = angle {
            print("Make sound named", named, "with angle", angle)
        }
        else {
            print("Make sound named", named)
        }
        
        Conductor.sharedInstance.playSound(forKey: named)
    }
}
