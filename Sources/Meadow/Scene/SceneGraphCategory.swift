//
//  SceneGraphCategory.swift
//
//  Created by Zack Brown on 05/11/2020.
//

public struct SceneGraphCategory: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        
        self.rawValue = rawValue
    }
    
    public static let camera = SceneGraphCategory(rawValue: 1 << 0)
    public static let footpath = SceneGraphCategory(rawValue: 1 << 1)
    public static let footpathChunk = SceneGraphCategory(rawValue: 1 << 2)
    public static let footpathTile = SceneGraphCategory(rawValue: 1 << 3)
    public static let meadow = SceneGraphCategory(rawValue: 1 << 4)
    public static let scene = SceneGraphCategory(rawValue: 1 << 5)
    public static let terrain = SceneGraphCategory(rawValue: 1 << 6)
    public static let terrainChunk = SceneGraphCategory(rawValue: 1 << 7)
    public static let terrainTile = SceneGraphCategory(rawValue: 1 << 8)
}
