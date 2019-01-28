//
//  AreaNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class AreaNode: GridNode {
    
    var edges = Edges()
    
    public var internalAreaType: AreaType? {
        
        didSet {
            
            if internalAreaType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var externalAreaType: AreaType? {
        
        didSet {
            
            if externalAreaType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var floorColorPalette: ColorPalette? {
        
        didSet {
            
            if floorColorPalette != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case name
        case edges
        case externalAreaType
        case internalAreaType
        case floorColorPalette
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.edges, forKey: .edges)
        try container.encode(self.externalAreaType, forKey: .externalAreaType)
        try container.encode(self.internalAreaType, forKey: .internalAreaType)
        try container.encode(self.floorColorPalette?.name, forKey: .floorColorPalette)
    }
    
    public override var mesh: Mesh {
        
        return Mesh(faces: [])
    }
}

extension AreaNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let y = (volume.coordinate.y + volume.size.height)
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: y, y1: y, y2: y, y3: y, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        let y = volume.coordinate.y
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: y, y1: y, y2: y, y3: y, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension AreaNode {
    
    public func find(edge: GridEdge) -> Edge? {
        
        switch edge {
            
        case .north: return edges.north
        case .east: return edges.east
        case .south: return edges.south
        case .west: return edges.west
        }
    }
    
    public func set(edge: Edge) {
        
        switch edge.edge {
            
        case .north: edges.north = edge
        case .east: edges.east = edge
        case .south: edges.south = edge
        case .west: edges.west = edge
        }
        
        becomeDirty()
        
        if let neighbour = find(neighbour: edge.edge)?.node as? AreaNode {
            
            let oppositeEdge = GridEdge.opposite(edge: edge.edge)
            
            let neighbourEdge = neighbour.find(edge: oppositeEdge)
            
            if neighbourEdge?.edgeType == edge.edgeType {
                
                return
            }
            
            let architectureType = (neighbourEdge?.architectureType ?? edge.architectureType)
            let externalColorPalette = (neighbourEdge?.externalColorPalette ?? edge.externalColorPalette)
            let internalColorPalette = (neighbourEdge?.internalColorPalette ?? edge.internalColorPalette)
            
            neighbour.set(edge: Edge(edge: oppositeEdge, edgeType: edge.edgeType, architectureType: architectureType, externalColorPalette: externalColorPalette, internalColorPalette: internalColorPalette))
        }
    }
    
    public func remove(edge: GridEdge) {
        
        switch edge {
        case .north: edges.north = nil
        case .east: edges.east = nil
        case .south: edges.south = nil
        case .west: edges.west = nil
        }
        
        becomeDirty()
    }
    
    public func anyEdge() -> Edge? {
        
        return edges.any
    }
}

extension AreaNode {
    
    static let externalWallDepth: MDWFloat = 0.042
    static let internalWallDepth: MDWFloat = 0.013
    
    public static let surface: MDWFloat = 0.01
    
    public static let areaHeight: Int = 5
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
