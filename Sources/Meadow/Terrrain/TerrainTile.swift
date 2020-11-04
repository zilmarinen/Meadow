//
//  TerrainTile.swift
//
//  Created by Zack Brown on 02/11/2020.
//

import Foundation

class TerrainTile: Codable, Equatable, SceneGraphNode, Soilable, Updatable {
    
    private enum CodingKeys: CodingKey {
        
        case coordinate
    }
    
    var ancestor: SoilableParent? { return chunk }
    
    var isDirty: Bool = false
    
    weak var chunk: TerrainChunk?
    var coordinate: Coordinate
    
    var name: String? { return "Tile \(coordinate.description)" }
    
    var children: [SceneGraphNode] { [] }
    var childCount: Int { 0 }
    var isLeaf: Bool = true
    
    var neighbours: [Cardinal : TerrainTile] = [:]
    
    init(coordinate: Coordinate) {
        
        self.coordinate = coordinate
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        coordinate = try container.decode(Coordinate.self, forKey: .coordinate)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(coordinate, forKey: .coordinate)
    }
}

extension TerrainTile {
    
    static func == (lhs: TerrainTile, rhs: TerrainTile) -> Bool {
        
        return lhs.coordinate == rhs.coordinate
    }
}

extension TerrainTile {
    
    func add(neighbour: TerrainTile, cardinal: Cardinal) {
        
        remove(neighbour: cardinal)
        
        neighbours.updateValue(neighbour, forKey: cardinal)
        
        becomeDirty()
        
        if neighbour.neighbours[cardinal.opposite] != self {
            
            neighbour.add(neighbour: self, cardinal: cardinal.opposite)
        }
    }
    
    func find(neighbour cardinal: Cardinal) -> TerrainTile? {
        
        return neighbours[cardinal]
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

extension TerrainTile {
    
    @discardableResult func clean() -> Bool {
        
        guard isDirty else { return false }
        
        //
        
        return true
    }
}

extension TerrainTile {
    
    func update(delta: TimeInterval, time: TimeInterval) {
        
        //
    }
}
