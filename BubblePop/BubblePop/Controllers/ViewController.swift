//
//  ViewController.swift
//  BubblePop
//
//  Created by Tha Thai Seng on 14/4/21.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = playButton.frame.height/2
        playButton.layer.masksToBounds = false
        playButton.clipsToBounds = true
        UserDefaults.standard.setValue(nil, forKey: "gameplayScore")
    }
}

