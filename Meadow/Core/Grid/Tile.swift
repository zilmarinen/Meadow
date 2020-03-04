//
//  Tile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class Tile: Soilable, Clearable, Encodable, Neighbour, Renderable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case name
        case coordinate
    }
    
    internal weak var ancestor: SoilableParent?
    
    internal var isDirty = false
    
    var isHidden: Bool = false
    
    var name: String?
    
    var mesh: Mesh?
    
    let volume: Volume
    
    var neighbours: [Cardinal : Tile] = [:]
    
    required init(ancestor: SoilableParent, coordinate: Coordinate) {
    
        self.ancestor = ancestor
        
        self.volume = World.Axis.aligned(tile: coordinate)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(name, forKey: .name)
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
}

extension Tile: Equatable {
    
    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension Tile: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(volume)
    }
}
