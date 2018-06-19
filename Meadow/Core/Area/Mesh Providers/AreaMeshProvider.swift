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
     @method corner:node:corner:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param corner The GridCorner around which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    func corner(node: AreaNode, corner: GridCorner, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh?
    
    /*!
     @method doorway:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    func doorway(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh
    
    /*!
     @method wall:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    func wall(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh
    
    /*!
     @method window:node:edge:colorPalette
     @abstract Creates and returns a mesh along the given GridEdge painted with the specified ColorPalette.
     @param node The AreaNode being drawn.
     @param edge The GridEdge along which to render the mesh.
     @param colorPalette The ColorPalette to use when painting the mesh.
     @param side The side towards which the mesh should be drawn facing.
     */
    func window(node: AreaNode, edge: GridEdge, colorPalette: ColorPalette, side: Plane.PlaneSide) -> Mesh
}
