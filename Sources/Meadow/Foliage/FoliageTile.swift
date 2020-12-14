//
//  FoliageTile.swift
//
//  Created by Zack Brown on 07/12/2020.
//

import Foundation

public class FoliageTile: NSObject, Codable, Renderable, Responder, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
        case tileType
    }
    
    public var ancestor: SoilableParent? { return chunk }
    
    public var isDirty: Bool = false
    
    weak var chunk: FoliageChunk?
    public var coordinate: Coordinate {
        
        didSet {
            
            guard coordinate.adjacency(to: oldValue) == .equal else {
                
                coordinate = oldValue
                
                return
            }
            
            becomeDirty()
        }
    }
    
    public var name: String? { return "Tile \(coordinate.description)" }
    
    public var children: [SceneGraphNode] { [] }
    public var childCount: Int { children.count }
    public var isLeaf: Bool { children.isEmpty }
    public var category: Int { SceneGraphCategory.foliageTile.rawValue }
    
    public var neighbours: [Cardinal : FoliageTile] = [:] {
        
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
    
    public var tileType: FoliageTileType = .bush {
        
        didSet {
            
            guard oldValue != tileType else { return }
            
            becomeDirty()
        }
    }
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        tileType = try container.decode(FoliageTileType.self, forKey: .tileType)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(tileType, forKey: .tileType)
    }
}

extension FoliageTile {
    
    public static func == (lhs: FoliageTile, rhs: FoliageTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension FoliageTile {
    
    func add(neighbour: FoliageTile, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> FoliageTile? {
        
        return neighbours[cardinal]
    }
    
    func find(neighbour ordinal: Ordinal) -> FoliageTile? {
        
        let (c0, c1) = ordinal.cardinals
        
        return find(neighbour: c0)?.find(neighbour: c1) ?? find(neighbour: c1)?.find(neighbour: c0)
    }
    
    func remove(neighbour cardinal: Cardinal) {
        
        guard let neighbour = neighbours[cardinal] else { return }
        
        neighbours.removeValue(forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != nil {
            
            neighbour.remove(neighbour: cardinal.opposite)
        }
    }
}

extension FoliageTile {
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension FoliageTile {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}

extension FoliageTile {
    
    var cornerHeights: [Int] { Array(repeating: coordinate.y, count: 4) }
    
    func render(position: Vector) -> [Polygon] {
        
        return []
    }
}

extension FoliageTile {
    
    var seed: Int { ((coordinate.x + 1) * (coordinate.y + 2) * (coordinate.z + 4)) * 8 }
}
