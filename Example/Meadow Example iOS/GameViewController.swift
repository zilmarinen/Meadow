//
//  GameViewController.swift
//  Meadow Example iOS
//
//  Created by Zack Brown on 15/12/2020.
//

import UIKit
import Meadow
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupScene()
    }

    override var shouldAutorotate: Bool {
        
        return true
    }

    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}
