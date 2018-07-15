//
//  FootpathNodeSlope.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 09/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct FootpathNodeSlope
 @abstract Stores the edge towards which the FootpathNode is sloped and its inclination.
 */
public struct FootpathNodeSlope: Codable, Equatable {
    
    /*!
     @property edge
     @abstract The edge from which the FootpathNode slopes upwards.
     */
    public let edge: GridEdge
    
    /*!
     @property steepInclination
     @abstract Determines the inclination of the slope.
     @discussion By default, a FootpathNodeSlope will have an inclination of `1 * World.UnitY`. Steep inclinations are double this value.
     */
    public let steepInclination: Bool
    
    /*!
     @method init:edge:steepInclination
     @abstract Creates and initialises a FootpathNodeSlope with the specified edge and inclination.
     @param edge The edge from which the FootpathNode slopes upwards.
     @param steepInclination Determines the inclination of the slope.
     */
    public init(edge: GridEdge, steepInclination: Bool) {
        
        self.edge = edge
        self.steepInclination = steepInclination
    }
}
