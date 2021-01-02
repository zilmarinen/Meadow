//
//  Interactive.swift
//
//  Created by Zack Brown on 02/01/2021.
//

protocol Interactive {
    
    var footprint: Footprint { get }
    
    var pointsOfAccess: [GridNode] { get }
    
    var slots: [InteractionSlot] { get }
    
    func claim(node: GridNode, actor: Actor) -> InteractionSlot?
    func release(slot: InteractionSlot)
}

extension Interactive {
    
    func claim(node: GridNode, actor: Actor) -> InteractionSlot? {
        
        return nil
    }
    
    func release(slot: InteractionSlot) {
        
    }
}
