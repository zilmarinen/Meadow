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
        let wi0 = edge.insetPolytopes.wall.vertices[c0.rawValue]
        let wi1 = edge.insetPolytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.polytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.polytopes.skirting.vertices[c1.rawValue]
        let si0 = edge.insetPolytopes.skirting.vertices[c0.rawValue]
        let si1 = edge.insetPolytopes.skirting.vertices[c1.rawValue]
        
        let pf0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pf1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wc0 = SCNVector3.lerp(from: w0, to: w1, factor: insets.cutaway)
        let wc1 = SCNVector3.lerp(from: w1, to: w0, factor: insets.cutaway)
        
        let sc0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.cutaway)
        let sc1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.cutaway)
        let sf0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.frame)
        let sf1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.frame)
        
        let pv0 = pf0 + offsets.lintelPeak
        let pv1 = pf1 + offsets.lintelPeak
        let pv2 = pf0 + offsets.surface
        let pv3 = pf1 + offsets.surface
        
        let wv0 = wc0 + offsets.lintelFramePeak
        let wv1 = wc1 + offsets.lintelFramePeak
        let wv2 = wc0 + offsets.skirtingPeak
        let wv3 = wc1 + offsets.skirtingPeak
        let wv4 = wi0 + offsets.skirtingPeak
        let wv5 = wi1 + offsets.skirtingPeak
        
        let sv0 = sc0 + offsets.lintelFramePeak
        let sv1 = sc1 + offsets.lintelFramePeak
        let sv2 = sf0 + offsets.lintelFramePeak
        let sv3 = sf1 + offsets.lintelFramePeak
        let sv4 = sf0 + offsets.lintelPeak
        let sv5 = sf1 + offsets.lintelPeak
        let sv6 = sc0 + offsets.surface
        let sv7 = sc1 + offsets.surface
        let sv8 = sf0 + offsets.surface
        let sv9 = sf1 + offsets.surface
        let sv10 = si0 + offsets.skirtingPeak
        let sv11 = si1 + offsets.skirtingPeak
        let sv12 = sc0 + offsets.skirtingPeak
        let sv13 = sc1 + offsets.skirtingPeak
        
        //top face
        meshFaces.append(MeshFace(v0: wv0, v1: wv1, v2: sv1, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: wv0, v1: sv1, v2: sv0, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: sv2, v1: sv3, v2: sv5, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv2, v1: sv5, v2: sv4, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv2, v2: sv8, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv8, v2: sv6, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv1, v2: sv7, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv7, v2: sv9, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: pv1, v1: sv5, v2: sv9, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: pv1, v1: sv9, v2: pv3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv0, v2: pv2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv2, v2: sv8, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        if edge.side == .interior {
            
            //top face
            meshFaces.append(MeshFace(v0: wv4, v1: wv2, v2: sv12, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: wv4, v1: sv12, v2: sv10, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: wv3, v1: wv5, v2: sv11, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: wv3, v1: sv11, v2: sv13, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
            
            //front face
            meshFaces.append(MeshFace(v0: sv10, v1: sv12, v2: sv6, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv10, v1: sv6, v2: si0 + offsets.surface, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv13, v1: sv11, v2: si1 + offsets.surface, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv13, v1: si1 + offsets.surface, v2: sv7, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
            
            //outer face
            meshFaces.append(MeshFace(v0: wv0, v1: sv0, v2: sv12, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: wv0, v1: sv12, v2: wv2, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv1, v1: wv1, v2: wv3, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv1, v1: wv3, v2: sv13, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        }
        else {
            
            //outer face
            meshFaces.append(MeshFace(v0: wv0, v1: sv0, v2: sv6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: wv0, v1: sv6, v2: wc0 + offsets.surface, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv1, v1: wv1, v2: wc1 + offsets.surface, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
            meshFaces.append(MeshFace(v0: sv1, v1: wc1 + offsets.surface, v2: sv7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        }
        
        return meshFaces
    }
    
    func areaNode(skirting edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace] {
        
        var meshFaces: [MeshFace] = []
        
        let (c0, c1) = GridCorner.corners(edge: edge.edge)
        
        let w0 = edge.insetPolytopes.wall.vertices[c0.rawValue]
        let w1 = edge.insetPolytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.insetPolytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.insetPolytopes.skirting.vertices[c1.rawValue]
        
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
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.polytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.polytopes.skirting.vertices[c1.rawValue]
        
        let pf0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pf1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wc0 = SCNVector3.lerp(from: w0, to: w1, factor: insets.cutaway)
        let wc1 = SCNVector3.lerp(from: w1, to: w0, factor: insets.cutaway)
        
        let sc0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.cutaway)
        let sc1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.cutaway)
        let sf0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.frame)
        let sf1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.frame)
        
        let pv0 = pf0 + offsets.transomPeak
        let pv1 = pf1 + offsets.transomPeak
        let pv2 = pf0 + offsets.transomBase
        let pv3 = pf1 + offsets.transomBase
        
        let wv0 = wc0 + offsets.transomFramePeak
        let wv1 = wc1 + offsets.transomFramePeak
        let wv2 = wc0 + offsets.transomFrameBase
        let wv3 = wc1 + offsets.transomFrameBase
        
        let sv0 = sc0 + offsets.transomFramePeak
        let sv1 = sc1 + offsets.transomFramePeak
        let sv2 = sf0 + offsets.transomFramePeak
        let sv3 = sf1 + offsets.transomFramePeak
        let sv4 = sf0 + offsets.transomPeak
        let sv5 = sf1 + offsets.transomPeak
        let sv6 = sc0 + offsets.transomFrameBase
        let sv7 = sc1 + offsets.transomFrameBase
        let sv8 = sf0 + offsets.transomFrameBase
        let sv9 = sf1 + offsets.transomFrameBase
        let sv10 = sf0 + offsets.transomBase
        let sv11 = sf1 + offsets.transomBase
        
        //top face
        meshFaces.append(MeshFace(v0: wv0, v1: wv1, v2: sv1, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: wv0, v1: sv1, v2: sv0, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: pv2, v2: pv3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: pv3, v2: sv11, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: sv2, v1: sv3, v2: sv5, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv2, v1: sv5, v2: sv4, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv2, v2: sv8, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv8, v2: sv6, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv1, v2: sv7, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv7, v2: sv9, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: sv11, v2: sv9, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: sv9, v2: sv8, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: pv1, v1: sv5, v2: sv11, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: pv1, v1: sv11, v2: pv3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv0, v2: pv2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv2, v2: sv10, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        //outer face
        meshFaces.append(MeshFace(v0: wv0, v1: sv0, v2: sv6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: wv0, v1: sv6, v2: wv2, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv1, v1: wv1, v2: wv3, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv1, v1: wv3, v2: sv7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
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
        
        let w0 = edge.polytopes.wall.vertices[c0.rawValue]
        let w1 = edge.polytopes.wall.vertices[c1.rawValue]
        
        let s0 = edge.polytopes.skirting.vertices[c0.rawValue]
        let s1 = edge.polytopes.skirting.vertices[c1.rawValue]
        
        let pf0 = SCNVector3.lerp(from: p0, to: p1, factor: insets.frame)
        let pf1 = SCNVector3.lerp(from: p1, to: p0, factor: insets.frame)
        
        let wc0 = SCNVector3.lerp(from: w0, to: w1, factor: insets.cutaway)
        let wc1 = SCNVector3.lerp(from: w1, to: w0, factor: insets.cutaway)
        
        let sc0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.cutaway)
        let sc1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.cutaway)
        let sf0 = SCNVector3.lerp(from: s0, to: s1, factor: insets.frame)
        let sf1 = SCNVector3.lerp(from: s1, to: s0, factor: insets.frame)
        
        let pv0 = pf0 + offsets.lintelPeak
        let pv1 = pf1 + offsets.lintelPeak
        let pv2 = pf0 + offsets.windowBase
        let pv3 = pf1 + offsets.windowBase
        
        let wv0 = wc0 + offsets.lintelFramePeak
        let wv1 = wc1 + offsets.lintelFramePeak
        let wv2 = wc0 + offsets.windowFrameBase
        let wv3 = wc1 + offsets.windowFrameBase
        
        let sv0 = sc0 + offsets.lintelFramePeak
        let sv1 = sc1 + offsets.lintelFramePeak
        let sv2 = sf0 + offsets.lintelFramePeak
        let sv3 = sf1 + offsets.lintelFramePeak
        let sv4 = sf0 + offsets.lintelPeak
        let sv5 = sf1 + offsets.lintelPeak
        let sv6 = sc0 + offsets.windowFrameBase
        let sv7 = sc1 + offsets.windowFrameBase
        let sv8 = sf0 + offsets.windowFrameBase
        let sv9 = sf1 + offsets.windowFrameBase
        let sv10 = sf0 + offsets.windowBase
        let sv11 = sf1 + offsets.windowBase
        
        //top face
        meshFaces.append(MeshFace(v0: wv0, v1: wv1, v2: sv1, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: wv0, v1: sv1, v2: sv0, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: pv2, v2: pv3, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: pv3, v2: sv11, projectedNormal: SCNVector3.Up, color: edge.colorPalette.secondary.vector))
        
        //front face
        meshFaces.append(MeshFace(v0: sv2, v1: sv3, v2: sv5, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv2, v1: sv5, v2: sv4, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv2, v2: sv8, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv0, v1: sv8, v2: sv6, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv1, v2: sv7, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv3, v1: sv7, v2: sv9, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: sv11, v2: sv9, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv10, v1: sv9, v2: sv8, projectedNormal: edge.normal, color: edge.colorPalette.secondary.vector))
        
        //inner face
        meshFaces.append(MeshFace(v0: pv1, v1: sv5, v2: sv11, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: pv1, v1: sv11, v2: pv3, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv0, v2: pv2, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv4, v1: pv2, v2: sv10, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        //outer face
        meshFaces.append(MeshFace(v0: wv0, v1: sv0, v2: sv6, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: wv0, v1: sv6, v2: wv2, projectedNormal: n0, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv1, v1: wv1, v2: wv3, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        meshFaces.append(MeshFace(v0: sv1, v1: wv3, v2: sv7, projectedNormal: n1, color: edge.colorPalette.secondary.vector))
        
        return meshFaces
    }
}
