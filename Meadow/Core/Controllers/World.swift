//
//  World.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class World: SCNNode, SceneGraphChild, SceneGraphObserver, SceneGraphParent {
    
    var children = Tree<SCNNode>()
    
    public var observer: SceneGraphObserver?
    
    public var volume: Volume { return Volume(coordinate: Coordinate.zero, size: Size.one) }
    
    public let blueprint = Blueprint()
    
    public let floor = Floor()
    
    public let actors = Actors()
    public let areas = Area()
    public let foliage = Foliage()
    public let footpaths = Footpath()
    public let props = Props()
    public let scaffolds = Scaffold()
    public let terrain = Terrain()
    public let tunnels = Tunnel()
    public let water = Water()
    
    let foliageResolver: FoliageResolver
    let footpathResolver: FootpathResolver
    let terrainResolver: TerrainResolver
    let waterResolver: WaterResolver
    
    public let pathfinder: Pathfinder
    
    public override init() {
        
        self.foliageResolver = FoliageResolver(foliage: foliage, terrain: terrain)
        self.footpathResolver = FootpathResolver(footpaths: footpaths, terrain: terrain)
        self.terrainResolver = TerrainResolver(terrain: terrain, areas: areas, footpaths: footpaths)
        self.waterResolver = WaterResolver(water: water, terrain: terrain)
        
        self.pathfinder = Pathfinder(areas: areas, footpaths: footpaths, props: props, terrain: terrain)
        
        super.init()
        
        self.name = "World"
        
        blueprint.name = "Blueprint"
        
        floor.name = "Floor"
        floor.categoryBitMask = SceneGraphNodeType.floor.rawValue
        
        actors.observer = self
        actors.name = "Actors"
        actors.categoryBitMask = SceneGraphNodeType.actors.rawValue
        
        areas.observer = self
        areas.name = "Areas"
        areas.categoryBitMask = SceneGraphNodeType.area.rawValue
        
        foliage.observer = self
        foliage.name = "Foliage"
        foliage.categoryBitMask = SceneGraphNodeType.foliage.rawValue
        
        footpaths.observer = self
        footpaths.name = "Footpaths"
        footpaths.categoryBitMask = SceneGraphNodeType.footpaths.rawValue
        
        props.observer = self
        props.name = "Props"
        props.categoryBitMask = SceneGraphNodeType.props.rawValue
        
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
        self.addChildNode(actors)
        self.addChildNode(areas)
        self.addChildNode(foliage)
        self.addChildNode(footpaths)
        self.addChildNode(props)
        self.addChildNode(scaffolds)
        self.addChildNode(terrain)
        self.addChildNode(tunnels)
        self.addChildNode(water)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func addChildNode(_ child: SCNNode) {
        
        if children.append(child) {
            
            super.addChildNode(child)
        }
    }
}

extension World {
    
    public var totalChildren: Int { return children.count }
    
    public func child(at index: Int) -> SceneGraphChild? {
        
        return children[index] as? SceneGraphChild
    }
    
    public func index(of child: SceneGraphChild) -> Int? {
        
        guard let child = child as? SCNNode else { return nil }
        
        return children.index(of: child)
    }
}

extension World {
    
    public func child(didBecomeDirty child: SceneGraphChild) {
        
        switch type(of: child) {
            
        case is AreaTile.Type:
            
            terrainResolver.enqueue(volume: child.volume)
            
        case is FoliageTile.Type:
            
            foliageResolver.enqueue(volume: child.volume)
            
        case is FootpathTile.Type:
            
            footpathResolver.enqueue(volume: child.volume)
            terrainResolver.enqueue(volume: child.volume)
            
        case is TerrainNodeEdge<TerrainNodeEdgeLayer>.Type,
             is TerrainNodeEdgeLayer.Type:
            
            terrainResolver.enqueue(volume: child.volume)
            waterResolver.enqueue(volume: child.volume)
            
        case is WaterTile.Type,
             is WaterNode<WaterNodeEdge>.Type,
             is WaterNodeEdge.Type:
            
            waterResolver.enqueue(volume: child.volume)
            
        default: break
        }
        
        observer?.child(didBecomeDirty: child)
    }
}

extension World: SceneGraphUpdatable {
    
    public func update(deltaTime: TimeInterval) {
    
        actors.update(deltaTime: deltaTime)
        areas.update(deltaTime: deltaTime)
        blueprint.update(deltaTime: deltaTime)
        foliage.update(deltaTime: deltaTime)
        footpaths.update(deltaTime: deltaTime)
        props.update(deltaTime: deltaTime)
        scaffolds.update(deltaTime: deltaTime)
        terrain.update(deltaTime: deltaTime)
        tunnels.update(deltaTime: deltaTime)
        water.update(deltaTime: deltaTime)
        
        footpathResolver.resolve()
        foliageResolver.resolve()
        terrainResolver.resolve()
        waterResolver.resolve()
    }
}

extension World: SceneGraphIntermediate {
    
    public typealias IntermediateType = WorldIntermediate
    
    func load(intermediates: [IntermediateType]) {
        
        guard let intermediate = intermediates.first else { return }
        
        let areaIntermediates = intermediate.areas.children.flatMap { $0.children.flatMap { $0.children } }
        let foliageIntermediates = intermediate.foliage.children.flatMap { $0.children.flatMap { $0.children } }
        let footpathIntermediates = intermediate.footpaths.children.flatMap { $0.children.flatMap { $0.children } }
        let propIntermediates = intermediate.props.children
        let terrainIntermediates = intermediate.terrain.children.flatMap { $0.children.flatMap { $0.children } }
        let waterIntermediates = intermediate.water.children.flatMap { $0.children.flatMap { $0.children } }
        
        terrain.load(intermediates: terrainIntermediates)
        areas.load(intermediates: areaIntermediates)
        foliage.load(intermediates: foliageIntermediates)
        footpaths.load(intermediates: footpathIntermediates)
        props.load(intermediates: propIntermediates)
        water.load(intermediates: waterIntermediates)
        
        if let floorColor = ArtDirector.shared?.color(named: intermediate.floorColor) {
            
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
        case props
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
        try container.encode(self.props, forKey: .props)
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
