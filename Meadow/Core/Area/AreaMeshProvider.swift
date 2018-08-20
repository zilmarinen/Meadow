//
//  AreaMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

protocol AreaMeshProvider {
    
    func areaNode(corner: GridCorner, polyhedron: Polyhedron, side: Plane.Side, colorPalettes: (ColorPalette, ColorPalette)) -> [MeshFace]
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace]
    
    func areaNode(door edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace]
    
    func areaNode(wall edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace]
    
    func areaNode(window edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace]
}

extension AreaMeshProvider {
    
    func areaNode(edge: GridEdge, polyhedron: Polyhedron, edgeType: AreaNodeEdgeType, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        switch edgeType {
            
        case .door:
            
            return areaNode(door: edge, polyhedron: polyhedron, side: side, edges: edges, normal: normal, colorPalette: colorPalette)
            
        case .wall:
            
            return areaNode(wall: edge, polyhedron: polyhedron, side: side, edges: edges, normal: normal, colorPalette: colorPalette)
            
        case .window:
            
            return areaNode(window: edge, polyhedron: polyhedron, side: side, edges: edges, normal: normal, colorPalette: colorPalette)
        }
    }
}
