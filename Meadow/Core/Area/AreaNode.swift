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
            let adjacentEdgeType0 = a0?.find(edge: e1)
            let adjacentEdgeType1 = a1?.find(edge: e0)
            
            if let internalMeshProvider = internalAreaType?.meshProvider {
                
                if let adjacentEdgeType0 = adjacentEdgeType0, let adjacentEdgeType1 = adjacentEdgeType1, edgeType0 == nil && edgeType1 == nil {
                    
                    var colorPalettes = (adjacentEdgeType0.internalColorPalette, adjacentEdgeType1.internalColorPalette)
                    var architectureTypes = (adjacentEdgeType0.architectureType, adjacentEdgeType1.architectureType)
                    
                    if corner == .northEast || corner == .southWest {
                        
                        colorPalettes = (adjacentEdgeType1.internalColorPalette, adjacentEdgeType0.internalColorPalette)
                        architectureTypes = (adjacentEdgeType1.architectureType, adjacentEdgeType0.architectureType)
                    }
                    
                    meshFaces.append(contentsOf: internalMeshProvider.areaNode(corner: corner, polyhedron: meshPolyhedron, architectureTypes: architectureTypes, side: .interior, colorPalettes: colorPalettes))
                }
            }
            
            if let externalMeshProvider = externalAreaType?.meshProvider {
             
                if let edgeType0 = edgeType0, let edgeType1 = edgeType1, adjacentEdgeType0 == nil && adjacentEdgeType1 == nil && d == nil {
                    
                    let translation = (GridEdge.normal(edge: edgeType0.edge) + GridEdge.normal(edge: edgeType1.edge))
                    
                    let externalPolyhedron = Polyhedron.translate(polyhedron: meshPolyhedron, translation: translation)
                    
                    let oppositeCorner = GridCorner.opposite(corner: corner)
                    
                    let colorPalettes = (edgeType0.externalColorPalette, edgeType1.externalColorPalette)
                    
                    let architectureTypes = (edgeType0.architectureType, edgeType1.architectureType)
                    
                    meshFaces.append(contentsOf: externalMeshProvider.areaNode(corner: oppositeCorner, polyhedron: externalPolyhedron, architectureTypes: architectureTypes, side: .exterior, colorPalettes: colorPalettes))
                }
            }
        }
        
        GridEdge.Edges.forEach { edge in
            
            let neighbour = find(neighbour: edge)?.node as? AreaNode
            
            let (e0, e1) = GridEdge.edges(edge: edge)
            
            let (c0, c1) = GridCorner.corners(edge: edge)
            
            let a0 = find(neighbour: e0)?.node as? AreaNode
            let a1 = find(neighbour: e1)?.node as? AreaNode
            
            if let floorColor = floorColorPalette?.primary.vector {
                
                meshFaces.append(MeshProvider.surface(corners: (c0, c1), polytope: meshPolyhedron.lowerPolytope, color: floorColor))
            }
            
            if let nodeEdge = find(edge: edge) {
            
                if let internalMeshProvider = internalAreaType?.meshProvider {
                
                    meshFaces.append(contentsOf: internalMeshProvider.areaNode(edge: edge, polyhedron: meshPolyhedron, edgeType: nodeEdge.edgeType, architectureType: nodeEdge.architectureType, side: .interior, edges: edges, colorPalette: nodeEdge.internalColorPalette))
                    
                    let ne0 = find(edge: e0)
                    let ne1 = find(edge: e1)
                    
                    let connectedEdges = ((e0, a0, ne0), (e1, a1, ne1))
                    
                    [connectedEdges.0, connectedEdges.1].forEach { connectedEdge in
                        
                        let (e, a, ne) = (connectedEdge.0, connectedEdge.1, connectedEdge.2)
                        
                        if ne == nil && (a == nil || (a?.find(edge: edge) == nil || a?.find(edge: e) == nil)) {
                            
                            let (c2, c3) = GridCorner.corners(edge: e)
                            
                            let translation = GridEdge.normal(edge: e)
                            
                            let externalPolyhedron = Polyhedron.translate(polyhedron: meshPolyhedron, translation: translation)
                            
                            let c = (c0 != c2 && c0 != c3 ? c0 : c1)
                            
                            let colorPalettes = (nodeEdge.internalColorPalette, nodeEdge.internalColorPalette)
                            
                            let architectureTypes = (nodeEdge.architectureType, nodeEdge.architectureType)
                            
                            meshFaces.append(contentsOf: internalMeshProvider.areaNode(corner: c, polyhedron: externalPolyhedron, architectureTypes: architectureTypes, side: .interior, colorPalettes: colorPalettes))
                        }
                    }
                }
            
                if let externalMeshProvider = externalAreaType?.meshProvider {
                
                    if neighbour?.find(edge: GridEdge.opposite(edge: edge)) == nil {
                    
                        let normal = GridEdge.normal(edge: edge)
                        
                        let externalPolyhedron = Polyhedron.invert(polyhedron: Polyhedron.translate(polyhedron: meshPolyhedron, translation: normal), edge: edge)
                        
                        let d0 = a0?.find(neighbour: edge)?.node as? AreaNode
                        let d1 = a1?.find(neighbour: edge)?.node as? AreaNode
                        
                        let ne0 = d0?.find(edge: e1)
                        let ne1 = d1?.find(edge: e0)
                        
                        var externalEdges = AreaNode.Edges()
                        
                        switch edge {
                            
                        case .north,
                             .south:
                            
                            externalEdges.east = (e0 == .east ? ne0 : ne1)
                            externalEdges.west = (e1 == .west ? ne1 : ne0)
                            
                        case .east,
                             .west:
                        
                            externalEdges.north = (e0 == .north ? ne0 : ne1)
                            externalEdges.south = (e1 == .south ? ne1 : ne0)
                        }
                        
                        meshFaces.append(contentsOf: externalMeshProvider.areaNode(edge: edge, polyhedron: externalPolyhedron, edgeType: nodeEdge.edgeType, architectureType: nodeEdge.architectureType, side: .exterior, edges: externalEdges, colorPalette: nodeEdge.externalColorPalette))
                    }
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
    
    static let surface: MDWFloat = 0.01
    
    static let areaHeight: Int = 5
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: areaHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
