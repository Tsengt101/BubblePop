//
//  HIghScoreController.swift
//  BubblePop
//
//  Created by Tha Thai Seng on 25/4/21.
//

import UIKit

class HighScoreController: UIViewController {
    
    var bestScoreDict = [String : Double]()
    var highScoreArray = [(key: String, value : Double)]()
    var gameplayScore = UserDefaults.standard.double(forKey: "gameplayScore")
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var highestScore: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var highScore2: UILabel!
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var highScore3: UILabel!
    @IBOutlet weak var playerScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerScore.text = String(gameplayScore)
        print(gameplayScore)
        if let bestScoreDict = UserDefaults.standard.dictionary(forKey: "bestScore") as! [String : Double]? {
            highScoreArray = bestScoreDict.sorted(by: {$0.value > $1.value})
            
            if highScoreArray.count == 1 {
                player1.text = highScoreArray[0].key
                highestScore.text = "\(highScoreArray[0].value)"
            } else if highScoreArray.count == 2 {
                player1.text = highScoreArray[0].key
                highestScore.text = "\(highScoreArray[0].value)"
                player2.text = highScoreArray[1].key
                highScore2.text = "\(highScoreArray[1].value)"
            } else {
                player1.text = highScoreArray[0].key
                highestScore.text = "\(highScoreArray[0].value)"
                player2.text = highScoreArray[1].key
                highScore2.text = "\(highScoreArray[1].value)"
                player3.text = highScoreArray[2].key
                highScore3.text = "\(highScoreArray[2].value)"
            }
        }
    }    
    
    @IBAction func goHome(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreen = storyboard.instantiateViewController(identifier: "HomeScreen")
        self.showDetailViewController(homeScreen, sender: self)
    }
    
}
