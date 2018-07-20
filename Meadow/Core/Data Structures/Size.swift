//
//  Size.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Size: Codable {
    
    public let width: Int
    public let height: Int
    public let depth: Int
    
    public init(width: Int, height: Int, depth: Int) {
        
        self.width = width
        self.height = height
        self.depth = depth
    }
}

extension Size: Hashable {
    
    public static func == (lhs: Size, rhs: Size) -> Bool {
        
        return lhs.width == rhs.width && lhs.height == rhs.height && lhs.depth == rhs.depth
    }
    
    public var hashValue: Int {
        
        return width ^ height ^ depth
    }
}

extension Size {
    
    public static var Zero: Size { return Size(width: 0, height: 0, depth: 0) }
    public static var One: Size { return Size(width: 1, height: 1, depth: 1) }
}
