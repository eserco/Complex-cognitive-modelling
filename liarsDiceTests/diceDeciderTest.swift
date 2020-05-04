//
//  diceDeciderTest.swift
//  liarsDiceTests
//
//  Created by M. Gao on 03/04/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import XCTest
@testable import liarsDice

class diceDeciderTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let Decider = diceDecider();
        var toBeFixed = Decider.playGame(diceNumber: 5,currentRoll: ["2","2","2","3","3"], history: []).map{$0-1}
        assert(toBeFixed == [0,1,2])
        toBeFixed = Decider.playGame(diceNumber: 5,currentRoll: ["1","1","2","3","4"], history: []).map{$0-1}
        assert(toBeFixed == [0,1])
        toBeFixed = Decider.playGame(diceNumber: 5,currentRoll: ["3","4","5","5","6"], history: []).map{$0-1}
        assert(toBeFixed == [2,3])
        toBeFixed = Decider.playGame(diceNumber: 4,currentRoll: ["1","2","3","5"], history: ["2"]).map{$0-1}
        assert(toBeFixed == [1])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
