//
//  WoodAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class WoodAreaNodeMeshProvider: AreaMeshProvider {
    
    func areaNode(corner: GridCorner, polyhedron: Polyhedron, side: Plane.Side, colorPalettes: (ColorPalette, ColorPalette)) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(door edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(wall edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
    
    func areaNode(window edge: GridEdge, polyhedron: Polyhedron, side: Plane.Side, edges: AreaNode.Edges, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
}
