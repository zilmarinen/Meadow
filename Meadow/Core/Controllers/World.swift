//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class World: SCNNode, GridObserver, SceneGraphChild, SceneGraphParent {
    
    public let blueprint = Blueprint()
    
    public let floor = Floor()
    
    public let areas = Area()
    public let foliage = Foliage()
    public let footpaths = Footpath()
    public let scaffolds = Scaffold()
    public let terrain = Terrain()
    public let tunnels = Tunnel()
    public let water = Water()
    
    let foliageResolver: FoliageResolver
    let terrainResolver: TerrainResolver
    let waterResolver: WaterResolver
    
    public var observer: GridObserver?
    
    public override init() {
        
        self.foliageResolver = FoliageResolver(foliage: foliage, terrain: terrain)
        self.terrainResolver = TerrainResolver(terrain: terrain, areas: areas, footpaths: footpaths)
        self.waterResolver = WaterResolver(water: water, terrain: terrain)
        
        super.init()
        
        self.name = "World"
        
        areas.observer = self
        areas.name = "Areas"
        areas.categoryBitMask = SceneGraphNodeType.area.rawValue
        
        foliage.observer = self
        foliage.name = "Foliage"
        foliage.categoryBitMask = SceneGraphNodeType.foliage.rawValue
        
        footpaths.observer = self
        footpaths.name = "Footpaths"
        footpaths.categoryBitMask = SceneGraphNodeType.footpaths.rawValue
        
        scaffolds.observer = self
        scaffolds.name = "Scaffolds"
        scaffolds.categoryBitMask = SceneGraphNodeType.scaffold.rawValue
        
        terrain.observer = self
        terrain.name = "Terrain"
        terrain.categoryBitMask = SceneGraphNodeType.terrain.rawValue
        
        tunnels.observer = self
        tunnels.name = "Tunnels"
        tunnels.categoryBitMask = SceneGraphNodeType.tunnel.rawValue
        
        water.observer = self
        water.name = "Water"
        water.categoryBitMask = SceneGraphNodeType.water.rawValue
        
        self.addChildNode(blueprint)
        self.addChildNode(floor)
        self.addChildNode(areas)
        self.addChildNode(foliage)
        self.addChildNode(footpaths)
        self.addChildNode(scaffolds)
        self.addChildNode(terrain)
        self.addChildNode(tunnels)
        self.addChildNode(water)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

extension World {
    
    public var totalChildren: Int { return childNodes.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return childNodes[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return childNodes.index(of: child)
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
            
        case is WaterTile.Type:
            
            waterResolver.enqueue(volume: child.volume)
            
        default: break
        }
        
        observer?.child(didBecomeDirty: child)
    }
}

extension World: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
    
        areas.update(deltaTime: deltaTime)
        foliage.update(deltaTime: deltaTime)
        footpaths.update(deltaTime: deltaTime)
        scaffolds.update(deltaTime: deltaTime)
        terrain.update(deltaTime: deltaTime)
        tunnels.update(deltaTime: deltaTime)
        water.update(deltaTime: deltaTime)
        
        foliageResolver.resolve()
        terrainResolver.resolve()
        waterResolver.resolve()
    }
}

extension World: SceneGraphIntermediate {
    
    public typealias IntermediateType = WorldIntermediate
    
    func load(intermediates: [IntermediateType]) {
        
        guard let intermediate = intermediates.first else { return }
        
        let areaNodes = intermediate.areas.children.flatMap { $0.children.flatMap { $0.children } }
        let foliageNodes = intermediate.foliage.children.flatMap { $0.children.flatMap { $0.children } }
        let footpathNodes = intermediate.footpaths.children.flatMap { $0.children.flatMap { $0.children } }
        let terrainNodes = intermediate.terrain.children.flatMap { $0.children.flatMap { $0.children } }
        let waterNodes = intermediate.water.children.flatMap { $0.children.flatMap { $0.children } }
        
        terrain.load(intermediates: terrainNodes)
        areas.load(intermediates: areaNodes)
        foliage.load(intermediates: foliageNodes)
        footpaths.load(intermediates: footpathNodes)
        water.load(intermediates: waterNodes)
        
        if let floorColor = ColorPalettes.shared?.color(named: intermediate.floorColor) {
            
            floor.color = floorColor
        }
    }
}

extension World: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        
        case areas
        case foliage
        case footpaths
        case terrain
        case water
        
        case floorColor
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.name, forKey: .name)
        
        try container.encode(self.areas, forKey: .areas)
        try container.encode(self.foliage, forKey: .foliage)
        try container.encode(self.footpaths, forKey: .footpaths)
        try container.encode(self.terrain, forKey: .terrain)
        try container.encode(self.water, forKey: .water)
        
        try container.encodeIfPresent(self.floor.color?.name, forKey: .floorColor)
    }
}

extension World {
    
    public static let ceiling: Int = 10
    public static let floor: Int = -10
    
    static var chunkSize: Int = 5
    static var tileSize: Int = 1
}
