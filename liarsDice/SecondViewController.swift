//
//  SecondViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 09/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var diceTakenOut: [String]!
    var playerName : String!
    var lastBid : String!
    var game : LiarsDiceGame!
    var delegate:SecondViewControllerDelegate! = nil
   
    var eyes = ["⚀","⚁","⚂","⚃","⚄","⚅"]
    var currentBid = [String]()
    var submittedBid = String()
    
    var currentRoll: [String] = []
    var currentRollAsString = String()
    
    var selectedRank = false
    var selectedRankValue = Int()
 
    @IBOutlet var rankButtons: [UIButton]!
    
    var singleSelected = false
    var selectedFirst = false
    var selectedSecond = false
    var singleBidValue = String()
    var doubleBidFirstValue = String()
    var doubleBidSecondValue = String()
    
    @IBAction func back(_ sender: Any) {
        delegate.comeBackFromBid(controller: self)
    }
    
    func calculateCurrentlySelectedBid(){
        currentBid.removeAll()
        //0, 1, 3, 5, 6 :: single value
        if singleSelected == true {
            var loopAmount = 3
            if selectedRankValue == 5 || selectedRankValue == 6 {
                loopAmount = selectedRankValue - 1
            }
            if selectedRankValue == 0 || selectedRankValue == 1 {
                loopAmount = selectedRankValue + 1
            }
            for _ in 0..<loopAmount {
                currentBid.append(singleBidValue)
            }
            submittedBid = currentBid.joined()
            //print(submittedBid)
        }
        if selectedRankValue == 2 || selectedRankValue == 4 {
            if selectedRankValue == 4 {
                currentBid.append(doubleBidFirstValue)
            }
            for _ in 0..<2 {
                currentBid.append(doubleBidFirstValue)
                currentBid.append(doubleBidSecondValue)
            }
        }
    }
    
    @IBAction func submitBid(_ sender: Any) {
        calculateCurrentlySelectedBid()
        
        submittedBid = currentBid.joined()
                delegate.didSetBid(controller: self,
                                   bid: submittedBid)
    }
    
    @IBAction func singleTouch(_ sender: Any) {
        let selectedDie = rowTwo.index(of: sender as! UIButton)
        
        if singleSelected == false {
            rowTwo[selectedDie!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            singleSelected = true
        }
        else {
            for index in 0..<rowTwo.count {
                if selectedDie != index {
                    rowTwo[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rowTwo[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                }
            }
        }
        let selectedDieValue = rowTwo.index(of: sender as! UIButton)! + 1
        singleBidValue = String(selectedDieValue)
        calculateCurrentlySelectedBid()
        print(currentBid.joined())
        let isValidBid = game.bidIsHigher(currentBid.joined())
        print(isValidBid)
        if singleSelected == true && selectedRank == true && isValidBid {
            submitBid.setTitle("Submit", for: UIControlState.normal)
            submitBid.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
            submitBid.isHidden = false
            tooLowAlert.isHidden = true
        } else if singleSelected && selectedRank {
            tooLowAlert.isHidden = false
            submitBid.isEnabled = false
            submitBid.isHidden = true
        } else {
            tooLowAlert.isHidden = true
            submitBid.isEnabled = false
            submitBid.isHidden = true
        }
    }
    
    
    //   function only covers 2 pairs and full house
    @IBAction func touchFirst(_ sender: UIButton) {
        let selectedOne = rowOne.index(of: sender)
        for index in 0...5{
            rowThree[index].isEnabled = true
        }
        
        
        if selectedFirst == false {
            rowOne[selectedOne!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            rowThree[selectedOne!].isEnabled = false
            selectedFirst = true
            //rowThree[selectedOne!].isEnabled = false
        }
        else {
            for index in 0...5 {
                if selectedOne != index {
                    rowOne[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                    rowThree[index].isEnabled = true
                    //rowThree[index].setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: UIControlState.normal)
                        
                    }
                else {
                    rowOne[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                    rowThree[index].isEnabled = false
                }
            }
        }
    
        doubleBidFirstValue = String(rowOne.index(of: sender)! + 1)
        calculateCurrentlySelectedBid()
        print(currentBid.joined())
        let isValidBid = game.bidIsHigher(currentBid.joined())
        print(isValidBid)
        if selectedFirst == true && selectedSecond == true && selectedRank == true && isValidBid{
            submitBid.setTitle("Submit", for: UIControlState.normal)
            submitBid.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
            submitBid.isHidden = false
            tooLowAlert.isHidden = true
        } else if selectedFirst && selectedSecond {
            tooLowAlert.isHidden = false
            submitBid.isEnabled = false
            submitBid.isHidden = true
        } else {
            tooLowAlert.isHidden = true
            submitBid.isEnabled = false
            submitBid.isHidden = true
        }
    }
    
    
    @IBAction func touchSecond(_ sender: UIButton) {
        let selectedTwo = rowThree.index(of: sender)

        for index in 0...5{
            rowOne[index].isEnabled = true
        }
        
        if selectedSecond == false {
            rowThree[selectedTwo!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
            selectedSecond = true
            rowOne[selectedTwo!].isEnabled = false
        }
        else {
            for index in 0...5 {
                //rowThree[index].setTitle(eyes[index], for: UIControlState.normal)
                if index != selectedTwo {

                    rowThree[index].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                }
                else {
                    rowThree[index].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                    rowOne[index].isEnabled = false
                }
            }
        }
        doubleBidSecondValue = String(rowThree.index(of: sender)! + 1)
        calculateCurrentlySelectedBid()
        print(currentBid.joined())
        let isValidBid = game.bidIsHigher(currentBid.joined())
        print(isValidBid)
        if selectedFirst == true && selectedSecond == true && selectedRank == true && isValidBid
            {
            submitBid.setTitle("Submit", for: UIControlState.normal)
            submitBid.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            submitBid.isEnabled = true
            submitBid.isHidden = false
            tooLowAlert.isHidden = true
        } else if selectedFirst == true && selectedSecond == true {
            tooLowAlert.isHidden = false
            submitBid.isEnabled = false
            submitBid.isHidden = true
        } else {
            tooLowAlert.isHidden = true
            submitBid.isEnabled = false
            submitBid.isHidden = true
        }
    }
    
    @IBOutlet weak var tooLowAlert: UILabel!
    @IBOutlet weak var submitBid: UIButton!
    
    @IBAction func buttonTouch(_ sender: Any) {
        
        print("Button touch")
        let lastRank = game.getLastBidRank()
        let lastBid = game.getLastBid()
        print("last bid was " + String(lastBid) + " of rank " + String(lastRank))
        let selectedButton = rankButtons.index(of: sender as! UIButton)
        
        if selectedRank == false {
        rankButtons[selectedButton!].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
        selectedRank = true
        }
    
        else {
            for idx in 0..<rankButtons.count {
                if !rankButtons[idx].isEnabled {continue}
                if selectedButton != idx {
                    rankButtons[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                }
                else  {
                    rankButtons[idx].setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: UIControlState.normal)
                }
            }
        }
    
        let lastBidRank = game.getLastBidRank()
        print("the pressed button is " + String(describing: selectedButton))
        var higherPairNumber = Int(lastBid[0]) // for two pairs the first number in bid is always highest
        if (higherPairNumber == 1){
            higherPairNumber = 7
        }
        //Adjust visibility of buttons below
        if selectedButton == 2 {
            for idx in 0..<rowTwo.count {
                rowTwo[idx].setTitleColor(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0), for: UIControlState.normal)
                rowTwo[idx].isEnabled = false
                
                rowOne[idx].isEnabled = true
                rowOne[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                
                rowThree[idx].isEnabled = true
                rowThree[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            }
        } else if selectedButton == 4 {
            for idx in 0..<rowTwo.count {
                rowTwo[idx].setTitleColor(#colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 0), for: UIControlState.normal)
                rowTwo[idx].isEnabled = false
                rowOne[idx].isEnabled = true
                rowThree[idx].isEnabled = true
                rowOne[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                rowThree[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            }
        }
        else {
            for idx in 0..<rowOne.count {
                rowOne[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                rowThree[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
                rowOne[idx].isEnabled = false
                rowThree[idx].isEnabled = false
                
                rowTwo[idx].isEnabled = true
                rowTwo[idx].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
                
            }
        }
        
        //Set appropriate button titles (I am aware that this is awful coding)
        if selectedButton == 0 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 1 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 3 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 5 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        if selectedButton == 6 {
            for idx in 0...5 {
                rowTwo[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        
        //I'm sorry if your eyes start to bleed as a result of looking at this code
        if selectedButton == 2 {
            for idx in 0...5 {
                rowOne[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
                rowThree[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)

            }
        }
        if selectedButton == 4 {
            for idx in 0...5 {
                rowOne[idx].setTitle(eyes[idx]+eyes[idx]+eyes[idx], for: UIControlState.normal)
                rowThree[idx].setTitle(eyes[idx]+eyes[idx], for: UIControlState.normal)
            }
        }
        
        selectedRankValue = rankButtons.index(of: sender as! UIButton)!
        singleSelected = false
        selectedFirst = false
        selectedSecond = false
        submitBid.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0), for: UIControlState.normal)
        submitBid.isEnabled = false
    }
    
    @IBOutlet var rowOne: [UIButton]!
    
    @IBOutlet var rowTwo: [UIButton]!
    
    @IBOutlet var rowThree: [UIButton]!
    
   

    @IBOutlet weak var rollDisplay: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rollDisplay.text = currentRollAsString
        var lastBid = game.getLastBid()
        var displayOpponentBid = String()
        for idx in 0..<lastBid.count {
            let integer = Int(lastBid[idx])
            print("disp opponent bid \(lastBid[idx])")
            displayOpponentBid.append(eyes[integer! - 1])
        }
        tooLowAlert.numberOfLines = 0
        tooLowAlert.text = "Last bid: \n" + displayOpponentBid
        print(tooLowAlert.text)
        print("opened bidding screen, disabling rank buttons")
        var disableUpTo = game.getLastBidRank()
        if(game.isHighestOfRank()){
            disableUpTo += 1 // e.g. if previous bid was 11, disable one pair too because it cant be higher
        }
        print("disabling everything up to " + String(disableUpTo))

        for i in 0..<disableUpTo{
            rankButtons[i].setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 0.2018045775), for: UIControlState.normal)
            rankButtons[i].isEnabled = false
        }
        // in case of reset, we need to re-enable previously disabled bids
        for i in disableUpTo..<7{
            rankButtons[i].setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: UIControlState.normal)
            rankButtons[i].isEnabled = true
        }
        //String(describing: currentRoll)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCurrentRoll(currentRoll: [String]){
        self.currentRoll = currentRoll
       
    }
    
    func setCurrentRollAsString(currentRollAsString: String) {
         self.currentRollAsString = currentRollAsString
    }
    func setGame(game: LiarsDiceGame){
        self.game = game
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back" {
            let mainScreen = segue.destination as! ViewController
            mainScreen.game = LiarsDiceGame(pName: playerName)
        }
        
        if segue.identifier == "submitBid" {
        let mainScreen = segue.destination as! ViewController
        mainScreen.game = LiarsDiceGame(pName: playerName)
            mainScreen.holdButton.isHidden = true
            mainScreen.holdButton.isEnabled = false
            
            for index in 0...5 {
            mainScreen.allDice[index].isHidden = true
            mainScreen.allDice[index].isEnabled = false
            }
        //mainScreen.hasLoaded = true
        //mainScreen.labelPlayer.text = playerName!
        //game.setBid(submittedBid)
        }
    }

}

protocol SecondViewControllerDelegate {
    func didSetBid(controller: SecondViewController,bid:String)
    func comeBackFromBid(controller:SecondViewController)
}
