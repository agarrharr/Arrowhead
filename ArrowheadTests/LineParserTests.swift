//
//  LineParserTests.swift
//  ArrowheadTests
//
//  Created by Adam Garrett-Harris on 4/7/22.
//

import Foundation
import XCTest

class LineParserTests: XCTestCase {
    func testGetTask() {
        let lineParser = LineParser()
        
        let result = lineParser.getTask(string: "No task here")
        
//        XCTAssertEqual(result, nil)
    }
}
