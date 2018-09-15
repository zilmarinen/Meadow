//
//  FoliageNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 05/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

protocol FoliageNodeMeshProvider {
    
    var nodeHeight: Int { get }
    
    func foliageNode(polyhedron: Polyhedron) -> [MeshFace]
}
