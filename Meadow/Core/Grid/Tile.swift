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
        
        case identifier
    }
    
    public weak var ancestor: SoilableParent?
    
    public let identifier: Int
    
    public let joints: [Int]
    
    public let vectors: [Vector]
    
    public let centre: Vector
    
    public var isDirty = false
    
    public var isHidden: Bool = false {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var name: String?
    
    var mesh: Mesh = Mesh(polygons: [])
    
    var neighbours: [Int : Tile] = [:]
    
    required init(ancestor: SoilableParent, identifier: Int, joints: [GraphCache.Joint], vectors: [Vector]) {
    
        self.ancestor = ancestor
        
        self.identifier = identifier
        
        self.joints = joints.map { $0.i }
        
        self.vectors = vectors
        
        self.centre = vectors.reduce(Vector.zero, { $0 + $1 }) / Double(vectors.count)
        
        self.name = "Tile [\(identifier)]"
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
    }
    
    public func child(didBecomeDirty child: SoilableChild) {
        
        ancestor?.child(didBecomeDirty: child)
        
        becomeDirty()
        
        neighbours.forEach { (_, tile) in
            
            tile.becomeDirty()
        }
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        mesh = render(transform: .identity)
        
        isDirty = false
        
        return true
    }
    
    func clear() {
        
        let identifiers = Array(neighbours.keys)
        
        identifiers.forEach { identifier in
            
            remove(neighbour: identifier)
        }
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {}
    
    func render(transform: Transform) -> Mesh { fatalError("Tile.render must be overridden") }
    
    public var children: [SceneGraphNode] { return [] }
    
    public var childCount: Int { return children.count }
    
    public var isLeaf: Bool { return children.isEmpty }
    
    public var category: SceneGraphNodeCategory { fatalError("Tile.category must be overridden") }
    
    public var type: SceneGraphNodeType { return .tile }
}
