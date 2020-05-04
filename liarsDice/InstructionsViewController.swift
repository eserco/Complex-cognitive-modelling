//
//  InstructionsViewController.swift
//  liarsDice
//
//  Created by A.A. van Heereveld on 23/03/2018.
//  Copyright © 2018 A.A. van Heereveld. All rights reserved.
// 

import UIKit

class InstructionsViewController: UIViewController, UIScrollViewDelegate {

    var delegate:InstructionsViewControllerDelegate! = nil
    var game:LiarsDiceGame!
    
    @IBAction func back(_ sender: UIButton) {
        delegate.comeBackToStart(controller: self)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
        scrollView.contentOffset.x = 0
    }
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol InstructionsViewControllerDelegate {
    func comeBackToStart(controller: InstructionsViewController)
}
