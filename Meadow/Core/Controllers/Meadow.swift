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
    
    let areas = Area()
    let foliage = Foliage()
    let footpaths = Footpath()
    let scaffolds = Scaffold()
    let terrain = Terrain()
    let tunnels = Tunnel()
    let water = Water()
    
    var totalChildren: Int { return rootNode.childNodes.count }
    
    override init() {
        
        super.init()
        
        areas.observer = self
        foliage.observer = self
        footpaths.observer = self
        terrain.observer = self
        water.observer = self
        
        rootNode.name = "Meadow"
        rootNode.addChildNode(areas)
        rootNode.addChildNode(foliage)
        rootNode.addChildNode(footpaths)
        rootNode.addChildNode(scaffolds)
        rootNode.addChildNode(terrain)
        rootNode.addChildNode(tunnels)
        rootNode.addChildNode(water)
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

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        
    }
}
