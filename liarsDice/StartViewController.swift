//
//  StartViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 16/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate, InstructionsViewControllerDelegate {

    //var game = LiarsDiceGame()
    var playerName = String()
    //var playerInfo = Player(playerName)
    
    @IBOutlet weak var textBox: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    
//    @IBAction func startGame(_ sender: UIButton) {
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerName = textBox.text!
        textBox.resignFirstResponder()
        print(playerName)
    }
    
    
    func textFieldShouldReturn(_ textBox: UITextField) -> Bool {
        self.view.endEditing(true)
        playerName = textBox.text!
        print("Player Name:")
        print(playerName)
        return true
    }
    
    func comeBackToStart(controller: InstructionsViewController) {
        controller.navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "instructions" {
            let screen = segue.destination as! InstructionsViewController
            screen.delegate = self
        }
       if segue.identifier == "startGame" {
       // let game = LiarsDiceGame(pName: playerName)
        let mainScreen = segue.destination as! ViewController
        //let game = LiarsDiceGame(pName: textBox.text!)
        let game = LiarsDiceGame(pName: playerName)
        mainScreen.game = game
        mainScreen.opponentModel = OpponentModel(game: game)
        }
    }
    
    @IBAction func init_Game(_ sender: UIButton) {
        if textBox.text == "" {
            playerName = "Anonymous"
            //Prevent the view from changing somehow..
        }
        else {
            playerName = textBox.text!
        }
        
        
        //Initialize the game and set up the start of a new game here
        //let game = LiarsDiceGame(pName: playerName)
        //game.getPlayer()
        //game.getPlayer().getName()
        //performSegue(withIdentifier: "startGame", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textBox.backgroundColor = UIColor.clear
        textBox.textColor = UIColor.white
        textBox.layer.borderWidth = 2
        textBox.layer.borderColor = UIColor.white.cgColor
        textBox.layer.cornerRadius = 10
        textBox.attributedPlaceholder = NSAttributedString(string: "Enter a username",
                                                           attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        // Do any additional setup after loading the view.
        textBox.delegate = self
        textBox.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // \(textBox.text!) needs to be passed to next view and replace the 'You' label
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


