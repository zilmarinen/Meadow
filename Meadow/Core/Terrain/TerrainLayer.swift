//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainLayer: GridChild {
    
    public var observer: GridObserver?
    
    public var name: String?
    
    public var volume: Volume {
        
        let base = Axis.Y(y: polyhedron.lowerPolytope.base)
        let peak = Axis.Y(y: polyhedron.upperPolytope.peak)
        
        return Volume(coordinate: Coordinate(x: coordinate.x, y: base, z: coordinate.z), size: Size(width: 1, height: (peak - base), depth: 1))
    }
    
    var isDirty: Bool = true
    
    let coordinate: Coordinate
    
    var corners: [Int]
    
    var hierarchy = Hierarchy()
    
    public required init?(observer: GridObserver, coordinate: Coordinate, corners: [Int]) {
        
        guard corners.count == 4 else { return nil }
        
        self.observer = observer
        
        self.coordinate = coordinate
        
        self.corners = corners
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
    
    var upperPolytope: Polytope {
        
        return Polytope(x: MDWFloat(coordinate.x), y: corners, z: MDWFloat(coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        if let lowerLayer = hierarchy.lower {
            
            return lowerLayer.polyhedron.upperPolytope
        }
        
        return Polytope(x: MDWFloat(coordinate.x), y: [World.Floor, World.Floor, World.Floor, World.Floor], z: MDWFloat(coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainLayer {
    
    func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
    
    func set(height: Int, corner: GridCorner) {
        
        var cornerHeight = min(max(height, World.Floor + 1), World.Ceiling)
        
        if let upperLayer = hierarchy.upper {
            
            cornerHeight = min(cornerHeight, upperLayer.get(height: corner))
        }
        
        if let lowerLayer = hierarchy.lower {
            
            cornerHeight = max(cornerHeight, lowerLayer.get(height: corner))
        }
        
        if get(height: corner) != cornerHeight {
            
            let clamp = 1
            
            GridCorner.Corners(corner: corner).forEach { connectedCorner in
             
                let delta = get(height: connectedCorner) - cornerHeight
                
                if abs(delta) > clamp {
                    
                    let connectedCornerHeight = cornerHeight + (delta <= -clamp ? -clamp : (delta >= clamp ? clamp : delta))
                    
                    set(height: connectedCornerHeight, corner: connectedCorner)
                }
            }
            
            corners[corner.rawValue] = cornerHeight
            
            becomeDirty()
        }
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
