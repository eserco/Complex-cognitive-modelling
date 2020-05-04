//
//  Player.swift
//  liarsDice
//
//  Created by M. Gao on 07/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation

class Player {
    // Player name
    private var name = "Player"
    // Player's current score
    private var score = 0
    // Player's current winning streak
    private var streak = 0
    
    init(_ playerName : String){
        name = playerName
    }
    
    // Resets the streak to zero
    func resetStreak() {
        streak = 0
    }
    // Increases the streak by one
    func incrementStreak() {
        streak += 1
    }
    // Increases the score by one
    func incrementScore() {
        score += 1
    }
    func setName(newName : String) {
        name = newName
    }
    func getScore() -> Int {
        return score
    }
    func getStreak() -> Int {
        return streak
    }
    func getName() -> String {
        return name
    }
}
