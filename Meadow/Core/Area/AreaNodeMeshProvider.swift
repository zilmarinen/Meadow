//
//  AreaNodeMeshProvider.swift
//  Meadow
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

struct AreaNodePolytopes {
    
    let polytope: Polytope
    
    let wall: Polytope
    
    let skirting: Polytope
 
    let wallCutaway: Polytope
    
    let frameCutaway: Polytope
}

struct AreaNodeCornerData {
    
    let corner: GridCorner
    
    let side: Plane.Side
    
    let colorPalettes: (ColorPalette, ColorPalette)
    
    let polytopes: AreaNodePolytopes
}

struct AreaNodeEdgeData {
    
    let edge: GridEdge
    
    let side: Plane.Side
    
    let normal: SCNVector3
    
    let colorPalette: ColorPalette
    
    let polytopes: AreaNodePolytopes
}

protocol AreaNodeMeshProvider {
    
    func areaNode(corner: GridCorner, polyhedron: Polyhedron, architectureTypes: (AreaArchitectureType, AreaArchitectureType), side: Plane.Side, colorPalettes: (ColorPalette, ColorPalette)) -> [MeshFace]
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, architectureType: AreaArchitectureType, side: Plane.Side, edges: AreaNode.Edges, colorPalette: ColorPalette) -> [MeshFace]
    
    func areaNode(doorway edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets, transom: Bool) -> [MeshFace]
    
    func areaNode(wall corner: AreaNodeCornerData, insets: (AreaArchitectureInsets, AreaArchitectureInsets), offsets: (AreaArchitectureOffsets, AreaArchitectureOffsets)) -> [MeshFace]
    
    func areaNode(wall edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
    
    func areaNode(window edge: AreaNodeEdgeData, insets: AreaArchitectureInsets, offsets: AreaArchitectureOffsets) -> [MeshFace]
}

extension AreaNodeMeshProvider {
    
    func areaNode(edgeInsets edgeType: AreaNodeEdgeType, architectureType: AreaArchitectureType, side: Plane.Side) -> AreaArchitectureInsets {
        
        let doorWidth = architectureType.meshProvider.door.x
        let frameWidth = architectureType.meshProvider.frame.x
        let windowWidth = architectureType.meshProvider.window.x
        let fullWidth = (edgeType == .doubleDoor || edgeType == .doubleDoorWithTransom || edgeType == .windowFullWidth)
        
        let wallInset = (side == .exterior ? AreaNode.externalWallDepth : AreaNode.internalWallDepth)
        let skirtingInset = (wallInset + architectureType.meshProvider.skirting.z)
        
        var cutawayWidth = MDWFloat(0.0)
        
        switch edgeType {
            
        case .windowHalfWidth,
             .windowFullWidth:
            
            cutawayWidth = (windowWidth * (fullWidth ? 2 : 1))
            
        case .door,
             .doorWithTransom,
             .doubleDoor,
             .doubleDoorWithTransom:
            
            cutawayWidth = (doorWidth * (fullWidth ? 2 : 1))
            
        default: break
        }
        
        let frameInset = (Axis.unitXZ - cutawayWidth) / 2.0
        let cutawayInset = (frameInset - frameWidth)
        
        return AreaArchitectureInsets(wall: wallInset, skirting: skirtingInset, frame: frameInset, cutaway: cutawayInset)
    }
    
