//
//  ActorStateMachine.swift
//  Meadow
//
//  Created by Zack Brown on 17/06/2019.
//  Copyright © 2019 Script Orchard. All rights reserved.
//

extension Actor {
    
    public enum ActorState: State {
        
        case idle(world: World)
        case walking(world: World, path: Path, node: PathNode)
        case pathfinding(world: World, origin: PathNode.PathLocus, destination: PathNode.PathLocus)
        
        public func shouldTransition(to newState: Actor.ActorState) -> Should<Actor.ActorState> {
            
            return .continue
        }
    }
    
    public class ActorStateMachine: StateObserver<ActorState> {
        
    }
}
