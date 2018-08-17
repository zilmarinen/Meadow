//
//  ConcreteAreaNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 10/08/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class ConcreteAreaNodeMeshProvider: AreaMeshProvider {
    
    func areaNode(edge corners: [GridCorner], edgeType: AreaNodeEdgeType, polyhedron: Polyhedron, side: Plane.Side, normal: SCNVector3, colorPalette: ColorPalette) -> [MeshFace] {
        
        return []
    }
}
