//
//  ModelGroup.swift
//  Meadow
//
//  Created by Zack Brown on 31/12/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Foundation

public struct ModelGroup: Codable {
    
    public let name: String
    
    public let faces: [ModelFace]
    
    public init(name: String, faces: [ModelFace]) {
        
        self.name = name
        self.faces = faces
    }
}

extension ModelGroup: Equatable {
    
    public static func == (lhs: ModelGroup, rhs: ModelGroup) -> Bool {
        
        return lhs.name == rhs.name && lhs.faces == rhs.faces
    }
}
