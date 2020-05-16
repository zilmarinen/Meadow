//
//  SceneGraphNodeType.swift
//  Meadow
//
//  Created by Zack Brown on 27/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public struct SceneGraphNodeType: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
    
        self.rawValue = rawValue
    }

    public static let grid = SceneGraphNodeType(rawValue: 1 << 0)
    public static let chunk = SceneGraphNodeType(rawValue: 1 << 1)
    public static let tile = SceneGraphNodeType(rawValue: 1 << 2)
    public static let edge = SceneGraphNodeType(rawValue: 1 << 3)
    public static let layer = SceneGraphNodeType(rawValue: 1 << 4)
}

