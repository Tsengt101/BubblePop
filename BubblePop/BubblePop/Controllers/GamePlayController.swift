//
//  GamePlayController.swift
//  BubblePop
//
//  Created by Tha Thai Seng on 20/4/21.
//

import UIKit
import AVFoundation

class GamePlayController: UIViewController {
    
    var audioPlayer : AVAudioPlayer! = nil
    var timer : Timer!
    var countDown : Timer!
    var countdownNumber = 1
    var bubble = Bubble()
    var bubbleArray = [Bubble]()
    var gameplayTimer : Int = 60
    var gameplayScore : Double = 0
    var lastBubbleScore : Double = 0
    var maxBubbleAmount = 15
    var highestScore : Double = 0
    var playerName : String = " "
    var bestScoreDict = [String : Double]()
    var highScoreArray = [(key: String, value : Double)]()
    var lastRankingDict : Dictionary? = [String : Double]()
    var screenWidth: UInt32 { return UInt32(UIScreen.main.bounds.width) }
    var screenHeight: UInt32 { return UInt32(UIScreen.main.bounds.height) }
    
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var GameScore: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Retrieve ranking data from UserDefaults and store the data in a dictionary array
        lastRankingDict = UserDefaults.standard.dictionary(forKey: "bestScore") as? Dictionary<String, Double>
        if lastRankingDict != nil {
            bestScoreDict = lastRankingDict!
            highScoreArray = bestScoreDict.sorted(by: {$0.value > $1.value})
            highestScore = highScoreArray[0].value
            highScore.text = String(highestScore)
        }

        
        //get the path to the bubble pop audio
        let path = Bundle.main.url(forResource: "popsound", withExtension: "m4a")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path!)
            audioPlayer.prepareToPlay()
        } catch {
            print ("error")
        }
        
        //Countdown timer before starting the game
        countDown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.countdownNumber -= 1
            self.countdownTimer.text = String(self.countdownNumber)
            if self.countdownNumber == 0 {
                self.countdownTimer.text = ""
                self.countDown.invalidate()
                self.startGame()
            }
        }
    }
    
    //Function initiates the game
    func startGame() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true)
        {_ in
            self.timerCountDown()
            self.removeBubble()
            self.generateBubble()
        }
    }

    //Function creates random bubbles below the user desired amount
    @objc func generateBubble() {
        let bubbleAmount = arc4random_uniform(UInt32(maxBubbleAmount - bubbleArray.count)) + 1
        var i = 0
        
        while i < bubbleAmount {
            bubble = Bubble()
            bubble.frame = CGRect(x: CGFloat(10 + arc4random_uniform(screenWidth - 2 * bubble.radius - 20)), y: CGFloat(160 + arc4random_uniform(screenHeight - 2 * bubble.radius - 180)), width: CGFloat(2 * bubble.radius), height: CGFloat(2 * bubble.radius))
            if !overlapped(newBubble: bubble) {
                self.view.addSubview(bubble)
                bubble.bubbleMove()
                bubble.addTarget(self, action: #selector(tapBubble), for: UIControl.Event.touchUpInside)
                i += 1
                bubbleArray += [bubble]
            }
        }
    }
    
    //Function removes previously generated bubbles that the player has not managed to pop
    @objc func removeBubble() {
        var i = 0
        while i < bubbleArray.count {
            if arc4random_uniform(100) < 33 {
                bubbleArray[i].removeFromSuperview()
                bubbleArray.remove(at: i)
                i += 1
            }
        }
    }
    
    //Function controls the overlays of bubbles so they do not cross over each other
    func overlapped(newBubble: Bubble) -> Bool {
        for currentBubble in bubbleArray {
            if newBubble.frame.intersects(currentBubble.frame) {
                return true
            }
        }
        return false
    }
    
    //Function removes the bubble when tapped by the player then generates appropriate scores
    @IBAction func tapBubble(_ sender : Bubble) {
        audioPlayer.play()
        sender.bubbleDisappear()
        if lastBubbleScore == sender.bubbleScore {
            self.gameplayScore += (sender.bubbleScore * 1.5)
        } else {
            self.gameplayScore += sender.bubbleScore
        }
        lastBubbleScore = sender.bubbleScore
    
        GameScore.text = "\(gameplayScore)"
        if gameplayScore > highestScore {
            highestScore = gameplayScore
            highScore.text = "\(highestScore)"
        }
    }
    
    //Function count down the timer in the appropriate 1 second interval
    @objc func timerCountDown() {
        timeRemaining.text = "\(gameplayTimer)"
        
        if gameplayTimer == 0 {
            timer.invalidate()
            checkIfHighScore()
            let defaults = UserDefaults.standard
            defaults.setValue(gameplayScore, forKey: "gameplayScore")
            let anotherPage = storyboard?.instantiateViewController(withIdentifier: "HighScoreController") as! HighScoreController
            present(anotherPage, animated: true, completion: nil)
        }
        gameplayTimer -= 1
    }
    
    //Function checks if the highscore has been breached
    func checkIfHighScore() {
        if lastRankingDict == nil {
            saveHighScore()
        } else {
            bestScoreDict = lastRankingDict!
            if bestScoreDict.keys.contains("\(playerName)") {
                let score = bestScoreDict["\(playerName)"]!
                if score < gameplayScore {
                    saveHighScore()
                }
            } else {
                saveHighScore()
            }
        }
    }
    
    //Function stores new high score into the ranking dictionary array
    func saveHighScore() {
        bestScoreDict.updateValue(gameplayScore, forKey: "\(playerName)")
        UserDefaults.standard.set(bestScoreDict, forKey: "bestScore")
    }
}
