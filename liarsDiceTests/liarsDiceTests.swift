//
//  liarsDiceTests.swift
//  liarsDiceTests
//
//  Created by M. Gao on 09/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import XCTest
@testable import liarsDice

class liarsDiceTests: XCTestCase {
    var game = LiarsDiceGame(pName: "test")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // set up a first low bid, just a high card that is very low
        game.setBid("2")
        XCTAssertTrue(game.getLastBid() == "2")
        XCTAssertTrue(game.getLastBidRank() == 0)
        // another low bid of the same rank but higher dice value
        game.setBid("3")
        XCTAssertTrue(game.getLastBid() == "3")
        XCTAssertTrue(game.getLastBidRank() == 0)
        // try to set it back to 2, but hopefully fail so the last bid remains 3
        game.setBid("2")
        XCTAssertTrue(game.getLastBid() == "3")
        XCTAssertTrue(game.getLastBidRank() == 0)
        // set a bid that is just another high card with 3 as highest number, but add a 2 so it becomes higher
        game.setBid("32")
        XCTAssertTrue(game.getLastBid() == "32")
        XCTAssertTrue(game.getLastBidRank() == 0)
        // set a bid that is just 3 again, should fail
        game.setBid("3")
        XCTAssertTrue(game.getLastBid() == "32")
        XCTAssertTrue(game.getLastBidRank() == 0)
        // set a higher bid
        game.setBid("24243")
        XCTAssertTrue(game.getLastBid() == "44223")
        XCTAssertTrue(game.getLastBidRank() == 2)
        // set a lower bid again, twice (should fail so the bid remains 44223)
        game.setBid("2")
        XCTAssertTrue(game.getLastBid() == "44223")
        XCTAssertTrue(game.getLastBidRank() == 2)
        game.setBid("23234") // same rank but
        XCTAssertTrue(game.getLastBid() == "44223")
        XCTAssertTrue(game.getLastBidRank() == 2)
        
        // now test the comparisons of the bid and the actual dice. Reset the game
        game.reset()
        // roll dice and look up values
        game.rollDice()
        var pattern = String()
        for i in 0..<5{
            pattern.append(String(game.getDiceNumber(i)))
        }
        // set a truthful bid, then call bluff -> should be false
        game.setBid(pattern[0])
        XCTAssertFalse(game.isBidABluff())

        // do this again now set a bid but invert one value (7-value so 1 becomes 6, 2 becomes 5 etc) so it becomes false
        game.reset()
        game.rollDice()
        pattern = ""
        pattern.append(String(7-game.getDiceNumber(0)))
        for i in 1..<5{
            pattern.append(String(game.getDiceNumber(i)))
        }
        game.setBid(pattern)
        XCTAssertTrue(game.isBidABluff())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
