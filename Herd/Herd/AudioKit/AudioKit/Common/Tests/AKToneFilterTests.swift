//
//  AKToneFilterTests.swift
//  AudioKitTestSuite
//
//  Created by Aurelius Prochazka on 8/9/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import XCTest
import AudioKit

class AKToneFilterTests: AKTestCase {

    func testDefault() {
        let input = AKOscillator()
        output = AKToneFilter(input)
        input.start()
        AKTestMD5("0dfbfda795edb60341efae8a8c7083c5")
    }
}
