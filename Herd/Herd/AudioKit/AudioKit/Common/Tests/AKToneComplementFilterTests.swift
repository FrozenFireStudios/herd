//
//  AKToneComplementFilterTests.swift
//  AudioKitTestSuite
//
//  Created by Aurelius Prochazka on 8/9/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import XCTest
import AudioKit

class AKToneComplementFilterTests: AKTestCase {

    func testDefault() {
        let input = AKOscillator()
        output = AKToneComplementFilter(input)
        input.start()
        AKTestMD5("499964ad7d40dd5f5dfffd1b36d8acbe")
    }
}
