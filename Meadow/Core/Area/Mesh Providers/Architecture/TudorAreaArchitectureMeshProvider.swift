//
//  TudorAreaArchitectureMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 21/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class TudorAreaArchitectureMeshProvider: AreaArchitectureMeshProvider {
    
    var door: SCNVector3 { return SCNVector3(x: 0.4, y: 0.8, z: 0.0) }

    var frame: SCNVector3 { return SCNVector3(x: 0.05, y: 0.05, z: 0.014) }
    
    var skirting: SCNVector3 { return SCNVector3(x: 0.0, y: 0.05, z: 0.014) }
    
    var transom: SCNVector3 { return SCNVector3(x: 0.4, y: 0.2, z: 0.0) }
    
    var window: SCNVector3 { return SCNVector3(x: 0.4, y: 0.45, z: 0.0) }
}

extension TudorAreaArchitectureMeshProvider {
    
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let (ce0, ce1) = GridEdge.edges(corner: c0)
        let (ce2, ce3) = GridEdge.edges(corner: c1)
        
        let e0 = (ce0 != edge.edge ? ce0 : ce1)
        let e1 = (ce2 != edge.edge ? ce2 : ce3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.polytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.polytopes.skirting.vertices[c1.rawValue]
        
        let wc0 = edge.polytopes.wallCutaway.vertices[c0.rawValue]
        let wc1 = edge.polytopes.wallCutaway.vertices[c1.rawValue]
        
        let fc0 = edge.polytopes.frameCutaway.vertices[c0.rawValue]
        let fc1 = edge.polytopes.frameCutaway.vertices[c1.rawValue]
        
        let pv0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pv1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wv0 = SCNVector3.lerp(from: wc0, to: wc1, factor: insets.cutaway)
        let wv1 = SCNVector3.lerp(from: wc1, to: wc0, factor: insets.cutaway)
        
        let fv0 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.cutaway)
        let fv1 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.cutaway)
        let fv2 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.frame)
        let fv3 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.frame)
        
        let v0 = pv0 + offsets.lintelPeak
        let v1 = pv1 + offsets.lintelPeak
        let v2 = pv0 + offsets.surface
        let v3 = pv1 + offsets.surface
        
        let v4 = wv0 + offsets.lintelFramePeak
        let v5 = wv1 + offsets.lintelFramePeak
        let v6 = wv0 + offsets.skirtingPeak
        let v7 = wv1 + offsets.skirtingPeak
        
        let v8 = fv0 + offsets.lintelFramePeak
        let v9 = fv1 + offsets.lintelFramePeak
        let v10 = fv2 + offsets.lintelFramePeak
        let v11 = fv3 + offsets.lintelFramePeak
        
        let v12 = fv2 + offsets.lintelPeak
        let v13 = fv3 + offsets.lintelPeak
        
        let v14 = fv0 + offsets.surface
        let v15 = fv1 + offsets.surface
        let v16 = fv2 + offsets.surface
        let v17 = fv3 + offsets.surface
        
        let v18 = s0 + offsets.skirtingPeak
        let v19 = s1 + offsets.skirtingPeak
        
        let v20 = fv0 + offsets.skirtingPeak
        let v21 = fv1 + offsets.skirtingPeak
        
        let v22 = s0 + offsets.surface
        let v23 = s1 + offsets.surface
        
        let v24 = w0 + offsets.skirtingPeak
        let v25 = w1 + offsets.skirtingPeak
        
        //top face
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v9, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v9, v2: v8, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: v10, v1: v11, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v10, v1: v13, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v10, v2: v16, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v16, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v9, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v15, v2: v17, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: v1, v1: v13, v2: v17, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v1, v1: v17, v2: v3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v0, v2: v2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v2, v2: v16, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        if edge.side == .interior {
            
            //top face
            meshFaces.append(MeshFace(v0: v24, v1: v6, v2: v20, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v24, v1: v20, v2: v18, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v7, v1: v25, v2: v19, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v7, v1: v19, v2: v21, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            
            //front face
            meshFaces.append(MeshFace(v0: v18, v1: v20, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v18, v1: v14, v2: v22, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v21, v1: v19, v2: v23, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v21, v1: v23, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            
            //outer face
            meshFaces.append(MeshFace(v0: v4, v1: v8, v2: v20, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v20, v2: v6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v9, v1: v5, v2: v7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v9, v1: v7, v2: v21, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        }
        else {
            
            let v26 = wv0 + offsets.surface
            let v27 = wv1 + offsets.surface
            
            //outer face
            meshFaces.append(MeshFace(v0: v4, v1: v8, v2: v14, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v4, v1: v14, v2: v26, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v9, v1: v5, v2: v27, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: v9, v1: v27, v2: v15, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        }
 
        return meshFaces
    }
    
    func areaNode(skirting edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.polytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.polytopes.skirting.vertices[c1.rawValue]
        
        let v0 = w0 + offsets.skirtingPeak
        let v1 = w1 + offsets.skirtingPeak
        
        let v2 = s0 + offsets.skirtingPeak
        let v3 = s1 + offsets.skirtingPeak
        
        let v4 = s0 + offsets.surface
        let v5 = s1 + offsets.surface
        
        //top face
        meshFaces.append(MeshFace(v0: v0, v1: v1, v2: v3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v0, v1: v3, v2: v2, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: v2, v1: v3, v2: v5, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v5, v2: v4, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        return meshFaces
    }
    
    func areaNode(transom edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let (ce0, ce1) = GridEdge.edges(corner: c0)
        let (ce2, ce3) = GridEdge.edges(corner: c1)
        
        let e0 = (ce0 != edge.edge ? ce0 : ce1)
        let e1 = (ce2 != edge.edge ? ce2 : ce3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let wc0 = edge.polytopes.wallCutaway.vertices[c0.rawValue]
        let wc1 = edge.polytopes.wallCutaway.vertices[c1.rawValue]
        
        let fc0 = edge.polytopes.frameCutaway.vertices[c0.rawValue]
        let fc1 = edge.polytopes.frameCutaway.vertices[c1.rawValue]
        
        let pv0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pv1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wv0 = SCNVector3.lerp(from: wc0, to: wc1, factor: insets.cutaway)
        let wv1 = SCNVector3.lerp(from: wc1, to: wc0, factor: insets.cutaway)
        
        let fv0 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.cutaway)
        let fv1 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.cutaway)
        let fv2 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.frame)
        let fv3 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.frame)
        
        let v0 = pv0 + offsets.transomPeak
        let v1 = pv1 + offsets.transomPeak
        let v2 = pv0 + offsets.transomBase
        let v3 = pv1 + offsets.transomBase
        
        let v4 = wv0 + offsets.transomFramePeak
        let v5 = wv1 + offsets.transomFramePeak
        let v6 = wv0 + offsets.transomFrameBase
        let v7 = wv1 + offsets.transomFrameBase
        
        let v8 = fv0 + offsets.transomFramePeak
        let v9 = fv1 + offsets.transomFramePeak
        let v10 = fv2 + offsets.transomFramePeak
        let v11 = fv3 + offsets.transomFramePeak
        
        let v12 = fv2 + offsets.transomPeak
        let v13 = fv3 + offsets.transomPeak
        
        let v14 = fv0 + offsets.transomFrameBase
        let v15 = fv1 + offsets.transomFrameBase
        let v16 = fv2 + offsets.transomFrameBase
        let v17 = fv3 + offsets.transomFrameBase
        
        let v18 = fv2 + offsets.transomBase
        let v19 = fv3 + offsets.transomBase
        
        //top face
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v9, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v9, v2: v8, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v3, v2: v19, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v19, v2: v18, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: v10, v1: v11, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v10, v1: v13, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v10, v2: v16, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v16, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v9, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v15, v2: v17, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v18, v1: v19, v2: v17, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v18, v1: v17, v2: v16, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: v1, v1: v13, v2: v19, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v1, v1: v19, v2: v3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v0, v2: v2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v2, v2: v18, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        //outer face
        meshFaces.append(MeshFace(v0: v4, v1: v8, v2: v14, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v14, v2: v6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v9, v1: v5, v2: v7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v9, v1: v7, v2: v15, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        return meshFaces
    }
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let (ce0, ce1) = GridEdge.edges(corner: c0)
        let (ce2, ce3) = GridEdge.edges(corner: c1)
        
        let e0 = (ce0 != edge.edge ? ce0 : ce1)
        let e1 = (ce2 != edge.edge ? ce2 : ce3)
        
        let n0 = GridEdge.normal(edge: e0)
        let n1 = GridEdge.normal(edge: e1)
        
        let p0 = edge.polytopes.polytope.vertices[c0.rawValue]
        let p1 = edge.polytopes.polytope.vertices[c1.rawValue]
        
        let wc0 = edge.polytopes.wallCutaway.vertices[c0.rawValue]
        let wc1 = edge.polytopes.wallCutaway.vertices[c1.rawValue]
        
        let fc0 = edge.polytopes.frameCutaway.vertices[c0.rawValue]
        let fc1 = edge.polytopes.frameCutaway.vertices[c1.rawValue]
        
        let pv0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pv1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wv0 = SCNVector3.lerp(from: wc0, to: wc1, factor: insets.cutaway)
        let wv1 = SCNVector3.lerp(from: wc1, to: wc0, factor: insets.cutaway)
        
        let fv0 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.cutaway)
        let fv1 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.cutaway)
        let fv2 = SCNVector3.lerp(from: fc0, to: fc1, factor: insets.frame)
        let fv3 = SCNVector3.lerp(from: fc1, to: fc0, factor: insets.frame)
        
        let v0 = pv0 + offsets.lintelPeak
        let v1 = pv1 + offsets.lintelPeak
        let v2 = pv0 + offsets.windowBase
        let v3 = pv1 + offsets.windowBase
        
        let v4 = wv0 + offsets.lintelFramePeak
        let v5 = wv1 + offsets.lintelFramePeak
        let v6 = wv0 + offsets.windowFrameBase
        let v7 = wv1 + offsets.windowFrameBase
        
        let v8 = fv0 + offsets.lintelFramePeak
        let v9 = fv1 + offsets.lintelFramePeak
        let v10 = fv2 + offsets.lintelFramePeak
        let v11 = fv3 + offsets.lintelFramePeak
        
        let v12 = fv2 + offsets.lintelPeak
        let v13 = fv3 + offsets.lintelPeak
        
        let v14 = fv0 + offsets.windowFrameBase
        let v15 = fv1 + offsets.windowFrameBase
        let v16 = fv2 + offsets.windowFrameBase
        let v17 = fv3 + offsets.windowFrameBase
        
        let v18 = fv2 + offsets.windowBase
        let v19 = fv3 + offsets.windowBase
        
        //top face
        meshFaces.append(MeshFace(v0: v4, v1: v5, v2: v9, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v9, v2: v8, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v3, v2: v19, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v2, v1: v19, v2: v18, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: v10, v1: v11, v2: v13, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v10, v1: v13, v2: v12, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v10, v2: v16, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v8, v1: v16, v2: v14, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v9, v2: v15, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v11, v1: v15, v2: v17, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v18, v1: v19, v2: v17, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v18, v1: v17, v2: v16, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: v1, v1: v13, v2: v19, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v1, v1: v19, v2: v3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v0, v2: v2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v12, v1: v2, v2: v18, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        //outer face
        meshFaces.append(MeshFace(v0: v4, v1: v8, v2: v14, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v4, v1: v14, v2: v6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v9, v1: v5, v2: v7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: v9, v1: v7, v2: v15, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        return meshFaces
    }
}
