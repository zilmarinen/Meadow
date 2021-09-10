//
//  Tile.swift
//
//  Created by Zack Brown on 25/03/2021.
//

import Euclid
import SceneKit

public class Tile: Codable, Equatable, Responder {
    
    private enum CodingKeys: String, CodingKey {
        
        case coordinate = "c"
    }
    
    public var ancestor: SoilableParent?
    
    public var isDirty: Bool = true
    
    public var category: SceneGraphCategory { .surfaceTile }

    private(set) public var coordinate: Coordinate
    
    public var isHidden: Bool = false
    
    var offset: Coordinate = .zero {
        
        didSet {
            
            if oldValue != offset {
                
                coordinate = (coordinate - oldValue) + offset
            }
        }
    }

    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
    
    @discardableResult public func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        isDirty = false
        
        return true
    }
}

extension Tile {
    
    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}
