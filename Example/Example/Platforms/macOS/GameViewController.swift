//
//  GameViewController.swift
//  Meadow
//
//  Created by Zack Brown on 27/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Cocoa
import SceneKit
import Terrace

class GameViewController: NSViewController {
    
    var gameView: SceneView {
        
        return self.view as! SceneView
    }
    
    var gameController: GameController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameController = GameController(sceneRenderer: gameView)
    }
}
