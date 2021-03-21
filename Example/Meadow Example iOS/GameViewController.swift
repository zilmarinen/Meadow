//
//  GameViewController.swift
//
//  Created by Zack Brown on 15/12/2020.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    lazy var coordinator: AppCoordinator = {
        
        return AppCoordinator(controller: self)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        coordinator.start(with: nil)
    }

    override var shouldAutorotate: Bool {
        
        return true
    }

    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}
