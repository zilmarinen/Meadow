//
//  AreaNodeFloorMesh.swift
//  Meadow
//
//  Created by Zack Brown on 22/03/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

import SceneKit

public protocol AreaNodeFloorMesh {
    
    func area(floor polytope: Polytope, colorPalette: ColorPalette) -> [MeshFace]
}

extension AreaNodeFloorMesh {
    
    public func area(floor polytope: Polytope, colorPalette: ColorPalette) -> [MeshFace] {
        
        return MeshFace.quad(vertices: polytope.vertices, projectedNormal: SCNVector3.Up, color: colorPalette.primary.vector)
    }
}
