//
//  HedgeFoliageNodeMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 05/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

class HedgeFoliageNodeMeshProvider: FoliageNodeMeshProvider {
    
    var nodeHeight: Int { return 2 }
    
    func foliageNode(polyhedron: Polyhedron) -> [MeshFace] {
        
        return []
    }
}
