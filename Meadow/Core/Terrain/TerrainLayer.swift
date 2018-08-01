//
//  TerrainLayer.swift
//  Meadow
//
//  Created by Zack Brown on 05/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class TerrainLayer: GridChild {
    
    public var observer: GridObserver?
    
    public var name: String? { return "Layer" }
    
    public var isHidden: Bool = false
    
    public var volume: Volume {
        
        let base = Axis.Y(y: polyhedron.lowerPolytope.base)
        let peak = Axis.Y(y: polyhedron.upperPolytope.peak)
        
        return Volume(coordinate: Coordinate(x: coordinate.x, y: base, z: coordinate.z), size: Size(width: 1, height: (peak - base), depth: 1))
    }
    
    var edges: Edges
    
    var isDirty: Bool = true
    
    let coordinate: Coordinate
    
    var corners: [Int]
    
    public var hierarchy = Hierarchy()
    
    public required init?(observer: GridObserver, coordinate: Coordinate, corners: [Int], terrainType: TerrainType) {
        
        guard corners.count == 4 else { return nil }
        
        self.observer = observer
        
        self.coordinate = coordinate
        
        self.corners = corners
        
        self.edges = Edges(terrainType: terrainType)
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

extension TerrainLayer: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        return Polytope(x: MDWFloat(coordinate.x), corners: corners, z: MDWFloat(coordinate.z))!
    }
    
    var lowerPolytope: Polytope {
        
        if let lowerLayer = hierarchy.lower {
            
            return lowerLayer.polyhedron.upperPolytope
        }
        
        return Polytope(x: MDWFloat(coordinate.x), corners: [World.floor, World.floor, World.floor, World.floor], z: MDWFloat(coordinate.z))!
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension TerrainLayer {
    
    public func get(height corner: GridCorner) -> Int {
        
        return corners[corner.rawValue]
    }
    
    public func set(height: Int, corner: GridCorner) {
        
        var cornerHeight = min(max(height, World.floor + 1), World.ceiling)
        
        if let upperLayer = hierarchy.upper {
            
            cornerHeight = min(cornerHeight, upperLayer.get(height: corner))
        }
        
        if let lowerLayer = hierarchy.lower {
            
            cornerHeight = max(cornerHeight, lowerLayer.get(height: corner))
        }
        
        if get(height: corner) != cornerHeight {
            
            let clamp = 1
            
            GridCorner.corners(corner: corner).forEach { connectedCorner in
             
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

extension TerrainLayer {
    
    public func get(terrainType edge: GridEdge) -> TerrainType {
        
        switch edge {
            
        case .north: return edges.north.terrainType
        case .east: return edges.east.terrainType
        case .south: return edges.south.terrainType
        case .west: return edges.west.terrainType
        }
    }
    
    public func set(terrainType: TerrainType, edge: GridEdge) {
        
        let terrainEdge = Edge(edge: edge, terrainType: terrainType)
        
        switch edge {
            
        case .north: edges.north = terrainEdge
        case .east: edges.east = terrainEdge
        case .south: edges.south = terrainEdge
        case .west: edges.west = terrainEdge
        }
        
        becomeDirty()
    }
}

extension TerrainLayer {
    
    public static let crown: MDWFloat = (Axis.unitY / 2.0)
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
        case corners
        case edges
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.corners, forKey: .corners)
        try container.encode(self.edges, forKey: .edges)
    }
}
