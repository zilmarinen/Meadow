//
//  GameViewController.swift
//  Meadow Example macOS
//
//  Created by Zack Brown on 15/12/2020.
//

import Cocoa
import SceneKit

class GameViewController: NSViewController {
    
    lazy var coordinator: AppCoordinator = {
        
        return AppCoordinator(controller: self)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        coordinator.start(with: nil)
    }
}
