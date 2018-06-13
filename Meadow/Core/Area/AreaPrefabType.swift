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
    
    case concrete
    case sandstone
    case steel
    
    /*!
     @property description
     @abstract Returns the String value of the AreaPrefabType.
     */
    public var description: String {
        
        switch self {
        
        case .concrete: return "Concrete"
        case .sandstone: return "Sandstone"
        case .steel: return "Steel"
        }
    }
}

extension AreaPrefabType {
    
    /*!
     @property all
     @abstract An array of all available AreaPrefabTypes.
     */
    public static var all: [AreaPrefabType] { return [
        
        .concrete,
        .sandstone,
        .steel
    ]}
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
            
        case .door(let doorState):
            
            return AreaMesh.wall(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
            
        case .wall:
            
            switch self {
                
            case .concrete:
             
                return ConcreteAreaMesh.wall(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
                
            case .sandstone:
                
                return AreaMesh.wall(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
                
            case .steel:
                
                return AreaMesh.wall(polyhedron: polyhedron, edge: perimeterEdge.edge, colorPalette: colorPalette)
            }
            
        default: return Mesh(faces: [])
        }
    }
}
