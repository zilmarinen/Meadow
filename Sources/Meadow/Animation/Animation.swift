//
//  Animation.swift
//
//  Created by Zack Brown on 03/01/2021.
//

struct Animation {
    
    enum Name: String {
        
        case idle
    }
    
    let frames: [KeyFrame]
    
    init(named: Name) {
        
        self.frames = []
    }
}
