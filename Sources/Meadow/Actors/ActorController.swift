//
//  ActorController.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import SceneKit

extension Actor {
    
    public enum ActorState: State {
        
        case idle
        case moving(path: Path)
        case pathfinding(destination: Coordinate)
        
        public func shouldTransition(to newState: Actor.ActorState) -> Should<Actor.ActorState> {
            
            return .continue
        }
    }
    
    public class ActorController: StateObserver<ActorState> {
        
        public func move(to coordinate: Coordinate) {
            
            state = .pathfinding(destination: coordinate)
        }
    }
}
