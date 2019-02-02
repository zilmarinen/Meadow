//
//  BrickAreaNodeMeshProvider.swift
//  Meadow
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class BrickAreaNodeMeshProvider: AreaNodeMeshProvider {
 
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets, transom: Bool) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let wc0 = edge.polytopes.wallCutaway.vertices[c0.rawValue]
        let wc1 = edge.polytopes.wallCutaway.vertices[c1.rawValue]
        
        let cv0 = SCNVector3.lerp(from: wc0, to: wc1, factor: insets.cutaway)
        let cv1 = SCNVector3.lerp(from: wc1, to: wc0, factor: insets.cutaway)
        
        let v0 = p0 + offsets.wallPeak
        let v1 = p1 + offsets.wallPeak
        
        let v2 = w0 + offsets.wallPeak
        let v3 = w1 + offsets.wallPeak
        
        let v4 = cv0 + offsets.wallPeak
        let v5 = cv1 + offsets.wallPeak
        
        let v6 = cv0 + offsets.transomFramePeak
        let v7 = cv1 + offsets.transomFramePeak
        
        let v8 = cv0 + offsets.transomFrameBase
        let v9 = cv1 + offsets.transomFrameBase
        
        let v10 = w0 + offsets.surface
        let v11 = w1 + offsets.surface
        
        let v12 = cv0 + offsets.surface
        let v13 = cv1 + offsets.surface
        
        let v14 = cv0 + offsets.lintelFramePeak
        let v15 = cv1 + offsets.lintelFramePeak
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v3, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v4, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v12, v2: v10, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        meshFaces.append(MeshFace(v0: v5, v1: v3, v2: v11, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: v11, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        if transom {
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            
            meshFaces.append(MeshFace(v0: v8, v1: v9, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v8, v1: v15, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        }
        else {
            
            meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v15, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
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
        
        let p0 = corner.polytopes.wall.vertices[corner.corner.rawValue]
        let p1 = corner.polytopes.wall.vertices[c0.rawValue]
        let p2 = corner.polytopes.wall.vertices[oppositeCorner.rawValue]
        let p3 = corner.polytopes.wall.vertices[c1.rawValue]
        
        let v0 = p0 + o0.wallPeak
        let v1 = p1 + o1.wallPeak
        let v2 = p2 + o0.wallPeak
        let v3 = p3 + o1.wallPeak
        
        let v4 = p1 + o1.surface
        let v5 = p2 + o0.surface
        let v6 = p3 + o1.surface
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v2, projectedNormal: SCNVector3.Up, color: cp0.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v2, v2: v3, projectedNormal: SCNVector3.Up, color: cp1.tertiary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v1, v2: v4, projectedNormal: n0, color: cp0.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v4, v2: v5, projectedNormal: n0, color: cp0.primary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v3, v1: v2, v2: v5, projectedNormal: n1, color: cp1.primary.vector))
        meshFaces.append(MeshFace(v0: v3, v1: v5, v2: v6, projectedNormal: n1, color: cp1.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(wall edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let v0 = p0 + offsets.wallPeak
        let v1 = p1 + offsets.wallPeak
        
        let v2 = w0 + offsets.wallPeak
        let v3 = w1 + offsets.wallPeak
        
        let v4 = w0 + offsets.surface
        let v5 = w1 + offsets.surface
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v3, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v3, v2: v5, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v5, v2: v4, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let wc0 = edge.polytopes.wallCutaway.vertices[c0.rawValue]
        let wc1 = edge.polytopes.wallCutaway.vertices[c1.rawValue]
        
        let cv0 = SCNVector3.lerp(from: wc0, to: wc1, factor: insets.cutaway)
        let cv1 = SCNVector3.lerp(from: wc1, to: wc0, factor: insets.cutaway)
        
        let v0 = p0 + offsets.wallPeak
        let v1 = p1 + offsets.wallPeak
        
        let v2 = w0 + offsets.wallPeak
        let v3 = w1 + offsets.wallPeak
        
        let v4 = cv0 + offsets.wallPeak
        let v5 = cv1 + offsets.wallPeak
        
        let v6 = cv0 + offsets.lintelFramePeak
        let v7 = cv1 + offsets.lintelFramePeak
        
        let v8 = cv0 + offsets.windowFrameBase
        let v9 = cv1 + offsets.windowFrameBase
        
        let v10 = w0 + offsets.surface
        let v11 = w1 + offsets.surface
        
        let v12 = cv0 + offsets.surface
        let v13 = cv1 + offsets.surface
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v3, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.tertiary.vector))
        
        //wall
        meshFaces.append(MeshFace(v0: v2, v1: v4, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v12, v2: v10, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: v3, v2: v11, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v5, v1: v11, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v7, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v7, v2: v6, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v9, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v13, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.primary.vector))
        
        return meshFaces
    }
}
