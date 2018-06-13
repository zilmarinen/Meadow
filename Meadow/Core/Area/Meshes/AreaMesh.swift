//
//  AreaMesh.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class AreaMesh
 @abstract Abstract class defines the base Meshes for AreaNodes.
 */
public class AreaMesh {
    
    /*!
     @method wall:polyhedron:edge:colorPalette
     @abstract Creates and returns a wall mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn
     @param edge The GridEdge along which to render the wall.
     @param colorPalette The ColorPalette to use when painting the wall.
     */
    static func wall(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh {
        
        return Mesh(faces: [])
    }
}
