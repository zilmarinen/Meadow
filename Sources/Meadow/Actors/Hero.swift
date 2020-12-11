//
//  Hero.swift
//
//  Created by Zack Brown on 10/12/2020.
//

import Foundation

public class Hero: Actor {
    
    private enum CodingKeys: CodingKey {
        
    }
    
    public override var category: Int { SceneGraphCategory.hero.rawValue }
    
    override init() {
        
        super.init()
        
        name = "Hero"
        
        categoryBitMask = category
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //
        
        super.init()
        
        categoryBitMask = category
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
