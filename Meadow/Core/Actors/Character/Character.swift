//
//  Character.swift
//  Meadow
//
//  Created by Zack Brown on 12/04/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

public struct Character {
    
    enum BodyShape {
        
        case thin
        case fat
    }
    
    struct Attire: Equatable {
        
        var head: Int
        var upper: Int
        var lower: Int
        var feet: Int
    }
    
    struct Abilities: Equatable {
        
        var motivation: Int
        var creativity: Int
        var resolve: Int
    }

    let forename: String
    let surname: String
    
    var name: String { return "\(forename) \(surname)" }
    
    let bodyShape: BodyShape
    
    var attire: Attire
    
    var abilities: Abilities
}

extension Character: Equatable {
    
    public static func ==(lhs: Character, rhs: Character) -> Bool {
        
        return lhs.name == rhs.name && lhs.bodyShape == rhs.bodyShape && lhs.attire == rhs.attire && lhs.abilities == rhs.abilities
    }
}
