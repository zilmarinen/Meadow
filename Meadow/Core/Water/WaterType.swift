//
//  WaterType.swift
//  Meadow-iOS
//
//  Created by Zack Brown on 23/07/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public enum WaterType: Int, Codable {
    
    case water
}

extension WaterType {
    
    var meshProvider: WaterNodeMeshProvider {
        
        return WaterNodeMeshProvider()
    }
}
