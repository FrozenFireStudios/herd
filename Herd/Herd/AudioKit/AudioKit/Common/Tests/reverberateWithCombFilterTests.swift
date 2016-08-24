//
//  reverberateWithCombFilterTests.swift
//  AudioKit
//
//  Created by Aurelius Prochazka on 8/9/16.
//  Copyright © 2016 AudioKit. All rights reserved.
//

import XCTest

import AudioKit

class reverberateWithCombFilterTests: AKTestCase {

    override func setUp() {
        super.setUp()
        duration = 1.0
    }

    func testDefault() {
        let input = AKOscillator()
        input.start()
        output = AKOperationEffect(input) { input, _ in
            return input.reverberateWithCombFilter()
        }
        AKTestMD5("65b2a1ed137e036c9ee2cc0f0090f4c4")
    }

}
