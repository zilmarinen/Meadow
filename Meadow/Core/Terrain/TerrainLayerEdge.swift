//
//  TerrainLayerEdge.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 09/06/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

/*!
 @struct TerrainLayerEdgeJSON
 @abstract
 */
public struct TerrainLayerEdgeJSON: Decodable {
    
    /*!
     @property edge
     @abstract The edge of the layer to be painted.
     */
    public let edge: GridEdge
    
    /*!
     @property terrainType
     @abstract The TerrainType used to paint the edge of the layer.
     */
    public let terrainType: String
}

/*!
 @struct TerrainLayerEdge
 @abstract Defines a relationship between an edge and a TerrainType.
 */
public struct TerrainLayerEdge: Hashable, Encodable {
    
    /*!
     @enum CodingKeys
     @abstract Defines the coding keys used when encoding this object.
     */
    private enum CodingKeys: CodingKey {
        
        case edge
        case terrainType
    }
    
    /*!
     @property edge
     @abstract The edge of the layer to be painted.
     */
    public let edge: GridEdge
    
    /*!
     @property terrainType
     @abstract The TerrainType used to paint the edge of the layer.
     */
    public let terrainType: TerrainType
    
    /*!
     @method encode:to
     @abstract Encodes this object into the given encoder.
     @property encoder The encoder to use when encoding this object.
     */
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(edge, forKey: .edge)
        try container.encode(terrainType.name, forKey: .terrainType)
    }
}
