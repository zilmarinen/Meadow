//
//  BrickAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class BrickAreaNodeMeshProvider: AreaMeshProvider {
    
    func areaNode(corner: GridCorner, polyhedron: Polyhedron, side: Plane.Side, colorPalettes: (ColorPalette, ColorPalette)) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (cp0, cp1) = (colorPalettes.0, colorPalettes.1)
        
        let wallInset = (side == .exterior ? AreaNode.externalWallDepth : AreaNode.internalWallDepth)
        
        let oppositeCorner = GridCorner.opposite(corner: corner)
        
        let (e0, e1) = GridEdge.edges(corner: oppositeCorner)
        
        let (ec0, ec1) = GridCorner.corners(edge: e0)
        let (ec2, ec3) = GridCorner.corners(edge: e1)
        
        let c0 = (ec0 != oppositeCorner ? ec0 : ec1)
        let c1 = (ec2 != oppositeCorner ? ec2 : ec3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        var insetPolyhedron = polyhedron
        
        [e0, e1].forEach { edge in
            
            insetPolyhedron = Polyhedron.inset(polyhedron: insetPolyhedron, edge: edge, inset: (1 - wallInset))
        }
        
        let v0 = insetPolyhedron.upperPolytope.vertices[corner.rawValue]
        let v1 = insetPolyhedron.upperPolytope.vertices[c0.rawValue]
        let v2 = insetPolyhedron.upperPolytope.vertices[oppositeCorner.rawValue]
        let v3 = insetPolyhedron.upperPolytope.vertices[c1.rawValue]
        
        let v4 = insetPolyhedron.lowerPolytope.vertices[c0.rawValue]
        let v5 = insetPolyhedron.lowerPolytope.vertices[oppositeCorner.rawValue]
        let v6 = insetPolyhedron.lowerPolytope.vertices[c1.rawValue]
        
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: cp0.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: cp1.tertiary.vector))
        
        meshFaces.append(MeshFace(v0: v1, v1: v2, v2: v4, projectedNormal: n0, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v4, v2: v5, projectedNormal: n0, color: cp0.primary.vector))
        
        meshFaces.append(MeshFace(v0: v2, v1: v3, v2: v5, projectedNormal: n1, color: cp1.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: v5, v2: v6, projectedNormal: n1, color: cp1.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(door edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(wall edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let wallInset = (side == .exterior ? AreaNode.externalWallDepth : AreaNode.internalWallDepth)
        
        var insetPolyhedron = Polyhedron.inset(polyhedron: polyhedron, edge: edge, inset: wallInset)
        
        let (e0, e1) = GridEdge.edges(edge: edge)
        
        [e0, e1].forEach { connectedEdge in
            
            if edges.find(edge: connectedEdge)?.edgeType != nil {
                
                insetPolyhedron = Polyhedron.inset(polyhedron: insetPolyhedron, edge: connectedEdge, inset: wallInset)
            }
        }
        
        let (c0, c1) = GridCorner.corners(edge: edge)
        
        let v0 = polyhedron.upperPolytope.vertices[c0.rawValue]
        let v1 = polyhedron.upperPolytope.vertices[c1.rawValue]
        let v2 = insetPolyhedron.upperPolytope.vertices[c1.rawValue]
        let v3 = insetPolyhedron.upperPolytope.vertices[c0.rawValue]
        
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: colorPalette.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: colorPalette.tertiary.vector))
        
        meshFaces.append(contentsOf: MeshProvider.edge(corners: (c0, c1), polyhedron: insetPolyhedron, normal: normal, color: colorPalette.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(window edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
}
