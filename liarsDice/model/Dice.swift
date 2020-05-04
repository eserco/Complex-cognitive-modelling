//
//  Dice.swift
//  liarsDice
//
//  Created by M. Gao on 07/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation

class Dice {
    private var eyes = 1
    private var inPlay = true
    
    init() {
        roll()
    }
    
    // Roll the dice if it is not fixed. Value on fixed dice will remain the same
    func roll() {
        if(inPlay){
            eyes = Int(arc4random_uniform(6)) + 1
        } else {
            print("Warning: tried to roll a dice that is fixed")
        }
    }
    
    // Read the dice
    func getValue() -> Int{
        return eyes
    }
    
    func fix() {
        inPlay = false
    }
    
    /**
    * brings dice back into play and rerolls
    */
    func reset(){
        inPlay = true
        roll()
    }
    
    func isInPlay() -> Bool {
        return inPlay
    }
    
}
