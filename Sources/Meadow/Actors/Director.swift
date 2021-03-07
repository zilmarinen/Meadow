//
//  Director.swift
//
//  Created by Zack Brown on 02/01/2021.
//

extension Actor {
    
    enum ActorState: State {
        
        case idle(actor: Actor)
        case interacting(actor: Actor, interactive: Interactive, slot: InteractionSlot)
        case travelling(actor: Actor, path: Path, interactive: Interactive?)
        
        public func shouldTransition(to newState: ActorState) -> Should<ActorState> {
            
            return .continue
        }
    }
    
    class Director: StateObserver<ActorState> {
        
        func idle() {
            
            switch state {

            case .interacting(let actor, let interactive, let slot):

                interactive.release(slot: slot)

                state = .idle(actor: actor)

            case .travelling(let actor, _, _):
                
                state = .idle(actor: actor)
                
            default: break
            }
        }
        
        func interact(interactive: Interactive, node: GridNode) {
            
            switch state {

            case .interacting(let actor, let currentInteractive, let slot):

                currentInteractive.release(slot: slot)
                
                fallthrough
                
            case .travelling(let actor, _, _):
                
                guard let slot = interactive.claim(node: node, actor: actor) else {
                    
                    state = .idle(actor: actor)
                    
                    break
                }
                
                state = .interacting(actor: actor, interactive: interactive, slot: slot)

            default: break
            }
        }
    }
}
