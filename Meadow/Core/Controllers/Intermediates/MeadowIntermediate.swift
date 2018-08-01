//
//  MeadowIntermediate.swift
//  Meadow
//
//  Created by Zack Brown on 27/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct MeadowIntermediate: Decodable {
    
    let areas: GridIntermediate<AreaNodeIntermediate>
    let foliage: GridIntermediate<FoliageNodeIntermediate>
    let footpaths: GridIntermediate<FootpathNodeIntermediate>
    let terrain: GridIntermediate<TerrainNodeIntermediate>
    let water: GridIntermediate<WaterNodeIntermediate>
}
