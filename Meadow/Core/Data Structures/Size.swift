//
//  Size.swift
//  Meadow
//
//  Created by Zack Brown on 30/04/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

public struct Size {
    
    let width: Int
    let height: Int
    let depth: Int
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
    
    static var Zero: Size { return Size(width: 0, height: 0, depth: 0) }
    static var One: Size { return Size(width: 1, height: 1, depth: 1) }
}
