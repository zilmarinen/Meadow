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
    
    public static let actors = SceneGraphCategory(rawValue: 1 << 0)
    public static let actor = SceneGraphCategory(rawValue: 1 << 1)
    public static let area = SceneGraphCategory(rawValue: 1 << 2)
    public static let areaChunk = SceneGraphCategory(rawValue: 1 << 3)
    public static let areaTile = SceneGraphCategory(rawValue: 1 << 4)
    public static let camera = SceneGraphCategory(rawValue: 1 << 5)
    public static let floor = SceneGraphCategory(rawValue: 1 << 6)
    public static let foliage = SceneGraphCategory(rawValue: 1 << 7)
    public static let foliageChunk = SceneGraphCategory(rawValue: 1 << 8)
    public static let foliageTile = SceneGraphCategory(rawValue: 1 << 9)
    public static let footpath = SceneGraphCategory(rawValue: 1 << 10)
    public static let footpathChunk = SceneGraphCategory(rawValue: 1 << 11)
    public static let footpathTile = SceneGraphCategory(rawValue: 1 << 12)
    public static let hero = SceneGraphCategory(rawValue: 1 << 13)
    public static let meadow = SceneGraphCategory(rawValue: 1 << 14)
    public static let npcs = SceneGraphCategory(rawValue: 1 << 15)
    public static let npc = SceneGraphCategory(rawValue: 1 << 16)
    public static let portals = SceneGraphCategory(rawValue: 1 << 17)
    public static let portal = SceneGraphCategory(rawValue: 1 << 18)
    public static let props = SceneGraphCategory(rawValue: 1 << 19)
    public static let prop = SceneGraphCategory(rawValue: 1 << 20)
    public static let scene = SceneGraphCategory(rawValue: 1 << 21)
    public static let terrain = SceneGraphCategory(rawValue: 1 << 22)
    public static let terrainChunk = SceneGraphCategory(rawValue: 1 << 23)
    public static let terrainTile = SceneGraphCategory(rawValue: 1 << 24)
}
