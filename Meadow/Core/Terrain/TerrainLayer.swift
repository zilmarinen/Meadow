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
    
    public var isHidden: Bool = false {
        
        didSet {
            
            if isHidden != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var volume: Volume {
        
        return polyhedron.volume
    }
    
    var edges: Edges
    
    var isDirty: Bool = false
    
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
        
        let (c0, c1, c2, c3) = (corners[0], corners[1], corners[2], corners[3])
        
        return Polytope(x: MDWFloat(coordinate.x), y0: c0, y1: c1, y2: c2, y3: c3, z: MDWFloat(coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        if let lowerLayer = hierarchy.lower {
            
            return lowerLayer.polyhedron.upperPolytope
        }
        
        let y = World.floor
        
        return Polytope(x: MDWFloat(coordinate.x), y0: y, y1: y, y2: y, y3: y, z: MDWFloat(coordinate.z))
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
    
    public func set(height: Int) {
        
        set(height: height, corner: .northWest)
        set(height: height, corner: .northEast)
        set(height: height, corner: .southEast)
        set(height: height, corner: .southWest)
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
    
    public func set(terrainType: TerrainType) {
        
        set(terrainType: terrainType, edge: .north)
        set(terrainType: terrainType, edge: .east)
        set(terrainType: terrainType, edge: .south)
        set(terrainType: terrainType, edge: .west)
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
