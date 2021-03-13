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
    
    public static let camera = SceneGraphCategory(rawValue: 1 << 1)
    public static let surface = SceneGraphCategory(rawValue: 1 << 2)
    public static let surfaceChunk = SceneGraphCategory(rawValue: 1 << 3)
    public static let surfaceTile = SceneGraphCategory(rawValue: 1 << 4)
    
}
