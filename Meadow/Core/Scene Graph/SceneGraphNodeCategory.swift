//
//  SceneGraphNodeCategory.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public struct SceneGraphNodeCategory: OptionSet {

    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }

    public static let actors = SceneGraphNodeCategory(rawValue: 1 << 0)
    public static let area = SceneGraphNodeCategory(rawValue: 1 << 1)
    public static let foliage = SceneGraphNodeCategory(rawValue: 1 << 2)
    public static let footpath = SceneGraphNodeCategory(rawValue: 1 << 3)
    public static let meadow = SceneGraphNodeCategory(rawValue: 1 << 4)
    public static let props = SceneGraphNodeCategory(rawValue: 1 << 5)
    public static let scaffold = SceneGraphNodeCategory(rawValue: 1 << 6)
    public static let terrain = SceneGraphNodeCategory(rawValue: 1 << 7)
    public static let tunnel = SceneGraphNodeCategory(rawValue: 1 << 8)
    public static let water = SceneGraphNodeCategory(rawValue: 1 << 9)
}
