//
//  AreaPrefabType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 11/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @enum AreaPrefabType
 @abstract Defines the AreaPrefabType of an AreaNode.
 */
public enum AreaPrefabType: Int, Codable {
    
    case prefab
    
    /*!
     @property description
     @abstract Returns the String value of the AreaPrefabType.
     */
    public var description: String {
        
        switch self {
        
        case .prefab: return "Prefab"
        }
    }
}

extension AreaPrefabType {
    
    /*!
     @property all
     @abstract An array of all available AreaPrefabTypes.
     */
    public static var all: [AreaPrefabType] { return [
        
        .prefab
    ]}
}

extension AreaPrefabType {
    
    /*!
     @property meshProvider
     @abstract The MeshProvider used to create the mesh for a given AreaPerimeterEdge.
     */
    var meshProvider: AreaMeshProvider {
        
        switch self {
        
        default: return PrefabAreaMeshProvider()
        }
    }
}

extension AreaPrefabType {
    
    /*!
     @method mesh:polyhedron:perimeterEdge:colorPalette
     @abstract Creates and returns a mesh for the given AreaPerimeterType along the specified GridEdge defined by the AreaPerimeterEdge.
     @param polyhedron The Polyhedron of the AreaNode being drawn.
     @param perimeterEdge The AreaPerimeterEdge PerimeterType and GridEdge.
     @param colorPalette The ColorPalette to paint the mesh with.
     */
    func mesh(polyhedron: Polyhedron, perimeterEdge: AreaPerimeterEdge, colorPalette: ColorPalette) -> Mesh {
        
        switch perimeterEdge.perimeterType {
            
        case .doorway:
            
            return meshProvider.doorway(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
            
        case .wall:
            
            return meshProvider.wall(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
            
        case .window:
            
            return meshProvider.window(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
        }
    }
}