    public func areaNode(offsets architectureType: AreaArchitectureType, side: Plane.Side) -> AreaArchitectureOffsets {
        
        let areaHeight = Axis.Y(y: AreaNode.areaHeight)
        let doorHeight = architectureType.meshProvider.door.y
        let frameHeight = architectureType.meshProvider.frame.y
        let skirtingHeight = architectureType.meshProvider.skirting.y
        let transomHeight = architectureType.meshProvider.transom.y
        let windowHeight = architectureType.meshProvider.window.y
        let lintelHeight = ((areaHeight - (doorHeight + transomHeight + (frameHeight * 3))) / 2.0)
        
        let wallPeak = SCNVector3(x: 0.0, y: areaHeight, z: 0.0)
        let transomFramePeak = SCNVector3(x: 0.0, y: areaHeight - lintelHeight, z: 0.0)
        let transomPeak = SCNVector3(x: 0.0, y: transomFramePeak.y - frameHeight, z: 0.0)
        let transomBase = SCNVector3(x: 0.0, y: transomPeak.y - transomHeight, z: 0.0)
        let transomFrameBase = SCNVector3(x: 0.0, y: transomBase.y - frameHeight, z: 0.0)
        let lintelFramePeak = SCNVector3(x: 0.0, y: doorHeight + frameHeight, z: 0.0)
        let lintelPeak = SCNVector3(x: 0.0, y: doorHeight, z: 0.0)
        let windowBase = SCNVector3(x: 0.0, y: doorHeight - windowHeight, z: 0.0)
        let windowFrameBase = SCNVector3(x: 0.0, y: windowBase.y - frameHeight, z: 0.0)
        let skirtingPeak = SCNVector3(x: 0.0, y: (side == .interior ? skirtingHeight : 0.0), z: 0.0)
        let surface = SCNVector3(x: 0.0, y: AreaNode.surface, z: 0.0)
        
        return AreaArchitectureOffsets(wallPeak: wallPeak,
                                       transomFramePeak: transomFramePeak,
                                       transomPeak: transomPeak,
                                       transomBase: transomBase,
                                       transomFrameBase: transomFrameBase,
                                       lintelFramePeak: lintelFramePeak,
                                       lintelPeak: lintelPeak,
                                       windowBase: windowBase,
                                       windowFrameBase: windowFrameBase,
                                       skirtingPeak: skirtingPeak,
                                       surface: surface)
    }
}

extension AreaNodeMeshProvider {
    
