//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainLayer: GridChild {
    
    public var observer: GridObserver?
    
    public var name: String? { return "" }
    
    public var volume: Volume
    
    var isDirty: Bool = true
    
    var hierarchy = Hierarchy()
    
    init(observer: GridObserver, volume: Volume) {
        
        self.observer = observer
        
        self.volume = volume
    }
}

extension TerrainLayer: GridSoilable {
    
    public func becomeDirty() {
        
        if !isDirty {
            
            isDirty = true
            
            observer?.child(didBecomeDirty: self)
        }
    }
    
    public func clean() {
        
        if !isDirty { return }
        
        //
        
        isDirty = false
    }
}

extension TerrainLayer: GridMeshProvider {
    
    public var mesh: Mesh { return Mesh(faces: []) }
}

extension TerrainLayer: GridPolyhedronProvider {
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: Polytope(x: 0, y: 0, z: 0), lowerPolytope: Polytope(x: 0, y: 0, z: 0)) }
}

extension TerrainLayer {
    
    func get(height corner: GridCorner) -> Int {
        
        return 0
    }
    
    func set(height: Int, corner: GridCorner) {
        
    }
}

extension TerrainLayer: Hashable {
    
    public var hashValue: Int { return volume.hashValue }
    
    public static func == (lhs: TerrainLayer, rhs: TerrainLayer) -> Bool {
        
        return lhs.volume == rhs.volume
    }
}

extension TerrainLayer: Encodable {
    
    enum CodingKeys: CodingKey {
        
        case name
        case volume
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.volume, forKey: .volume)
    }
}
