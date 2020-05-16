//
//  Meadow.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import SceneKit

public final class Meadow: SCNNode, SceneGraphIdentifiable, SceneGraphNode {
    
    var lastUpdate: TimeInterval?
    
    public let actors = Actors()
    public let area = Area()
    public let foliage = Foliage()
    public let footpath = Footpath()
    public let terrain = Terrain()
    public let water = Water()
    
    public let floor = Floor()
    
    public override init() {
        
        super.init()
        
        self.name = "Meadow"
        
        addChildNode(actors)
        addChildNode(area)
        addChildNode(foliage)
        addChildNode(footpath)
        addChildNode(terrain)
        addChildNode(water)
        
        geometry = floor
    }
    
    public init(json: MeadowJSON) {
        
        super.init()
        
        self.name = json.name
        
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

extension Meadow: SCNSceneRendererDelegate {
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        let delta = time - (lastUpdate ?? time)
        
        actors.update(delta: delta, time: time)
        area.update(delta: delta, time: time)
        foliage.update(delta: delta, time: time)
        footpath.update(delta: delta, time: time)
        terrain.update(delta: delta, time: time)
        water.update(delta: delta, time: time)
        
        lastUpdate = time
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
