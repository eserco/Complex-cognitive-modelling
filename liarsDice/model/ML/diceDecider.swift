//
//  File.swift
//  MLTester
//
//  Created by A. Harish on 29/03/2018.
//  Copyright © 2018 A. Harish. All rights reserved.
//

import Foundation
class diceDecider {
    
    
    func loadActionTable(diceNumber: Int, ActionTable: Dictionary<String, String>) -> Dictionary<String,String> {
        
        var ActionTable = ActionTable
        var fileName : String = "";
        //select the file name based on the number of dices available.
        if (diceNumber == 2) {
            fileName = "2Dice";
        } ;
        if (diceNumber == 3) {
            fileName = "3Dice";
        } ;
        if (diceNumber == 4) {
            fileName = "4Dice";
        };
        if (diceNumber == 5) {
            fileName = "5Dice";
        };
        //open and read the file line by line and parse the inputs
        let path : String = Bundle.main.path(forResource: fileName, ofType: "dat")!;
        print(path);
        var actionData = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        for line in actionData.components(separatedBy: .newlines){
            //var skey = line.split{$0 == ")"}.map(String.init)
            if (line == "") {
                continue;
            }

            
            var skey = line.split(separator: ")")
            var akey = line.split(separator: "[")
            var entry = line.split(separator: "[")
            //self.ActionTable[array][seperatedTempLine] = tempLine;
            //skey[0] = [skey.removeFirst(1)]
           // print("-----------")
            //print(line);
            //print(skey);
            skey.remove(at: 1)
            skey[0] = skey[0] + ")"
            akey.remove(at:1)
            var temp = akey[0].split(separator: ")")
            temp = temp[1].split(separator: ",")
            akey = temp;
            
            entry.remove(at: 0)
            var temp2 = "[" + entry[0];
            //print(temp2)

            //print(skey);
            //print(akey);
            ActionTable[String(skey[0]) + akey[0]] = temp2;
            
        }
        //print(ActionTable)
        return (ActionTable);
    }
    func playGame(diceNumber: Int,currentRoll: Array<String>,history: Array<String>) -> [Int] {
        var ActionTable = [String:String]();
        
        ActionTable = loadActionTable(diceNumber: diceNumber,ActionTable: ActionTable);
        var finalKeeper: Array<Int> = [];

        var sortedRoll: Array<String> = currentRoll.sorted();
        print(sortedRoll);
        var actions : Int = getAllActions(diceNumber: diceNumber,sortedRoll: sortedRoll,ActionTable: ActionTable);
        var keepers = [Int]()
        for i in (0..<diceNumber) {
            var mask = pow(2,i);

            if (actions & Int(NSDecimalNumber(decimal:mask)) == 0) {
                print("mask:::\(mask)")
                keepers.append(i + 1)
                }
        }
        // print(keepers)
        //var newDice = evalAction(actions);
        //print(newDice);
        finalKeeper = unsorter(diceNumber: diceNumber,keepers: keepers,currentRoll: currentRoll,sortedRoll: sortedRoll);
        //var finalKeeper2 = finalKeeper
        if (finalKeeper.count == diceNumber) {
            if (history.count != 0) {
//                for i in (0..<finalKeeper.count) {
//                    if (!currentRoll.contains(history[i])) {
//
//                        finalKeeper2 = finalKeeper2.filter{currentRoll[$0-1] == history[i]}
//                        //finalKeeper.remove(at: (currentRoll.index(of: history[i]))! + 1)
//                    }
//                }
                finalKeeper = finalKeeper.filter{history.contains(currentRoll[$0-1])}
                
            } else {
                //return the mode of the roll and keep the rest
                var counts = [Int: Int]()
                currentRoll.forEach { counts[Int($0)!] = (counts[Int($0)!] ?? 0) + 1 }
                if let (value, count) = counts.max(by: {$0.1 < $1.1}) {
                    print("\(value) occurs \(count) times")
                    if (count != diceNumber) {
//                        for i in (0..<finalKeeper.count) {
//                            print("final keeper count: \(finalKeeper.count)")
//                            print(i)
//                            if (finalKeeper[i] != value) {
//                                finalKeeper.remove(at: i)
//                            }
//                        }
                        print("finalKeeper before filter: \(finalKeeper)")
                        finalKeeper = finalKeeper.filter{Int(currentRoll[$0-1]) == value}
                        print("finalKeeper after filter: \(finalKeeper)")
                    }
                }
            }
        }
        print("finalkepper: \(finalKeeper)")
        return finalKeeper
    }
    
