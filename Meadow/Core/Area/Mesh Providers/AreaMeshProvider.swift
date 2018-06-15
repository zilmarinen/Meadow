//
//  AreaMeshProvider.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @protocol AreaMeshProvider
 @abstract Defines the methods required to generate Meshes for AreaNodes.
 */
public protocol AreaMeshProvider {
    
    /*!
     @method doorway:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    func doorway(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh
    
    /*!
     @method wall:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    func wall(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh
    
    /*!
     @method window:polyhedron:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     */
    func window(polyhedron: Polyhedron, edge: GridEdge, colorPalette: ColorPalette) -> Mesh
}
