//
//  Meadow+Math.swift
//  Meadow
//
//  Created by Zack Brown on 27/01/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

enum Sign {
    
    case negative
    case zero
    case positive
}

func sign(_ value: MDWFloat) -> Sign {
    
    if value == 0 { return .zero }
    
    if value > 0 { return .positive }
    
    return .negative
}

func sign(_ value: Int) -> Sign {
    
    if value == 0 { return .zero }
    
    if value > 0 { return .positive }
    
    return .negative
}
