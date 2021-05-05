//
//  Bubble.swift
//  BubblePop
//
//  Created by Tha Thai Seng on 23/4/21.
//

import UIKit

class Bubble: UIButton {
    
    var bubbleScore: Double = 0
    var radius: UInt32 { return UInt32(UIScreen.main.bounds.width / 12) }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = CGFloat(radius)
        let colorChance = Int(arc4random_uniform(100))
        switch colorChance {
        case 0...39:
            self.backgroundColor = UIColor.red
            self.bubbleScore = 1
        case 40...69:
            self.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            self.bubbleScore = 2
        case 70...84:
            self.backgroundColor = UIColor.green
            self.bubbleScore = 5
        case 85...94:
            self.backgroundColor = UIColor.blue
            self.bubbleScore = 8
        case 95...99:
            self.backgroundColor = UIColor.black
            self.bubbleScore = 10
        default: print("")
        }
    }
    
    //Function animates the appearance of bubbles
    func bubbleMove() {
        let floatAnimation = CASpringAnimation(keyPath: "transform.scale")
        floatAnimation.duration = 0.6
        floatAnimation.fromValue = 1
        floatAnimation.toValue = 0.8
        floatAnimation.repeatCount = 1
        floatAnimation.initialVelocity = 0.5
        floatAnimation.damping = 1
        layer.add(floatAnimation, forKey: nil)
    }
    
    //Function animates the disappearance of bubbles when tapped
    func bubbleDisappear() {
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(x: Int(UIScreen.main.bounds.width / 2), y: 0, width: 0, height: 0 )
        }, completion: { done in
            if done {
                self.removeFromSuperview()
            }
        })
    }
}
