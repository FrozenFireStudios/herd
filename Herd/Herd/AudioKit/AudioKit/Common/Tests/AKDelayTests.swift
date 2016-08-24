//
//  AKDelayTests.swift
//  AudioKitTestSuite
//
//  Created by Aurelius Prochazka on 8/9/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import XCTest
import AudioKit

class AKDelayTests: AKTestCase {

    func testDefault() {
        let input = AKOscillator()
        output = AKDelay(input)
        input.start()
        AKTestMD5("9d8276ae08417423c632dacc348406b3")
    }
}
