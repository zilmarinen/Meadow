//
//  Size.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

struct Size {
    
    public let width: Int
    public let depth: Int
    public let height: Int
}

extension Size {
    
    public static var zero: Size { return Size(width: 0, depth: 0, height: 0) }
}

extension Size: Equatable {
    
    static func == (lhs: Size, rhs: Size) -> Bool {
        
        return lhs.width == rhs.width && lhs.depth == rhs.depth && lhs.height == rhs.height
    }
}

extension Size: Hashable {
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(width)
        hasher.combine(depth)
        hasher.combine(height)
    }
}
