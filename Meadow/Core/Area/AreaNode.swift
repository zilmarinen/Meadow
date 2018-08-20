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
        
        GridCorner.Corners.forEach { corner in
            
            let (e0, e1) = GridEdge.edges(corner: corner)
            
            let a0 = find(neighbour: e0)?.node as? AreaNode
            let a1 = find(neighbour: e1)?.node as? AreaNode
            
            let d = (a0?.find(neighbour: e1)?.node as? AreaNode ?? a1?.find(neighbour: e0)?.node as? AreaNode)
            
            let edgeType0 = find(edge: e0)
            let edgeType1 = find(edge: e1)
            let edgeType2 = a0?.find(edge: e1)
            let edgeType3 = a1?.find(edge: e0)
            
            if let internalMeshProvider = internalAreaType?.meshProvider {
                
                if let edgeType2 = edgeType2, let edgeType3 = edgeType3, edgeType0 == nil && edgeType1 == nil {
                    
                    let colorPalette = (corner == .northEast || corner == .southWest ? (edgeType3.internalColorPalette, edgeType2.internalColorPalette) : (edgeType2.internalColorPalette, edgeType3.internalColorPalette))
                    
                    meshFaces.append(contentsOf: internalMeshProvider.areaNode(corner: corner, polyhedron: meshPolyhedron, side: .interior, colorPalettes: colorPalette))
                }
            }
            
            if let externalMeshProvider = externalAreaType?.meshProvider {
             
                if let edgeType0 = edgeType0, let edgeType1 = edgeType1, edgeType2 == nil && edgeType3 == nil && d == nil {
                    
                    let translation = (GridEdge.normal(edge: edgeType0.edge) + GridEdge.normal(edge: edgeType1.edge))
                    
                    let externalPolyhedron = Polyhedron.translate(polyhedron: meshPolyhedron, translation: translation)
                    
                    let oppositeCorner = GridCorner.opposite(corner: corner)
                    
                    meshFaces.append(contentsOf: externalMeshProvider.areaNode(corner: oppositeCorner, polyhedron: externalPolyhedron, side: .exterior, colorPalettes: (edgeType0.externalColorPalette, edgeType1.externalColorPalette)))
                }
            }
        }
        
        GridEdge.Edges.forEach { edge in
            
            let neighbour = find(neighbour: edge)?.node as? AreaNode
            
            let nodeEdge = find(edge: edge)
            
            if let internalMeshProvider = internalAreaType?.meshProvider {
                
                if let floorColor = floorColorPalette?.primary.vector {
                    
                    let corners = GridCorner.corners(edge: edge)
                    
                    meshFaces.append(MeshProvider.surface(corners: corners, polytope: meshPolyhedron.lowerPolytope, color: floorColor))
                }
                
                if let nodeEdge = nodeEdge {
                    
                    let oppositeEdge = GridEdge.opposite(edge: edge)
                    
                    let normal = GridEdge.normal(edge: oppositeEdge)
                    
                    meshFaces.append(contentsOf: internalMeshProvider.areaNode(edge: edge, polyhedron: meshPolyhedron, edgeType: nodeEdge.edgeType, side: .interior, edges: edges, normal: normal, colorPalette: nodeEdge.internalColorPalette))
                }
            }
            
            if let externalMeshProvider = externalAreaType?.meshProvider {
                
                if let nodeEdge = nodeEdge, neighbour?.find(edge: GridEdge.opposite(edge: edge)) == nil {
                    
                    let normal = GridEdge.normal(edge: edge)
                    
                    let externalPolyhedron = Polyhedron.invert(polyhedron: Polyhedron.translate(polyhedron: meshPolyhedron, translation: normal), edge: edge)
                    
                    let (e0, e1) = GridEdge.edges(edge: edge)
                    
                    let a0 = find(neighbour: e0)?.node as? AreaNode
                    let a1 = find(neighbour: e1)?.node as? AreaNode
                    
                    let d0 = a0?.find(neighbour: edge)?.node as? AreaNode
                    let d1 = a1?.find(neighbour: edge)?.node as? AreaNode
                    
                    let edgeType0 = d0?.find(edge: e1)
                    let edgeType1 = d1?.find(edge: e0)
                    
                    var externalEdges = AreaNode.Edges()
                    
                    switch edge {
                        
                    case .north,
                         .south:
                        
                        externalEdges.east = (e0 == .east ? edgeType0 : edgeType1)
                        externalEdges.west = (e1 == .west ? edgeType1 : edgeType0)
                        
                    case .east,
                         .west:
                    
                        externalEdges.north = (e0 == .north ? edgeType0 : edgeType1)
                        externalEdges.south = (e1 == .south ? edgeType1 : edgeType0)
                    }
                    
                    meshFaces.append(contentsOf: externalMeshProvider.areaNode(edge: edge, polyhedron: externalPolyhedron, edgeType: nodeEdge.edgeType, side: .exterior, edges: externalEdges, normal: normal, colorPalette: nodeEdge.externalColorPalette))
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
    
    static let externalWallDepth: MDWFloat = 0.075
    static let internalWallDepth: MDWFloat = 0.025
    
    static let skirtingDepth: MDWFloat = 0.1
    static let skirtingHeight: MDWFloat = 0.1
    
    static let surface: MDWFloat = 0.01
    
    static let lintelHeight: MDWFloat = 5
    static let windowsillHeight: MDWFloat = 3
    
    static let areaHeight: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
