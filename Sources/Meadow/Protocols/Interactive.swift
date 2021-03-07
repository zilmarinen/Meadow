//
//  Interactive.swift
//
//  Created by Zack Brown on 02/01/2021.
//

protocol Interactive: class {
    
    var footprint: Footprint { get }
    
    var pointsOfAccess: [GridNode] { get }
    
    var slots: [InteractionSlot] { get set }
    
    func claim(node: GridNode, actor: Actor) -> InteractionSlot?
    func release(slot: InteractionSlot)
}

extension Interactive {
    
    func claim(node: GridNode, actor: Actor) -> InteractionSlot? {
        
        guard pointsOfAccess.contains(node),
              slots.first(where: { $0.node == node }) == nil else { return nil }
        
        let slot = InteractionSlot(node: node, actor: actor)
        
        slots.append(slot)
        
        return slot
    }
    
    func release(slot: InteractionSlot) {
        
        guard let index = slots.firstIndex(of: slot) else { return }
        
        slots.remove(at: index)
    }
}
