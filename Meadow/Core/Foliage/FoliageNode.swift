//
//  FoliageNode.swift
//  Meadow
//
//  Created by Zack Brown on 01/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public class FoliageNode: GridNode {
    
    public var foliageType: FoliageType? {
        
        didSet {
            
            if foliageType != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    var basePolytope: Polytope? {
        
        didSet {
            
            if basePolytope != oldValue {
                
                becomeDirty()
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        
        case foliageType
    }
    
    public override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.foliageType, forKey: .foliageType)
    }
    
    public override var mesh: Mesh {
        
        var meshFaces: [MeshFace] = []
        
        if let meshProvider = foliageType?.meshProvider {
            
            meshFaces.append(contentsOf: meshProvider.foliageNode(polyhedron: polyhedron))
        }
        
        return Mesh(faces: meshFaces)
    }
}

extension FoliageNode: GridPolyhedronProvider {
    
    var upperPolytope: Polytope {
        
        let nodeHeight = (foliageType?.meshProvider.nodeHeight ?? 0)
        
        let offset = SCNVector3(x: 0.0, y: Axis.Y(y: nodeHeight), z: 0.0)
        
        return Polytope(v0: lowerPolytope.vertices[0] + offset, v1: lowerPolytope.vertices[1] + offset, v2: lowerPolytope.vertices[2] + offset, v3: lowerPolytope.vertices[3] + offset)
    }
    
    var lowerPolytope: Polytope {
        
        return basePolytope ?? Polytope(x: MDWFloat(volume.coordinate.x), y0: World.floor, y1: World.floor, y2: World.floor, y3: World.floor, z: MDWFloat(volume.coordinate.z))
    }
    
    public var polyhedron: Polyhedron { return Polyhedron(upperPolytope: upperPolytope, lowerPolytope: lowerPolytope) }
}
