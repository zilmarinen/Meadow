//
//  Size.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Size<T>: Codable where T: Codable, T: Hashable, T: Numeric {
    
    public let width: T
    public let height: T
    public let depth: T
    
    public init(width: T, height: T, depth: T) {
        
        self.width = width
        self.height = height
        self.depth = depth
    }
}

extension Size: Hashable {
    
    public static func == (lhs: Size, rhs: Size) -> Bool {
        
        return lhs.width == rhs.width && lhs.height == rhs.height && lhs.depth == rhs.depth
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(depth)
    }
}

extension Size {
    
    public static var zero: Size { return Size(width: 0, height: 0, depth: 0) }
    public static var one: Size { return Size(width: 1, height: 1, depth: 1) }
}
