//
//  Meadow+Encodable.swift
//  Meadow
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public struct MeadowJSON: Decodable {
    
    let name: String
    
    let area: AreaJSON
    let foliage: FoliageJSON
    let footpath: FootpathJSON
    let terrain: TerrainJSON
    let water: WaterJSON
}
