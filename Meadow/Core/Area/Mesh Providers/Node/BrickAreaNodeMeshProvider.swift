//
//  BrickAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class BrickAreaNodeMeshProvider: AreaNodeMeshProvider {
 
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets, transom: Bool) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let w0 = edge.insetPolytopes.wall.vertices[c0.rawValue]
        let w1 = edge.insetPolytopes.wall.vertices[c1.rawValue]
        
        let h0 = SCNVector3.lerp(from: w0, to: w1, factor: insets.cutaway)
        let h1 = SCNVector3.lerp(from: w1, to: w0, factor: insets.cutaway)
        
        let v0 = edge.insetPolytopes.polytope.vertices[c0.rawValue] + offsets.wallPeak
        let v1 = edge.insetPolytopes.polytope.vertices[c1.rawValue] + offsets.wallPeak
        
        let v2 = edge.insetPolytopes.wall.vertices[c1.rawValue] + offsets.wallPeak
        let v3 = edge.insetPolytopes.wall.vertices[c0.rawValue] + offsets.wallPeak
        
        let v4 = SCNVector3(x: h0.x, y: v3.y, z: h0.z)
        let v5 = SCNVector3(x: h1.x, y: v2.y, z: h1.z)
        let v6 = h0 + offsets.lintelFramePeak
        let v7 = h1 + offsets.lintelFramePeak
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v4, v2: (h0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (h0 + offsets.skirtingPeak), v2: (w0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v5, v1: v2, v2: (w1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: (w1 + offsets.skirtingPeak), v2: (h1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        if transom {
            
            let v8 = h0 + offsets.transomFramePeak
            let v9 = h1 + offsets.transomFramePeak
            let v10 = h0 + offsets.transomFrameBase
            let v11 = h1 + offsets.transomFrameBase
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v9, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v9, v2: v8, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            
            meshFaces.append(MeshFace(v0: v10, v1: v11, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v10, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        }
        else {
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        }
        
        return meshFaces
    }
    
    func areaNode(wall corner: AreaNodeCornerData, insets: (AreaArchitectureInsets, AreaArchitectureInsets), offsets: (AreaArchitectureOffsets, AreaArchitectureOffsets)) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let oppositeCorner = GridCorner.opposite(corner: corner.corner)
        
        let (e0, e1) = GridEdge.edges(corner: oppositeCorner)
        
        let (o0, o1) = (offsets.0, offsets.1)
        let (cp0, cp1) = (corner.colorPalettes.0, corner.colorPalettes.1)
        
        let (ec0, ec1) = GridCorner.corners(edge: e0)
        let (ec2, ec3) = GridCorner.corners(edge: e1)
        
        let c0 = (ec0 != oppositeCorner ? ec0 : ec1)
        let c1 = (ec2 != oppositeCorner ? ec2 : ec3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        let w1 = corner.insetPolytopes.wall.vertices[c0.rawValue]
        let w2 = corner.insetPolytopes.wall.vertices[oppositeCorner.rawValue]
        let w3 = corner.insetPolytopes.wall.vertices[c1.rawValue]
        
        let v0 = corner.insetPolytopes.wall.vertices[corner.corner.rawValue] + o0.wallPeak
        let v1 = corner.insetPolytopes.wall.vertices[c0.rawValue] + o0.wallPeak
        let v2 = corner.insetPolytopes.wall.vertices[oppositeCorner.rawValue] + o0.wallPeak
        let v3 = corner.insetPolytopes.wall.vertices[c1.rawValue] + o0.wallPeak
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: cp1.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v1, v2: (w1 + o0.skirtingPeak), projectedNormal: n0, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: (w1 + o0.skirtingPeak), v2: (w2 + o0.skirtingPeak), projectedNormal: n0, color: cp0.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v2, v2: (w2 + o1.skirtingPeak), projectedNormal: n1, color: cp1.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (w2 + o1.skirtingPeak), v2: (w3 + o1.skirtingPeak), projectedNormal: n1, color: cp1.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(wall edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let w0 = edge.insetPolytopes.wall.vertices[c0.rawValue]
        let w1 = edge.insetPolytopes.wall.vertices[c1.rawValue]
        
        let v0 = edge.insetPolytopes.polytope.vertices[c0.rawValue] + offsets.wallPeak
        let v1 = edge.insetPolytopes.polytope.vertices[c1.rawValue] + offsets.wallPeak
        
        let v2 = edge.insetPolytopes.wall.vertices[c1.rawValue] + offsets.wallPeak
        let v3 = edge.insetPolytopes.wall.vertices[c0.rawValue] + offsets.wallPeak
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v2, v2: (w1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (w1 + offsets.skirtingPeak), v2: (w0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let w0 = edge.insetPolytopes.wall.vertices[c0.rawValue]
        let w1 = edge.insetPolytopes.wall.vertices[c1.rawValue]
        
        let h0 = SCNVector3.lerp(from: w0, to: w1, factor: insets.cutaway)
        let h1 = SCNVector3.lerp(from: w1, to: w0, factor: insets.cutaway)
        
        let v0 = edge.insetPolytopes.polytope.vertices[c0.rawValue] + offsets.wallPeak
        let v1 = edge.insetPolytopes.polytope.vertices[c1.rawValue] + offsets.wallPeak
        
        let v2 = edge.insetPolytopes.wall.vertices[c1.rawValue] + offsets.wallPeak
        let v3 = edge.insetPolytopes.wall.vertices[c0.rawValue] + offsets.wallPeak
        
        let v4 = SCNVector3(x: h0.x, y: v3.y, z: h0.z)
        let v5 = SCNVector3(x: h1.x, y: v2.y, z: h1.z)
        let v6 = h0 + offsets.lintelFramePeak
        let v7 = h1 + offsets.lintelFramePeak
        let v8 = h0 + offsets.windowFrameBase
        let v9 = h1 + offsets.windowFrameBase
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v4, v2: (h0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: (h0 + offsets.skirtingPeak), v2: (w0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v5, v1: v2, v2: (w1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: (w1 + offsets.skirtingPeak), v2: (h1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v8, v1: v9, v2: (h1 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: (h1 + offsets.skirtingPeak), v2: (h0 + offsets.skirtingPeak), projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
}
