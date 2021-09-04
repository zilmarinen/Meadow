//
//  ActorAppearance.swift
//
//  Created by Zack Brown on 27/08/2021.
//

public struct ActorAppearance: Codable, Hashable {
    
    static let `default` = ActorAppearance(colors: .default)
    
    public struct Colors: Codable, Hashable {
        
        static let `default` = Colors(hair: .white, torso: .black)
        
        public let hair: Color
        public let torso: Color
    }
    
    public let colors: Colors
}
