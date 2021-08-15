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
    
    public static let buildings = SceneGraphCategory(rawValue: 1 << 15)
    public static let buildingChunk = SceneGraphCategory(rawValue: 1 << 16)
    
    public static let bridges = SceneGraphCategory(rawValue: 1 << 1)
    public static let bridgeChunk = SceneGraphCategory(rawValue: 1 << 2)
    
    public static let camera = SceneGraphCategory(rawValue: 1 << 3)
    
    public static let foliage = SceneGraphCategory(rawValue: 1 << 4)
    public static let foliageChunk = SceneGraphCategory(rawValue: 1 << 5)
    
    public static let seams = SceneGraphCategory(rawValue: 1 << 6)
    public static let seamChunk = SceneGraphCategory(rawValue: 1 << 7)
    public static let seamTile = SceneGraphCategory(rawValue: 1 << 8)
    
    public static let stairs = SceneGraphCategory(rawValue: 1 << 9)
    public static let stairChunk = SceneGraphCategory(rawValue: 1 << 10)
    
    public static let sun = SceneGraphCategory(rawValue: 1 << 11)
    
    public static let surface = SceneGraphCategory(rawValue: 1 << 12)
    public static let surfaceChunk = SceneGraphCategory(rawValue: 1 << 13)
    public static let surfaceTile = SceneGraphCategory(rawValue: 1 << 14)
    
    public static let walls = SceneGraphCategory(rawValue: 1 << 17)
    public static let wallChunk = SceneGraphCategory(rawValue: 1 << 18)
    public static let wallTile = SceneGraphCategory(rawValue: 1 << 19)
}
