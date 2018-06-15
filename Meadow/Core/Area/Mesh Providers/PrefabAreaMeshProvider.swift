//
//  PrefabAreaMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 15/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @class PrefabAreaMeshProvider
 @abstract Defines the methods required to generate Meshes for AreaNodes.
 */
public class PrefabAreaMeshProvider: AreaMeshProvider {
    
    /*!
     @method doorway:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    public func doorway(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh {
        
        return Mesh(faces: [])
    }
    
    /*!
     @method wall:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    public func wall(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh {
        
        return Mesh(faces: [])
    }
    
    /*!
     @method window:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    public func window(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh {
        
        return Mesh(faces: [])
    }
}
