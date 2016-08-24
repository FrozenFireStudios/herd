//
//  DisplayComponent.swift
//  sheep
//
//  Created by Marcus Smith on 8/23/16.
//  Copyright © 2016 360iDevGameJam. All rights reserved.
//

import GameKit

class DisplayComponent: GKComponent {
    var display: Displayable
    
    init(display: Displayable) {
        self.display = display
    }
}
