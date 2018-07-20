//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

class Meadow: SCNScene, SceneGraphParent {
    
    let terrain = Terrain()
    
    var totalChildren: Int { return rootNode.childNodes.count }
    
    override init() {
        
        super.init()
        
        terrain.observer = self
        
        rootNode.addChildNode(terrain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Meadow {
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return rootNode.childNodes[index] as? SceneGraphChild
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return rootNode.childNodes.index(of: child)
    }
}

extension Meadow: GridObserver {
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch type(of: child) {
            
        case is TerrainLayer.Type:
            
            print("terrain")
            
        default: break
        }
    }
}

