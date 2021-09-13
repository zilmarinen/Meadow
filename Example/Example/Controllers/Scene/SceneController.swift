//
//  SceneController.swift
//
//  Created by Zack Brown on 27/08/2021.
//

import Foundation
import Meadow

class SceneController: ObservableObject, Updatable {
    
    weak private(set) var parent: AppController?
    
    init(parent: AppController) {
        
        self.parent = parent
    }
}

extension SceneController {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
