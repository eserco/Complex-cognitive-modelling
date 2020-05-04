//
//  OpponentModel.swift
//  liarsDice
//
//  Created by M. Gao on 16/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import Foundation

class OpponentModel: Model{
    var game: LiarsDiceGame
    var playerProfiles : Dictionary<String,Dictionary<String,String>>!
    private var playerBluff = 0
    private var playerGul = 0
    private var playerTotalTurnCount = 0
    private var filename = "profiles.txt"
    // initialize, set the game and load player profile, push chunks into model
    init(game: LiarsDiceGame) {
        self.game = game
        super.init()
        self.loadProfile(name: game.getPlayer().getName())
    }
    
    // loads player data from file if there is any, and initializes the model with it
    private func loadProfile(name: String) {
        // default stuff - overwrite if json contains data with same playername
        self.loadModel(fileName: "play-with-history")
        playerBluff = 0
        playerGul = 0
        playerTotalTurnCount = 0
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            do {
                let data = try Data(contentsOf: fileURL, options: .alwaysMapped)
                do{
                    
                    let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    playerProfiles =  json as! Dictionary<String,Dictionary<String,String>>
                    let pName = game.getPlayer().getName()
                    // print(playerProfiles[pName])
                    if playerProfiles[pName] != nil {
                        print("Yes I have data for this player")
                        playerBluff = Int(playerProfiles[pName]!["playerBluff"]!)!
                        playerGul = Int(playerProfiles[pName]!["playerGul"]!)!
                        playerTotalTurnCount = Int(playerProfiles[pName]!["turns"]!)!
                    }else {
                        playerProfiles[pName] = Dictionary<String,String>()
                        playerProfiles[pName]!["playerBluff"] = "0"
                        playerProfiles[pName]!["playerGul"] = "0"
                        playerProfiles[pName]!["turns"] = "0"
                    }
                    
                }catch let error{
                    
                    print(error.localizedDescription)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        let testStr = "player data: " + String(playerBluff) + " " + String(playerGul) + " " + String(playerTotalTurnCount)
        print(testStr)
        
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.run()
    }
    
    // update data and write back to file
    // do this after each round
    func updatePlayerProfile(){
        // if profiles file is empty, create object
        if(playerProfiles == nil){
            playerProfiles = Dictionary<String,Dictionary<String,String>>()
        }
        print("updatePlayerProfile")
        print(game)
        let pName = game.getPlayer().getName()
        print(game.getPlayer())
        print(pName)
        if(playerProfiles[pName] == nil){
            playerProfiles[pName] = [String:String]()
        }
        playerProfiles[pName]!["playerBluff"] = String(playerBluff)
        playerProfiles[pName]!["playerGul"] = String(playerGul)
        playerProfiles[pName]!["turns"] = String(playerTotalTurnCount + game.getTurnCount())
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(filename)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: playerProfiles, options: .prettyPrinted)
                //let str = jsonData.description
                try jsonData.write(to: fileURL)
                print(fileURL)
            }
            catch{
                print(error)
            }
            
        }

    }
    
    private func influence() -> Int{
        if playerTotalTurnCount <= 10 {
            return 1
        }
        else if playerTotalTurnCount <= 20 {
            return 2
        }
        else{
            return 3
        }
    }
    
    func believePlayer() -> Bool{
        // check if the bid is possible at all given the fixedDice
        if(isConflicting(bid: game.getLastBid(), fixed: game.getFixedDice())){
            return false
        }
        // also always call bullshit if rank is 6 (model should take care of it but seems buggy)
        if(game.getLastBidRank() == 6){
            return false
        }
        
        let msg = "playerbid: " + String(game.getLastBidRank()) + ", modelbid: 0, fix: " + String(game.getNumberOfFixedDice()) + ", playerBluff: " + String(playerBluff) + ", playerGul: " + String(playerGul) + ", turn: player, influence: " + String(influence())
        print(msg)
        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
        // self.modifyLastAction(slot: "modelbid", value: "0")
        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.modifyLastAction(slot: "turn", value: "player")
        self.modifyLastAction(slot: "influence", value: String(influence()))
        self.run()
        print("BELIEVE PLAYER: ")
        let believe = self.lastAction(slot: "response")
        print(String(describing: believe))
        self.run()
        return believe == nil || believe! == "believe"
        
    }
    
    private func fixDice(){
        if(game.getNumberOfFixedDice() >= 4) {return}
        let Decider = diceDecider();
        print("-------- DICE DECIDER ------------")
        let currentRoll = game.getDiceInPlay().map{String($0)}
        let diceNumber = currentRoll.count
        let history = game.getFixedDice().map{String($0)}
        print(diceNumber)
        print(currentRoll)
        let toBeFixed = Decider.playGame(diceNumber: diceNumber,currentRoll: currentRoll, history: history).map{$0-1}
        if(toBeFixed.count + game.getNumberOfFixedDice() > 4){
            print("Warning: tried to fix all dice, ABORT ABORT")
            return
        }
        game.fixDice(toBeFixed)
        
    }
    
    /**
     * Makes a bid. First calls ACT-R to get the desired bid rank, then calls createValidBid for the particular bid
     */
    private func makeBid(){
        let msg = "playerbid: " + String(game.getLastBidRank()) + ", modelbid: \(game.calculateRankOfRoll()), fix: " + String(game.getNumberOfFixedDice()) + ", playerBluff: " + String(playerBluff) + ", playerGul: " + String(playerGul) + ", turn: model, influence: " + String(influence())
        print(msg)
        self.modifyLastAction(slot: "playerbid", value: String(game.getLastBidRank()))
        self.modifyLastAction(slot: "modelbid", value: String(game.calculateRankOfRoll()))
        self.modifyLastAction(slot: "fix", value: String(game.getNumberOfFixedDice()))
        self.modifyLastAction(slot: "playerBluff", value: String(playerBluff))
        self.modifyLastAction(slot: "playerGul", value: String(playerGul))
        self.modifyLastAction(slot: "turn", value: "model")
        self.modifyLastAction(slot: "influence", value: String(influence()))
        self.waitingForAction = false
        self.run()
        print("WHAT TO BID: ")
        let response = self.lastAction(slot: "response")
        print(String(describing: response))
        var newBidRank = min(game.getLastBidRank(),game.calculateRankOfRoll())
        // model only works if it runs again after response...
        self.run()
        if(response == nil){
            newBidRank += 1
        } else{
            switch response! {
            case "oneh":
                newBidRank += 1
                break
            case "twoh":
                newBidRank += 2
                break
            case "threeh":
                newBidRank += 3
                break
            case "fourh":
                newBidRank += 4
                break
            case "t-bid":
                newBidRank = -1
                break
            default: // lastresort OR model fails and returns nil
                // try to stay within same rank if there are plausible bids, otherwise increase
                print("last resort: last bid is \(game.getLastBid()), fixed dice are \(game.getFixedDice())" )
                let canStayInRank = filterPlausibleBids(filterValidBids(generateAllBidsOfRankInOrder(rank: newBidRank))).count != 0
                if(!canStayInRank){
                    newBidRank += 1
                }
            
            }
        }
        print("new bid rank: " + String(newBidRank))
        game.setBid(createValidBid(rank: newBidRank))
        
    }
    
    private func generateAllBidsOfRankInOrder(rank : Int) -> [String]{
        var bids = [String]()
        let eyesFromLowToHigh = "234567"
        switch rank {
        case 0: // single
            for i in eyesFromLowToHigh{
                bids.append(String(i))
            }
            break
        case 1: // 1 pair
            for i in eyesFromLowToHigh{
                bids.append(String(repeating: String(i), count: 2))
            }
            break
        case 2: // 2 pair
            for i in eyesFromLowToHigh{
                let tmpFirstValue = String(repeating: String(i), count: 2)
                for j in eyesFromLowToHigh{
                    if(j < i){ // avoid symmetrical (1122 and 2211), so w.l.o.g. j < i
                        bids.append(tmpFirstValue + String(repeating: String(j), count: 2))
                    }
                }
            }
            break
        case 3: // 3 of a kind
            for i in eyesFromLowToHigh{
                bids.append(String(repeating: String(i), count: 3))
            }
            break
        case 4: // Full house
            for i in eyesFromLowToHigh{
                let tmpFirstValue = String(repeating: String(i), count: 3)
                for j in eyesFromLowToHigh{
                    if(j != i){ // no symmetry occurs in Full House (33322 != 22233)
                        bids.append(tmpFirstValue + String(repeating: String(j), count: 2))
                    }
                }
            }
            break
        case 5: // 4 of a kind
            for i in eyesFromLowToHigh{
                bids.append(String(repeating: String(i), count: 4))
            }
            break
        case 6: // 5 of a kind
            for i in eyesFromLowToHigh{
                bids.append(String(repeating: String(i), count: 5))
            }
            break
        default:
            print("if you see this something went terribly horribly wrong")
            return []
        }
        
        bids = bids.map{$0.replacingOccurrences(of: "7", with: "1")}
        return bids
    }
    
    // filters out all bids from a list that aren't valid at this point of the game
    private func filterValidBids(_ bids: [String]) -> [String]{
        return bids.filter{
            game.bidIsHigher($0)
        }
    }
    
    private func calculateCommon(bid: String, bid2: String) -> Int{
        // count each element in both to calculate common elements including duplicates
        var counts1: [Character: Int] = [:]
        for c in bid{
            counts1[c] = (counts1[c] ?? 0) + 1
        }
        var counts2: [Character: Int] = [:]
        for c in bid2{
            counts2[c] = (counts2[c] ?? 0) + 1
        }
        var common = ""
        for c in "234561"{
            common += String(repeating: String(c),count: min(counts1[c] ?? 0,counts2[c] ?? 0))
        }
        return common.count
        
    }
    private func isConflicting(bid : String, fixed: String) -> Bool{
        let bidLength = bid.count
        let fixedLength = fixed.count
        let common = calculateCommon(bid: bid, bid2: fixed)
        //print("common elements of \(bid) and \(fixed): \(common)")
        let conflicting = fixedLength + bidLength - common > 5
        //print("Is conflicting: \(conflicting)")
        return conflicting
        
    }
    
    private func filterPlausibleBids(_ bids: [String]) -> [String]{
        let fixed = game.getFixedDice()
        return bids.filter{!isConflicting(bid: $0, fixed: fixed)}
    }
    
    private func oddsOfBid(bid: String) -> Decimal{
        print(calculateCommon(bid: bid, bid2: game.getFixedDice()))
        let k = bid.count - calculateCommon(bid: bid, bid2: game.getFixedDice())
        let n = 5 - game.getFixedDice().count
       
        let nchoosek = factorial(n)/(factorial(k)*factorial(n-k))
        //print("n: \(n), k: \(k), n choose k: \(nchoosek)")
        return Decimal(nchoosek) * pow((1/6),k) * pow((5/6),n-k)
    }
    
    // a separate class for this math stuff would be cleaner?
    private func factorial(_ number : Int) -> Int{
        var fact: Int = 1
        let n: Int = number + 1
        for i in 1..<n{
            fact = fact * i
        }
        return fact
    }
    
    private func getOddsForBids(plausibleBids: [String]) -> [(String,Decimal)]{
                         // v--- beautiful
        //let plausibleBids = filterPlausibleBids(filterValidBids(generateAllBidsOfRankInOrder(rank: rank)))
        var bidsWithOdds = [(String,Decimal)]()
        var lastOdds = Decimal()
        for b in plausibleBids{
            lastOdds += oddsOfBid(bid: b)
            bidsWithOdds.append((b,lastOdds))
        }
        return bidsWithOdds
    }
    
    private func maximumOverlap(bids: [String], fixed: String) -> String{
        let allOverlaps = bids.map{return (calculateCommon(bid: $0, bid2: fixed),$0)}.sorted(by: {
            $0.0 > $1.0
        })
        let max = allOverlaps[0].0
        let maxOverlaps = allOverlaps.filter{$0.0 == max}
        let randomIndex = Int(arc4random_uniform(UInt32(maxOverlaps.count)))
        return maxOverlaps[randomIndex].1
    }
    
    private func createValidBid(rank: Int) -> String{
        // first check if we can bid truthfully
        if rank == -1 {
            var bid = game.getRoll()
            var counts: [Character:Int] = [:]
            for i in bid {
                counts[i] = (counts[i] ?? 0) + 1
            }
            var toFilterOut = ""
            for idx in counts.keys{
                if counts[idx] == 1{
                    toFilterOut.append(idx)
                }
            }
            bid = bid.filter {!toFilterOut.contains($0)}
            return bid
        }
        let validBids = filterValidBids(generateAllBidsOfRankInOrder(rank: rank))
        //print("valid bids: \(validBids)")
        let plausibleBids = filterPlausibleBids(validBids)
        if(plausibleBids.isEmpty){
            // if plausible bid on the same tier isnt possible go one higher if possible
            if (rank < 6){
                return createValidBid(rank: rank+1)
            }
                return maximumOverlap(bids: validBids, fixed: game.getFixedDice())
            }
        
        //print("fixed dice: \(game.getFixedDice()), plausible: \(plausibleBids)")
        //print("with odds (cumulative)")
        let bidsWithOdds = getOddsForBids(plausibleBids: plausibleBids)
        let (_,totalOdds) = bidsWithOdds.last!
        let random = Decimal(arc4random()) / Decimal(UINT32_MAX) * totalOdds
        var chosenBid = ""
        for (bid,odds) in bidsWithOdds{
            if(odds <= random){
                continue
            }
            else {
                chosenBid = bid
                break
            }
        }
        // in case something goes wrong; it shouldnt but we are paranoid
        if(chosenBid == ""){
            return plausibleBids[0]
        }
        return chosenBid
    }
    
    func calculateTurn() -> Bool{
        // call bluff and end turn if the player is believed to bluff
        if(!believePlayer()){
            print("The AI calls bullshit on your bid!")
            _ = game.isBidABluff()
            return true
        }
        // check if player was bluffing
        if(game.isBidABluff()){
            incrementPlayerBluff()
        } else{
            fixDice()
            decrementPlayerBluff()
        }
        
        game.rollDice()
        //makeBid()
        
        self.makeBid()
        _ = self.game.toggleTurn()
        return false
    }
    
    func incrementPlayerBluff(){
        playerBluff += 1
        if(playerBluff > 2){
            playerBluff = 2
        }
    }
    func decrementPlayerBluff(){
        playerBluff -= 1
        if(playerBluff < -2){
            playerBluff = -2
        }
    }
    
    func incrementPlayerGul(){
        playerGul += 1
        if(playerGul > 3){
            playerGul = 3
        }
    }
    func decrementPlayerGul(){
        playerGul -= 1
        if(playerGul < -2){
            playerGul = -2
        }
    }
    
}
