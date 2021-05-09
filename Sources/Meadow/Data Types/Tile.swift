//
//  Tile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import SceneKit

public class Tile: Codable, Equatable, Renderable, Responder {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
        case pattern = "p"
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = false
    
    public var category: Int { SceneGraphCategory.surfaceTile.rawValue }

    private(set) public var coordinate: Coordinate {
        
        didSet {
            
            if oldValue != coordinate {
            
                becomeDirty()
            }
        }
    }
    
    let pattern: Int
    
    public var isHidden: Bool = false {
        
        didSet {
            
            guard oldValue != isHidden else { return }
            
            becomeDirty()
        }
    }
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                coordinate += offset
                
                becomeDirty()
            }
        }
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
        pattern = try container.decode(Int.self, forKey: .pattern)
        
        becomeDirty()
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
        try container.encode(pattern, forKey: .pattern)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
    
    func render(position: Vector) -> [Polygon] { return [] }
}

extension Tile {
    
    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate && lhs.pattern == rhs.pattern
    }
}
