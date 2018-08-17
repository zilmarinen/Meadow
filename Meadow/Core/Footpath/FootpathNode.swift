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
        
        guard let footpathType = footpathType else { return Mesh(faces: []) }
        
        var meshFaces: [MeshFace] = []
        
        let meshPolytope = Polytope.offset(polytope: lowerPolytope, y: FootpathNode.surface)
        
        var insetPolytope = meshPolytope
        
        GridEdge.Edges.forEach { edge in
            
            insetPolytope = Polytope.inset(polytope: insetPolytope, edge: edge, inset: FootpathNode.kerb)
        }
        
        GridEdge.Edges.forEach { edge in
            
            let corners = GridCorner.corners(edge: edge)
            
            let (c0, c1) = (corners.first!, corners.last!)
            
            let d0 = GridCorner.opposite(corner: c0)
            let d1 = GridCorner.opposite(corner: c1)
            
            let surfaceColor = footpathType.colorPalette?.primary.vector ?? SCNVector4Zero
            
            meshFaces.append(MeshProvider.surface(corners: corners, polytope: insetPolytope, color: surfaceColor))
            
            if let neighbour = find(neighbour: edge)?.node as? FootpathNode {
                
                let y0 = self.corners[c0.rawValue]
                let y1 = self.corners[c1.rawValue]
                let y2 = neighbour.corners[d0.rawValue]
                let y3 = neighbour.corners[d1.rawValue]
                
                if y0 == y3 && y1 == y2 {
                    
                    let v0 = meshPolytope.vertices[c0.rawValue]
                    let v1 = meshPolytope.vertices[c1.rawValue]
                    let v2 = insetPolytope.vertices[c1.rawValue]
                    let v3 = insetPolytope.vertices[c0.rawValue]
                    var v4 = v0
                    var v5 = v1
                    
                    let e0 = GridEdge.edges(corner: c0).first { $0 != edge }!
                    let e1 = GridEdge.edges(corner: c1).first { $0 != edge }!
                    
                    let a0 = find(neighbour: e0)?.node as? FootpathNode
                    let a1 = find(neighbour: e1)?.node as? FootpathNode
                    
                    let d0 = neighbour.find(neighbour: e0)?.node as? FootpathNode
                    let d1 = neighbour.find(neighbour: e1)?.node as? FootpathNode
                    
                    if a0 == nil || (a0 != nil && d0 == nil) {
                        
                        v4 = SCNVector3.lerp(from: v0, to: v1, factor: FootpathNode.kerb)
                    }
                    
                    if a1 == nil || (a1 != nil && d1 == nil) {
                        
                        v5 = SCNVector3.lerp(from: v1, to: v0, factor: FootpathNode.kerb)
                    }
                    
                    meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v2, projectedNormal: SCNVector3.Up, color: surfaceColor))
                    meshFaces.append(MeshFace(v0: v4, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: surfaceColor))
                }
            }
        }
        
        return Mesh(faces: meshFaces)
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
        
            let edgeCorners = GridCorner.corners(edge: slope.edge)
        
            let (c0, c1) = (edgeCorners.first!, edgeCorners.last!)
        
            heights[c0.rawValue] += (slope.steep ? 2 : 1)
            heights[c1.rawValue] += (slope.steep ? 2 : 1)
        }
        
        return heights
    }
}

extension FootpathNode {
    
    static let kerb: MDWFloat = 0.1
    static let surface: MDWFloat = 0.01
    
    static let footpathHeight: Int = 6
    
    static func fixedVolume(_ coordinate: Coordinate) -> Volume {
        
        let size = Size(width: World.tileSize, height: footpathHeight, depth: World.tileSize)
        
        return Volume(coordinate: coordinate, size: size)
    }
}
