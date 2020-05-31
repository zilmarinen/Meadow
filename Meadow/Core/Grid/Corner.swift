//
//  Corner.swift
//  Meadow
//
//  Created by Zack Brown on 07/02/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

public struct Corner: Codable {
    
    enum Anchor: Int, Codable {
        
        case left
        case right
        case center
    }
    
    let anchor: Anchor
    let elevation: Int
}
