//
//  Tile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class Tile: NSObject, Soilable, Clearable, Encodable, Neighbour, Renderable, SceneGraphIdentifiable, SceneGraphNode, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    public weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var name: String?
    
    var mesh: Mesh?
    
    let volume: Volume
    
    var neighbours: [Cardinal : Tile] = [:]
    
    required init(ancestor: SoilableParent, coordinate: Coordinate) {
    
        self.ancestor = ancestor
        
        self.volume = World.Axis.aligned(tile: coordinate)
        
        self.name = "Tile [\(coordinate.x), \(coordinate.y), \(coordinate.z)]"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(volume.coordinate, forKey: .coordinate)
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        let offset = World.Axis.aligned(chunk: volume.coordinate)
        
        let position = Vector(coordinate: volume.coordinate) - Vector(coordinate: offset.coordinate)
        
        let transform = Transform(position: position, rotation: .identity, scale: .one)
        
        mesh = render(transform: transform)
        
        isDirty = false
        
        return true
    }
    
    func clear() {
        
        Cardinal.allCases.forEach { cardinal in
            
            remove(neighbour: cardinal)
        }
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {}
    
    func render(transform: Transform) -> Mesh { return Mesh(polygons: []) }
    
    public var children: [SceneGraphNode] { return [] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("SceneGraphIdentifiable.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .tile }
}
