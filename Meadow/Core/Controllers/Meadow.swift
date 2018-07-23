//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

class Meadow: SCNScene, GridObserver, SceneGraphParent {
    
    let areas = Area()
    let foliage = Foliage()
    let footpaths = Footpath()
    let scaffolds = Scaffold()
    let terrain = Terrain()
    let tunnels = Tunnel()
    let water = Water()
    
    var observer: GridObserver?
    
    override init() {
        
        super.init()
        
        areas.observer = self
        foliage.observer = self
        footpaths.observer = self
        scaffolds.observer = self
        terrain.observer = self
        tunnels.observer = self
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
    
    var totalChildren: Int { return rootNode.childNodes.count }
    
    func child(at index: Int) -> SceneGraphChild? {
        
        return rootNode.childNodes[index] as? SceneGraphChild
    }
    
    func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return rootNode.childNodes.index(of: child)
    }
    
    func child(didBecomeDirty child: SceneGraphChild) {
        
        switch type(of: child) {
            
        case is TerrainLayer.Type:
            
            print("terrain")
            
        default: break
        }
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

        //
    }
}

extension Meadow: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        
        case areas
        case foliage
        case footpaths
        case terrain
        case water
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.rootNode.name, forKey: .name)
        
        try container.encode(self.areas, forKey: .areas)
        try container.encode(self.foliage, forKey: .foliage)
        try container.encode(self.footpaths, forKey: .footpaths)
        try container.encode(self.terrain, forKey: .terrain)
        try container.encode(self.water, forKey: .water)
    }
}
