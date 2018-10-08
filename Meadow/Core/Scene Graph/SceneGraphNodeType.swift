//
//  SceneGraphNodeType.swift
//  Meadow
//
//  Created by Zack Brown on 02/10/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct SceneGraphNodeType: OptionSet {
    
    public static let area = SceneGraphNodeType(rawValue: 1 << 0)
    public static let floor = SceneGraphNodeType(rawValue: 1 << 1)
    public static let foliage = SceneGraphNodeType(rawValue: 1 << 2)
    public static let footpaths = SceneGraphNodeType(rawValue: 1 << 3)
    public static let scaffold = SceneGraphNodeType(rawValue: 1 << 4)
    public static let terrain = SceneGraphNodeType(rawValue: 1 << 5)
    public static let tunnel = SceneGraphNodeType(rawValue: 1 << 6)
    public static let water = SceneGraphNodeType(rawValue: 1 << 7)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
}
