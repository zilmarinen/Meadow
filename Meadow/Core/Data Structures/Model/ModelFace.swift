//
//  ModelFace.swift
//  Meadow
//
//  Created by Zack Brown on 21/11/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import SceneKit

public struct ModelFace: Codable {
    
    public let v0: SCNVector3
    public let v1: SCNVector3
    public let v2: SCNVector3
    public let normal: SCNVector3
    public let color: Int
    
    public init(v0: SCNVector3, v1: SCNVector3, v2: SCNVector3, normal: SCNVector3, color: Int) {
        
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.normal = normal
        self.color = color
    }
}

extension ModelFace: Equatable {
    
    public static func == (lhs: ModelFace, rhs: ModelFace) -> Bool {
        
        return lhs.v0 == rhs.v0 && lhs.v1 == rhs.v1 && lhs.v2 == rhs.v2 && lhs.normal == rhs.normal && lhs.color == rhs.color
    }
}
