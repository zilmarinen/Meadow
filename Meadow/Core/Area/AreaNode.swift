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
        
        var meshFaces: [MeshFace] = []
        
        let meshPolyhedron = Polyhedron(upperPolytope: upperPolytope, lowerPolytope: Polytope.offset(polytope: lowerPolytope, y: AreaNode.surface))
        
        GridEdge.Edges.forEach { edge in
            
            let corners = GridCorner.corners(edge: edge)
            
            let edgeNormal = GridEdge.normal(edge: edge)
            let antiNormal = SCNVector3.negate(vector: edgeNormal)
            
            let neighbour = find(neighbour: edge)?.node as? AreaNode
            
            let nodeEdge = find(edge: edge)
            
            if let internalMeshProvider = internalAreaType?.meshProvider {
                
                if let floorColor = floorColorPalette?.primary.vector {
                    
                    meshFaces.append(MeshProvider.surface(corners: corners, polytope: meshPolyhedron.lowerPolytope, color: floorColor))
                }
                
                if let nodeEdge = nodeEdge {
                    
                    meshFaces.append(contentsOf: internalMeshProvider.areaNode(edge: corners, edgeType: nodeEdge.edgeType, polyhedron: meshPolyhedron, side: .interior, normal: antiNormal, colorPalette: nodeEdge.internalColorPalette))
                }
            }
            
            if let externalMeshProvider = externalAreaType?.meshProvider {
                
                if let nodeEdge = nodeEdge, neighbour?.find(edge: GridEdge.opposite(edge: edge)) == nil {
                    
                    meshFaces.append(contentsOf: externalMeshProvider.areaNode(edge: corners, edgeType: nodeEdge.edgeType, polyhedron: meshPolyhedron, side: .exterior, normal: edgeNormal, colorPalette: nodeEdge.externalColorPalette))
                }
            }
        }
        
        return Mesh(faces: meshFaces)
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
}

extension AreaNode {
    
    static let surface: MDWFloat = 0.01
    
    static let areaHeight: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
