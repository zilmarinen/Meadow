//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public final class Meadow: SCNNode, SceneGraphIdentifiable, SceneGraphNode, Soilable {
    
    public let graph: Graph
    
    public weak var ancestor: SoilableParent?
    
    public var identifier: Int = -1
    
    public var isDirty: Bool = false
    
    public static var bundle: Bundle? { return Bundle(for: Meadow.self) }
    
    public lazy var actors: Actors = { return Actors() }()
    public lazy var area: Area = { return Area(graph: graph, ancestor: self) }()
    public lazy var foliage: Foliage = { return Foliage(graph: graph, ancestor: self) }()
    public lazy var footpath: Footpath = { return Footpath(graph: graph, ancestor: self) }()
    public lazy var terrain: Terrain = { return Terrain(graph: graph, ancestor: self) }()
    public lazy var water: Water = { return Water(graph: graph, ancestor: self) }()
    
    lazy var waterResolver: WaterResolver = { return WaterResolver(terrain: terrain, water: water) }()
    
    public required init(graph: Graph, json: MeadowJSON? = nil) {
        
        self.graph = graph
        
        super.init()
        
        self.name = json?.name ?? "Meadow"
        
        addChildNode(actors)
        addChildNode(area)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(terrain)
        addChildNode(water)
        
        geometry = graph.geometry
        
        guard let json = json else { return }
        
        area.decode(json: json.area)
        foliage.decode(json: json.foliage)
        footpath.decode(json: json.footpath)
        terrain.decode(json: json.terrain)
        water.decode(json: json.water)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    public var children: [SceneGraphNode] { return childNodes as! [SceneGraphNode] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { return .meadow }
    
    public var type: SceneGraphNodeType { return .grid }
}

extension Meadow {
    
    public func child(didBecomeDirty child: SoilableChild) {
        
        becomeDirty()
        
        guard let grid = child as? SceneGraphIdentifiable else { return }
        
        switch grid.category {

        case .terrain:
            
            self.waterResolver.enqueue(identifier: child.identifier)

        case .water:

            self.waterResolver.enqueue(identifier: child.identifier)

        default: break
        }
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        area.clean()
        foliage.clean()
        footpath.clean()
        terrain.clean()
        water.clean()
        
        isDirty = false
        
        return true
    }
}

extension Meadow: Updatable {
    
    public func update(delta: TimeInterval, time: TimeInterval) {
        
        waterResolver.update(delta: delta, time: time)
        
        actors.update(delta: delta, time: time)
        area.update(delta: delta, time: time)
        foliage.update(delta: delta, time: time)
        footpath.update(delta: delta, time: time)
        terrain.update(delta: delta, time: time)
        water.update(delta: delta, time: time)
    }
}

extension Meadow: Encodable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        
        case area
        case foliage
        case footpath
        case terrain
        case water
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(area, forKey: .area)
        try container.encode(foliage, forKey: .foliage)
        try container.encode(footpath, forKey: .footpath)
        try container.encode(terrain, forKey: .terrain)
        try container.encode(water, forKey: .water)
    }
}
