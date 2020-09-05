//
//  GameViewController.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var gameView: SCNView {
        
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}
