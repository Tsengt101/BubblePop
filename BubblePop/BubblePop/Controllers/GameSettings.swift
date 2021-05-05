//
//  GameSettings.swift
//  BubblePop
//
//  Created by Tha Thai Seng on 25/4/21.
//

import UIKit

class GameSettings: UIViewController, UITextFieldDelegate {
    
    var gameTime : Int = 60
    var maxBubbleAmount : Int = 15
    
    @IBOutlet weak var gameTimeLabel: UILabel!
    @IBOutlet weak var maxBubbleLabel: UILabel!
    @IBOutlet weak var playerName: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerName.delegate = self
        if ((playerName.text?.isEmpty) != nil) {
            startButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func gameTimerSlider(_ sender: UISlider) {
        gameTime = lroundf(sender.value)
        gameTimeLabel.text = "\(gameTime)"
    }
    
    @IBAction func maxBubbleSlider(_ sender: UISlider) {
        maxBubbleAmount = lroundf(sender.value)
        maxBubbleLabel.text = "\(maxBubbleAmount)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            startButton.isUserInteractionEnabled = true
        } else {
            startButton.isUserInteractionEnabled = false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGame" {
            let dest = segue.destination as! GamePlayController
            dest.gameplayTimer = gameTime
            dest.maxBubbleAmount = maxBubbleAmount
            dest.playerName = playerName.text!
        }
    }
}
