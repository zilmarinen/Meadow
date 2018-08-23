//
//  AreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

struct AreaNodeCornerData {
    
    let corner: GridCorner
    
    let side: Plane.Side
    
    let architectureTypes: (AreaArchitectureType, AreaArchitectureType)
    
    let colorPalettes: (ColorPalette, ColorPalette)
    
    let polyhedron: Polyhedron
}

struct AreaNodeEdgeData {
    
    let edge: GridEdge
    
    let side: Plane.Side
    
    let architectureType: AreaArchitectureType
    
    let normal: SCNVector3
    
    let colorPalette: ColorPalette
    
    let polyhedron: Polyhedron
    
    let wall: Polytope
    
    let skirting: Polytope
}

protocol AreaNodeMeshProvider {
    
    func areaNode(corner: AreaNodeCornerData) -> [MeshFace]
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, architectureType: AreaArchitectureType, side: Plane.Side, edges: AreaNode.Edges, colorPalette: ColorPalette) -> [MeshFace]
    
    func areaNode(doorway edge: AreaNodeEdgeData, fullWidth: Bool, transom: Bool) -> [MeshFace]
    
    func areaNode(wall edge: AreaNodeEdgeData) -> [MeshFace]
    
    func areaNode(window edge: AreaNodeEdgeData, fullWidth: Bool) -> [MeshFace]
}

extension AreaNodeMeshProvider {
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, architectureType: AreaArchitectureType, side: Plane.Side, edges: AreaNode.Edges, colorPalette: ColorPalette) -> [MeshFace] {
        
        let doorWidth = architectureType.meshProvider.door.x
        let skirtingWidth = architectureType.meshProvider.skirting.x
        let windowWidth = architectureType.meshProvider.window.x
        
        guard (doorWidth * 2) + (skirtingWidth * 2) < 1 && (windowWidth * 2) + (skirtingWidth * 2) < 1 else { return [] }
        
        let wallInset = (side == .exterior ? AreaNode.externalWallDepth : AreaNode.internalWallDepth)
        let skirtingInset = (wallInset + architectureType.meshProvider.skirting.x)
        
        var wallPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: wallInset)
        
        var skirtingPolytope = Polytope.inset(polytope: polyhedron.lowerPolytope, edge: edge, inset: skirtingInset)
        
        let (e0, e1) = GridEdge.edges(edge: edge)
        
        [e0, e1].forEach { connectedEdge in
            
            if edges.find(edge: connectedEdge)?.edgeType != nil {
                
                wallPolytope = Polytope.inset(polytope: wallPolytope, edge: connectedEdge, inset: wallInset)
                
                skirtingPolytope = Polytope.inset(polytope: skirtingPolytope, edge: connectedEdge, inset: skirtingInset)
            }
        }
        
        let normal = GridEdge.normal(edge: (side == .exterior ? edge : GridEdge.opposite(edge: edge)))
        
        let data = AreaNodeEdgeData(edge: edge, side: side, architectureType: architectureType, normal: normal, colorPalette: colorPalette, polyhedron: polyhedron, wall: wallPolytope, skirting: skirtingPolytope)
        
        var meshFaces: [MeshFace] = []
        
        switch edgeType {
            
        case .door,
             .doorWithTransom,
             .doubleDoor,
             .doubleDoorWithTransom:
            
            let transom = (edgeType == .doorWithTransom || edgeType == .doubleDoorWithTransom)
            let fullWidth = (edgeType == .doubleDoor || edgeType == .doubleDoorWithTransom)
            
            meshFaces.append(contentsOf: areaNode(doorway: data, fullWidth: fullWidth, transom: transom))
            
            if transom {
                
                //meshFaces.append(contentsOf: edge.architectureType.meshProvider.areaNode(transom: data, polyhedron: polyhedron))
            }
            
        case .wall:
            
            meshFaces.append(contentsOf: areaNode(wall: data))
            
        case .windowFullWidth,
             .windowHalfWidth:
            
            let fullWidth = (edgeType == .windowFullWidth)
            
            meshFaces.append(contentsOf: areaNode(window: data, fullWidth: fullWidth))
        }
        
        return meshFaces
    }
}
