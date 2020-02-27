//
//  GameViewController.swift
//  Meadow Example macOS
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 3Squared. All rights reserved.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    var gameView: SCNView {
        
        return self.view as! SCNView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
    }
}
