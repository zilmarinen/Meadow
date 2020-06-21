//
//  WaterTile.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Pasture

public class WaterTile: LayerableTile<WaterEdge, WaterLayer> {
    
    public override var category: SceneGraphNodeCategory { return .water }
}
