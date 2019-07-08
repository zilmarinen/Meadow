//
//  FootpathNode.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class FootpathNode: GridNode {
    
    public var slope: Slope? {
        
        didSet {
            
            if slope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    public var footpathType: FootpathType? {
        
        didSet {
            
            if footpathType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case slope
        case footpathType
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(self.slope, forKey: .slope)
        try container.encode(self.footpathType, forKey: .footpathType)
    }
    
    public override var mesh: Mesh {
        
        guard let colorPalette = footpathType?.colorPalette else { return Mesh(faces: []) }
        
        var faces: [MeshFace] = []
        
        var innerPolyhedron = polyhedron
        
        GridEdge.Edges.forEach { edge in
            
            innerPolyhedron = Polyhedron.inset(polyhedron: innerPolyhedron, edge: edge, inset: FootpathNode.kerb)
        }
        
        let surfacePolytope = Polytope.translate(polytope: innerPolyhedron.lowerPolytope, translation: SCNVector3(x: 0.0, y: FootpathNode.surface, z: 0.0))
        
        faces.append(contentsOf: MeshFace.quad(vertices: surfacePolytope.vertices, projectedNormal: SCNVector3.Up, color: colorPalette.primary.vector))
        
        GridEdge.Edges.forEach { edge in
         
            if find(neighbour: edge) != nil {
                
                let edges = GridEdge.edges(edge: edge)
                
                var polytope = lowerPolytope
                
                [edges.e0, edges.e1].forEach { connectedEdge in
                    
                    let neighbour = find(neighbour: connectedEdge)?.node as? FootpathNode
                    
                    let diagonal = neighbour?.find(neighbour: edge)
                 
                    if neighbour == nil || diagonal == nil {
                        
                        polytope = Polytope.inset(polytope: polytope, edge: connectedEdge, inset: FootpathNode.kerb)
                    }
                }
                
                let corners = GridCorner.corners(edge: edge)
                
                let edgePolytope = Polytope(v0: polytope.vertices[corners.c0.rawValue], v1: polytope.vertices[corners.c1.rawValue], v2: innerPolyhedron.lowerPolytope.vertices[corners.c1.rawValue], v3: innerPolyhedron.lowerPolytope.vertices[corners.c0.rawValue])
                
                let surfacePolytope = Polytope.translate(polytope: edgePolytope, translation: SCNVector3(x: 0.0, y: FootpathNode.surface, z: 0.0))
                
                faces.append(contentsOf: MeshFace.quad(vertices: surfacePolytope.vertices, projectedNormal: SCNVector3.Up, color: colorPalette.primary.vector))
            }
        }
        
        return Mesh(faces: faces)
    }
}

extension FootpathNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let (c0, c1, c2, c3) = (corners[0], corners[1], corners[2], corners[3])
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: c0 + volume.size.height, y1: c1 + volume.size.height, y2: c2 + volume.size.height, y3: c3 + volume.size.height, z: MDWFloat(volume.coordinate.z))
    }
    
    var lowerPolytope: Polytope {
        
        let (c0, c1, c2, c3) = (corners[0], corners[1], corners[2], corners[3])
        
        return Polytope(x: MDWFloat(volume.coordinate.x), y0: c0, y1: c1, y2: c2, y3: c3, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}

extension FootpathNode {
    
    var corners: [Int] {
        
        let y = volume.coordinate.y
        
        var heights = [y, y, y, y]
        
        if let slope = slope {
        
            let (c0, c1) = GridCorner.corners(edge: slope.edge)
        
            heights[c0.rawValue] += (slope.steep ? 2 : 1)
            heights[c1.rawValue] += (slope.steep ? 2 : 1)
        }
        
        return heights
    }
}

extension FootpathNode: Walkable {
 
    public func pathNode(for edge: GridEdge) -> PathNode? {
        
        let movementCost = footpathType?.movementCost ?? 0
        
        return PathNode(locus: (coordinate: volume.coordinate, edge: edge), position: self.lowerPolytope.centroid(for: edge), movementCost: movementCost)
    }
    
    public func neighbours(for edge: GridEdge) -> [PathNode]? {
        
        let movementCost = footpathType?.movementCost ?? 0
        
        var pathNodes: [PathNode] = []
        
        GridEdge.inverse(edge: edge).forEach { inverseEdge in
            
            pathNodes.append(PathNode(locus: (coordinate: volume.coordinate, edge: inverseEdge), position: self.lowerPolytope.centroid(for: inverseEdge), movementCost: movementCost))
        }
        
        if let nodeNeighbour = find(neighbour: edge)?.node as? FootpathNode {
            
            let oppositeEdge = GridEdge.opposite(edge: edge)
            
            pathNodes.append(PathNode(locus: (coordinate: nodeNeighbour.volume.coordinate, edge: oppositeEdge), position: nodeNeighbour.lowerPolytope.centroid(for: oppositeEdge), movementCost: movementCost))
        }
        
        return !pathNodes.isEmpty ? pathNodes : nil
    }
}

extension FootpathNode {
    
    static let kerb: MDWFloat = 0.1
    static let surface: MDWFloat = 0.01
    
    static let footpathHeight: Int = 8
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: footpathHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
