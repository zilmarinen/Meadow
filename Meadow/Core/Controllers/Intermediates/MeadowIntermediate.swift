//
//  MeadowIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct MeadowIntermediate: Decodable {
    
    let areas: GridIntermediate<Area.IntermediateType>
    let foliage: GridIntermediate<Foliage.IntermediateType>
    let footpaths: GridIntermediate<Footpath.IntermediateType>
    let terrain: GridIntermediate<Terrain.IntermediateType>
    let water: GridIntermediate<Water.IntermediateType>
}
