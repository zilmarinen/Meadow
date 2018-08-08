//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation
import SceneKit

public class Meadow: SCNScene, GridObserver, SceneGraphParent {
    
    public let areas = Area()
    public let foliage = Foliage()
    public let footpaths = Footpath()
    public let scaffolds = Scaffold()
    public let terrain = Terrain()
    public let tunnels = Tunnel()
    public let water = Water()
    
    public let cameraJib = CameraJib()
    
    public var observer: GridObserver?
    
    var lastUpdate: TimeInterval?
    
    let terrainResolver: TerrainResolver
    let waterResolver: WaterResolver
    
    public init(observer: GridObserver?) {
        
        self.observer = observer
        
        self.terrainResolver = TerrainResolver(terrain: terrain, areas: areas, footpaths: footpaths)
        self.waterResolver = WaterResolver(water: water, terrain: terrain)
        
        super.init()
        
        areas.observer = self
        areas.name = "Areas"
        
        foliage.observer = self
        foliage.name = "Foliage"
        
        footpaths.observer = self
        footpaths.name = "Footpaths"
        
        scaffolds.observer = self
        scaffolds.name = "Scaffolds"
        
        terrain.observer = self
        terrain.name = "Terrain"
        
        tunnels.observer = self
        tunnels.name = "Tunnels"
        
        water.observer = self
        water.name = "Water"
        
        rootNode.name = "Meadow"
        rootNode.addChildNode(cameraJib)
        rootNode.addChildNode(areas)
        rootNode.addChildNode(foliage)
        rootNode.addChildNode(footpaths)
        rootNode.addChildNode(scaffolds)
        rootNode.addChildNode(terrain)
        rootNode.addChildNode(tunnels)
        rootNode.addChildNode(water)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension Meadow {
    
    public var totalChildren: Int { return rootNode.childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return rootNode.childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return rootNode.childNodes.index(of: child)
    }
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        guard let child = child as? GridChild else { return }
        
        switch type(of: child) {
            
        case is AreaTile.Type:
            
            terrainResolver.enqueue(volume: child.volume)
            
        case is FootpathTile.Type:
            
            terrainResolver.enqueue(volume: child.volume)
            
        case is TerrainLayer.Type:
            
            terrainResolver.enqueue(volume: child.volume)
            waterResolver.enqueue(volume: child.volume)
            
        default: break
        }
        
        observer?.child(didBecomeDirty: child)
    }
}

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (self.lastUpdate ?? 0)
        
        terrainResolver.resolve()
        
        cameraJib.update(deltaTime: delta)
        areas.update(deltaTime: delta)
        foliage.update(deltaTime: delta)
        footpaths.update(deltaTime: delta)
        scaffolds.update(deltaTime: delta)
        terrain.update(deltaTime: delta)
        tunnels.update(deltaTime: delta)
        water.update(deltaTime: delta)

        self.lastUpdate = time
    }
}

extension Meadow {
    
    public func load(intermediate: MeadowIntermediate) {
        
        let areaNodes = intermediate.areas.children.flatMap { $0.children.flatMap { $0.children } }
        let foliageNodes = intermediate.foliage.children.flatMap { $0.children.flatMap { $0.children } }
        let footpathNodes = intermediate.footpaths.children.flatMap { $0.children.flatMap { $0.children } }
        let terrainNodes = intermediate.terrain.children.flatMap { $0.children.flatMap { $0.children } }
        let waterNodes = intermediate.water.children.flatMap { $0.children.flatMap { $0.children } }
        
        terrain.load(nodes: terrainNodes)
        areas.load(nodes: areaNodes)
        foliage.load(nodes: foliageNodes)
        footpaths.load(nodes: footpathNodes)
        water.load(nodes: waterNodes)
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
