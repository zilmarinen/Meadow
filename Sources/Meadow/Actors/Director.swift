//
//  Director.swift
//
//  Created by Zack Brown on 02/01/2021.
//

extension Actor {
    
    enum ActorState: State {
        
        case idle
        case interacting(interactive: Interactive, slot: InteractionSlot)
        case travelling(path: Path, interactive: Interactive?)
        
        public func shouldTransition(to newState: ActorState) -> Should<ActorState> {
            
            return .continue
        }
    }
    
    class Director: StateObserver<ActorState> {
        
        func idle() {
            
            switch state {
            
            case .interacting(let interactive, let slot):
                
                interactive.release(slot: slot)
                
                fallthrough
                
            default:
                
                state = .idle
            }
        }
        
        func interact(interactive: Interactive, slot: InteractionSlot) {
            
            switch state {
            
            case .interacting(let interactive, let slot):
                
                interactive.release(slot: slot)
                
                fallthrough
                
            default:
                
                state = .interacting(interactive: interactive, slot: slot)
            }
        }
    }
}