    func unsorter(diceNumber: Int ,keepers: Array<Int>,currentRoll: Array<String>,sortedRoll: Array<String>) -> Array<Int>  {
        var finalKeeper: Array<Int> = [];
        for i in (0..<diceNumber) {
            for j in (0..<keepers.count) {
                if (sortedRoll[keepers[j] - 1] == currentRoll[i]) {
                    finalKeeper.append(i + 1);
                    break;
                }
            }
        }
        print (finalKeeper)
        return (finalKeeper);
        
    }
    
    func getAllActions(diceNumber: Int,sortedRoll: Array<String>,ActionTable: Dictionary<String,String>) -> Int{
        var maxval = 0.0
        var count = 0;
        var possibleActions = [String]();
        var totalActions = (pow(2,diceNumber));
        print("total actions:: \(totalActions)");
        var akey : String;
        for _ in (0..<Int(truncating: NSDecimalNumber(decimal:totalActions))) {
            akey = actionKeyMaker(Idx: count, diceNumber: diceNumber)
            count+=1;
            
            var temp = "(" + JoinedSequence(base: sortedRoll,separator: ", ") + ")"
            
            //print(String(describing: temp)+akey)
            var key = String(describing: temp)+akey;
            var tempValue = ActionTable[key]?.split(separator:",")
            
            print("tempValue: \(tempValue), ActionTable[key] \(ActionTable[key]), key = \(key) ...")
            //print(Array(ActionTable.keys))
            var value = tempValue![2].split(separator: "]")[0]
            //var value = self.ActionTable[temp2]?.split(separator:",")
            //print("value: \(value)")
            //value = value.trimmingCharacters(in: .whitespaces)
            if (Double(value.trimmingCharacters(in: .whitespaces))! > maxval) {
                maxval = Double(value.trimmingCharacters(in: .whitespaces))!;
            }
        }
        print("count:: \(count)")
        print("obtained maxval:: \(maxval)")
        count = 0
        for action in (0..<Int(truncating: NSDecimalNumber(decimal:totalActions))) {
            akey = actionKeyMaker(Idx: count,diceNumber: diceNumber)
            count+=1;
            let temp = "(" + JoinedSequence(base: sortedRoll,separator: ", ") + ")"
            let key = String(describing: temp)+akey;
            print("key::: \(key)")
            var tempValue = ActionTable[key]?.split(separator:",")
            let value = tempValue![2].split(separator: "]")[0]
            print(tempValue![2].split(separator: "]"))
            //var value = self.ActionTable[String(describing: self.currentRoll)+akey]?.split(separator:",")
            print("value: \(value)")
            print("maxval: \(maxval)")
            //print((maxval - Double(value.trimmingCharacters(in: .whitespaces))!))
            if ((maxval - Double(value.trimmingCharacters(in: .whitespaces))!) <= 0.0) {
                possibleActions.append(String(action))
            }
        }
        print(possibleActions)
        let idx : Int = Int(arc4random_uniform(UInt32(possibleActions.count)));
        print(idx)
        return Int(possibleActions[idx])!;
    }
    
    func actionKeyMaker(Idx : Int,diceNumber: Int) -> String {
        //var akeys = [String](repeating: i+=1, count: Int(NSDecimalNumber(decimal:pow(2,self.diceNumber))))
        var akeys = Array(0...(Int(truncating: NSDecimalNumber(decimal:pow(2,diceNumber))))-1);
        return String(akeys[Idx]);
    }
    
//    func evalAction(action : Int) {
//        var newDice = [String]();
//        for i in (1..<self.diceNumber) {
//            var mask = pow(2,i);
//            if (action & Int(NSDecimalNumber(decimal:mask)) == 0) {
//                newDice.append(self.currentRoll[i])
//            }
//        }
//    }
}
