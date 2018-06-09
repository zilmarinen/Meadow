//
//  AreaPerimeterEdge.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 09/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct AreaPerimeterEdge
 @abstract Defines the AreaPerimeterType of an AreaNode along a specific GridEdge.
 */
public struct AreaPerimeterEdge: Codable, Hashable {
    
    /*!
     @param edge
     @abstract The edge of the AreaNode perimeter.
     */
    let edge: GridEdge
    
    /*!
     @param perimeterType
     @abstract The AreaPerimeterType for the AreaPerimeterEdge.
     */
    let perimeterType: AreaPerimeterType
}
