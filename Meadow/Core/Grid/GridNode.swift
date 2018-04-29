//
//  GridNode.swift
//  GDH
//
//  Created by Zack Brown on 26/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public class GridNode {
    
    var polyhedron: Polyhedron {
        
        return Polyhedron(upperPolytope: Polytope(x: 0.0, y: 0.0, z: 0.0), lowerPolytope: Polytope(x: 0.0, y: World.UnitY, z: 0.0))
    }
}