    func areaNode(corner: GridCorner, polyhedron: Polyhedron, architectureTypes: (AreaArchitectureType, AreaArchitectureType), side: Plane.Side, colorPalettes: (ColorPalette, ColorPalette)) -> [MeshFace] {
        
        let oppositeCorner = GridCorner.opposite(corner: corner)
        
        let (e0, e1) = GridEdge.edges(corner: oppositeCorner)
        
        let (at0, at1) = (architectureTypes.0, architectureTypes.1)
        let (cp0, cp1) = (colorPalettes.0, colorPalettes.1)
        
        let i0 = areaNode(edgeInsets: .wall, architectureType: at0, side: side)
        let i1 = areaNode(edgeInsets: .wall, architectureType: at1, side: side)
        
        let o0 = areaNode(offsets: at0, side: side)
        let o1 = areaNode(offsets: at1, side: side)
        
        var wallPolytope = polyhedron.lowerPolytope
        
        var skirtingPolytope = polyhedron.lowerPolytope
        
        wallPolytope = Polytope.inset(polytope: wallPolytope, edge: e0, inset: (Axis.unitXZ - i0.wall))
        wallPolytope = Polytope.inset(polytope: wallPolytope, edge: e1, inset: (Axis.unitXZ - i1.wall))
        
        skirtingPolytope = Polytope.inset(polytope: skirtingPolytope, edge: e0, inset: (Axis.unitXZ - i0.skirting))
        skirtingPolytope = Polytope.inset(polytope: skirtingPolytope, edge: e1, inset: (Axis.unitXZ - i1.skirting))
        
        let polytopes = AreaNodePolytopes(polytope: polyhedron.lowerPolytope, wall: wallPolytope, skirting: skirtingPolytope, wallCutaway: wallPolytope, frameCutaway: skirtingPolytope)
        
        let data = AreaNodeCornerData(corner: corner,
                                      side: side,
                                      colorPalettes: colorPalettes,
                                      polytopes: polytopes)
        
        var meshFaces: [MeshFace] = []
        
        meshFaces.append(contentsOf: areaNode(wall: data, insets: (i0, i1), offsets: (o0, o1)))
        
        if side == .interior {
            
            let d0 = AreaNodeEdgeData(edge: e0,
                                      side: side,
                                      normal: GridEdge.normal(edge: e0),
                                      colorPalette: cp0,
                                      polytopes: polytopes)
            
            let d1 = AreaNodeEdgeData(edge: e1,
                                      side: side,
                                      normal: GridEdge.normal(edge: e1),
                                      colorPalette: cp1,
                                      polytopes: polytopes)
            
            meshFaces.append(contentsOf: at0.meshProvider.areaNode(skirting: d0, insets: i0, offsets: o0))
            meshFaces.append(contentsOf: at1.meshProvider.areaNode(skirting: d1, insets: i1, offsets: o1))
        }
        
        return meshFaces
    }
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, architectureType: AreaArchitectureType, side: Plane.Side, edges: AreaNode.Edges, colorPalette: ColorPalette) -> [MeshFace] {
        
        let insets = areaNode(edgeInsets: edgeType, architectureType: architectureType, side: side)
        let offsets = areaNode(offsets: architectureType, side: side)
        
        var wallPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: insets.wall)
        
        var skirtingPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: insets.skirting)
        
        let wallCutaway = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: insets.wall)
        
        let frameCutaway = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: insets.skirting)
        
        let (e0, e1) = GridEdge.edges(edge: edge)
        
        [e0, e1].forEach { connectedEdge in
            
            if edges.find(edge: connectedEdge)?.edgeType != nil {
                
                wallPolytope = Polytope.inset(polytope: wallPolytope, edge: connectedEdge, inset: insets.wall)
                
                skirtingPolytope = Polytope.inset(polytope: skirtingPolytope, edge: connectedEdge, inset: insets.skirting)
            }
        }
        
        let polytopes = AreaNodePolytopes(polytope: polyhedron.lowerPolytope, wall: wallPolytope, skirting: skirtingPolytope, wallCutaway: wallCutaway, frameCutaway: frameCutaway)
        
        let normal = GridEdge.normal(edge: (side == .exterior ? edge : GridEdge.opposite(edge: edge)))
        
        let data = AreaNodeEdgeData(edge: edge,
                                    side: side,
                                    normal: normal,
                                    colorPalette: colorPalette,
                                    polytopes: polytopes)
        
        var meshFaces: [MeshFace] = []
        
        switch edgeType {
            
        case .door,
             .doorWithTransom,
             .doubleDoor,
             .doubleDoorWithTransom:
            
            let transom = (edgeType == .doorWithTransom || edgeType == .doubleDoorWithTransom)
            
            meshFaces.append(contentsOf: areaNode(doorway: data, insets: insets, offsets: offsets, transom: transom))
            
            meshFaces.append(contentsOf: architectureType.meshProvider.areaNode(doorway: data, insets: insets, offsets: offsets))
            
            if transom {
                
                meshFaces.append(contentsOf: architectureType.meshProvider.areaNode(transom: data, insets: insets, offsets: offsets))
            }
            
        case .wall:
            
            meshFaces.append(contentsOf: areaNode(wall: data, insets: insets, offsets: offsets))
            
            if side == .interior {
             
                meshFaces.append(contentsOf: architectureType.meshProvider.areaNode(skirting: data, insets: insets, offsets: offsets))
            }
            
        case .windowFullWidth,
             .windowHalfWidth:
            
            meshFaces.append(contentsOf: areaNode(window: data, insets: insets, offsets: offsets))
            
            meshFaces.append(contentsOf: architectureType.meshProvider.areaNode(window: data, insets: insets, offsets: offsets))
            
            if side == .interior {
                
                meshFaces.append(contentsOf: architectureType.meshProvider.areaNode(skirting: data, insets: insets, offsets: offsets))
            }
        }
        
        return meshFaces
    }
}
