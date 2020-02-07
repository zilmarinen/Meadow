//
//  Corner.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

struct Corner {
    
    enum Anchor {
        
        case left
        case right
        case center
    }
    
    let anchor: Anchor
    let elevation: Int
}
