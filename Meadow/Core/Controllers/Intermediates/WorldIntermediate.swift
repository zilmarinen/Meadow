//
//  WorldIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 13/09/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct WorldIntermediate: Decodable {
    
    let floorColor: String
    
    let areas: GridIntermediate<Area.IntermediateType>
    let foliage: GridIntermediate<Foliage.IntermediateType>
    let footpaths: GridIntermediate<Footpath.IntermediateType>
    let props: PropsIntermediate
    let terrain: GridIntermediate<Terrain.IntermediateType>
    let water: GridIntermediate<Water.IntermediateType>
}
