//
//  Tile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Foundation

class Tile: Soilable, Clearable, Encodable, Neighbour, Renderable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case coordinate
    }
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    var isHidden: Bool = false
    
    var name: String?
    
    let volume: Volume
    
    var neighbours: [Cardinal : Tile] = [:]
    
    required init(ancestor: SoilableParent, coordinate: Coordinate) {
    
        self.ancestor = ancestor
        
        self.volume = World.Axis.aligned(tile: coordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(volume.coordinate, forKey: .coordinate)
    }
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        isDirty = false
        
        return true
    }
    
    func clear() {
        
        Cardinal.allCases.forEach { cardinal in
            
            remove(neighbour: cardinal)
        }
    }
    
    func update(delta: TimeInterval, time: TimeInterval) {}
}

extension Tile: Equatable {
    
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension Tile: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(volume)
    }
}
