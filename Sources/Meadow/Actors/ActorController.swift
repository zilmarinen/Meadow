//
//  ActorController.swift
//
//  Created by Zack Brown on 03/04/2021.
//

import SceneKit

extension Actor {
    
    public enum ActorState: MachineState {
        
        case idle
        case traversing(path: Path, current: PathNode, destination: PathNode)
        case pathfinding(destination: Coordinate)
        case spawn(coordinate: Coordinate)
        
        public func shouldTransition(to newState: Actor.ActorState) -> Should<Actor.ActorState> {
            
            return .continue
        }
    }
    
    public class ActorController: StateObserver<ActorState> {
        
        public func move(to coordinate: Coordinate) {
            
            state = .pathfinding(destination: coordinate)
        }
        
        public func spawn(at coordinate: Coordinate) {
            
            state = .spawn(coordinate: coordinate)
        }
    }
}
