//
//  Tile.swift
//
//  Created by Zack Brown on 23/12/2020.
//

import SceneKit

public class Tile: NSObject, Codable, Collapsable, Renderable, Responder, SceneGraphNode, Soilable, Traversable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case slope
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var coordinate: Coordinate {
        
        didSet {
            
            guard coordinate.adjacency(to: oldValue) == .equal else {
                
                coordinate = oldValue
                
                return
            }
            
            invalidate(neighbours: true)
        }
    }
    
    public var name: String? { return "Tile \(coordinate.description)" }
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { fatalError("Tile.category must be overridden") }
    
    var movementCost: Int { 0 }
    var walkable: Bool { true }
    
    var seed: Int { (abs(coordinate.x + 1) * abs(coordinate.y + 2) * abs(coordinate.z + 4)) * 8 }
    
    public var neighbours: [Cardinal : Tile] = [:] {
        
        didSet {
            
            becomeDirty()
        }
    }
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    public var slope: Cardinal? = nil {
        
        didSet {
            
            guard oldValue != slope else { return }
            
            invalidate(neighbours: true)
        }
    }
    
    required init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        slope = try container.decodeIfPresent(Cardinal.self, forKey: .slope)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encodeIfPresent(slope, forKey: .slope)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        isDirty = false
        
        return true
    }
    
    func invalidate(neighbours: Bool) { fatalError("Tile.invalidate() must be overridden") }
    func update(delta: TimeInterval, time: TimeInterval) { fatalError("Tile.update() must be overridden") }
    func traversable(cardinal: Cardinal) -> Bool { fatalError("Tile.traversable() must be overridden") }
    func collapse() { fatalError("Tile.collapse() must be overridden") }
    func render(position: Vector) -> [Polygon] { fatalError("Tile.render() must be overridden") }
}

extension Tile {
    
    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension Tile {
    
    func add(neighbour: Tile, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours[cardinal] else { return }
        
        neighbours.removeValue(forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] == self {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}

extension Tile {
    
    var cornerHeights: [Int] {
        
        guard let slope = slope else { return Array(repeating: coordinate.y, count: 4) }
        
        return Ordinal.allCases.map {
            
            let (c0, c1) = $0.cardinals
            
            return coordinate.y + (slope == c0 || slope == c1 ? 1 : 0)
        }
    }
}

extension Tile {
    
    func find(neighbour cardinal: Cardinal) -> Self? {
        
        return neighbours[cardinal] as? Self
    }
    
    func find(neighbour ordinal: Ordinal) -> Self? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
    }
}

